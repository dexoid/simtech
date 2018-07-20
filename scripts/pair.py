#!/usr/bin/python
import os
import sys
import re
from subprocess import Popen, PIPE

# Master address
saltmaster='192.168.20.200'

# Salt repo
saltrepopackage={ '6': 'https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el6.noarch.rpm',
                  '7': 'https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest-2.el7.noarch.rpm'
                }

def detect_rhel_version(hostname):
  rhel_version=os.popen('''ssh {0} "cat /etc/system-release-cpe | cut -d':' -f5"'''.format(hostname))
  return rhel_version.read()[0]

def install_package(hostname, package):
  rhel_version=detect_rhel_version(hostname)
  os.system('ssh {0} "yum -y install {1}"'.format(hostname,package))

def restart_salt_minion(hostname, rhel_version):
  if rhel_version == '7':
    os.system('ssh {0} "systemctl restart salt-minion"'.format(hostname))
  elif rhel_version == '6':
    os.system('ssh {0} "/etc/init.d/salt-minion restart"'.format(hostname))

try:
  hostname='root@'+sys.argv[1]
  rhel_version=detect_rhel_version(hostname)
  for package in 'epel-release', saltrepopackage.get(rhel_version), 'salt-minion':
    install_package(hostname, package)

  os.system('''ssh {0} "sed -i 's/^#*master:\s.*/master: {1}/g' /etc/salt/minion"'''.format(hostname, saltmaster))
  restart_salt_minion(hostname, rhel_version)
  salt_get_masterkey_str='salt-key -f {0}'.format(sys.argv[1])
  salt_get_clientkey_str='ssh {0} "salt-call key.finger --local"'.format(sys.argv[1])
except IndexError:
  print('Please usage: {0} minion_hostname'.format(sys.argv[0]))
  exit(1)

salt_key_master=os.popen(salt_get_masterkey_str).read()
salt_key_client=os.popen(salt_get_clientkey_str).read()

ptr=re.compile('[0-9a-f:]{95}')

check = [x for x in re.findall(ptr,salt_key_master) if x in re.findall(ptr,salt_key_client)]

if check:
#os.system('salt-key -a {0}'.format(sys.argv[1]))
  cmd='salt-key -a {0}'.format(sys.argv[1])
  execute = Popen(cmd.split(), stdout=PIPE, stdin=PIPE, stderr=PIPE)
  execute.stdin.write("Y")
