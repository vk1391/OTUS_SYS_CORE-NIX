#! /bin/bash
sudo apt install nfs-common nmap -y
sudo export ipv4='nmap --open  10.0.2.0/24 -oG - -p 111 | awk '{print $2}' | head -2 | tail +2'
sudo echo "'$ipv4':/share/ /mnt nfs vers=3,noauto,x-systemd.automount 0 0" >> /etc/fstab
sudo systemctl daemon-reload
sudo systemctl restart remote-fs.target
sudo systemctl enable remote-fs.target
