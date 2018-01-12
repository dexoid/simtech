#!/usr/bin/python
import os,sys,re

try:
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
	os.system('salt-key -a {0}'.format(sys.argv[1]))
