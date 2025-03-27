#! /bin/bash
sudo apt install nfs-kernel-server nmap -y
export ipv4=`nmap --open  10.0.2.0/24 -oG - -p 111 | awk '{print $2}' | head -2 | tail +2`
sudo mkdir /share
sudo chown -R nobody:nogroup /share
sudo chmod 0777 /share
sudo echo '/share '$ipv4'/32(rw,sync,root_squash)'>> /etc/exports
sudo exportfs -rs
