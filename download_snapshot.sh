#!/bin/bash
# $1 - server
pass=r00tme
HOST_IP=10.109.2.2
ssh_file=known_hosts

ssh -t -t $1 "touch ~/.ssh/${ssh_file} && ssh-keygen -R ${HOST_IP} && ssh-keyscan ${HOST_IP} >> ~/.ssh/${ssh_file} && sshpass -p $pass ssh -t -t root@${HOST_IP} \"mkdir -p root_snapshot; fuel snapshot --dir root_snapshot \""
abra=$(ssh -t -t $1 "sshpass -p $pass ssh root@${HOST_IP} \"cd root_snapshot; ls | grep fuel-snapshot | tail -n1\""| tr -d [:cntrl:])
ssh -t -t $1 "sshpass -p $pass scp -r root@${HOST_IP}:/root/root_snapshot/${abra} ."

if  [[ $# -eq 1 ]] ; then
    scp -r $1:${abra} .
fi

if  [[ $# -eq 2 ]] ; then
    ssh -t -t $1 "scp -r $2:${abra} ."
fi

ssh -t -t $1 "rm ${abra}"
