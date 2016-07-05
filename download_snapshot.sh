#!/bin/bash
# $1 - server, $2 - fuel

if  [[ $# -ne 2 ]] ; then
    echo "Please enter 2 arguments, not" $#
    exit
fi

ssh -t -t $1 "sshpass -p <pass> ssh -t -t root@$2 \"mkdir -p root_snapshot; fuel snapshot --dir root_snapshot \""
abra=$(ssh -t -t $1 "sshpass -p <pass> ssh root@$2 \"cd root_snapshot; ls | grep fuel-snapshot | tail -n1\""| tr -d [:cntrl:])
ssh -t -t $1 "sshpass -p <pass> scp -r root@$2:/root/root_snapshot/${abra} ."
scp -r $1:${abra} .
ssh -t -t $1 "rm ${abra}"
