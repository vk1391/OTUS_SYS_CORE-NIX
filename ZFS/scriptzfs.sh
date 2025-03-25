#! /bin/bash
sudo apt install zfsutils-linux -y
sudo zpool create otus1 mirror /dev/sdb /dev/sdc
sudo zpool create otus2 mirror /dev/sdd /dev/sde
sudo zpool create otus3 mirror /dev/sdf /dev/sdg
sudo zpool create otus4 mirror /dev/sdh /dev/sdi
sudo zpool list
