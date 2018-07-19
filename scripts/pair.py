#!/usr/bin/python
import os
import sys
import re
from subprocess import Popen, PIPE

# Salestack repo
saltrepopackage='https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest-2.el7.noarch.rpm'
# Master address
saltmaster='192.168.20.200'

def install_package(hostname, saltrepopackage):
  os.system('ssh {0} "yum -y install {1}"'.format(hostname, saltrepopackage))

try:
  hostname='root@'+sys.argv[1]
  for package in 'epel-release', saltrepopackage, 'salt-minion':
    install_package(hostname, package)

  os.system('''ssh {0} "sed -i 's/^#*master:\s.*/master: {1}/g' /etc/salt/minion"'''.format(hostname, saltmaster))
  os.system('ssh {0} "systemctl restart salt-minion"'.format(hostname))

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
