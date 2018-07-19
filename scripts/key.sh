#!/bin/bash
pubkey=$HOME/.ssh/id_rsa.pub
if [ ! -f "$pubkey" ]; then
ssh-keygen	
fi
ssh-copy-id -i $pubkey $1
