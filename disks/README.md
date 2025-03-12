# Дисковая подсистема
## Задача:
 - Добавить в виртуальную машину несколько дисков

 - Собрать RAID-0/1/5/10 на выбор

 - Сломать и починить RAID

 - Создать GPT таблицу, пять разделов и смонтировать их в системе.

1. Было добавлено 3 жестких диска, решил собрать RAID5:
```
vk@vk:~$ lsblk
NAME                 MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0                  7:0    0  73.9M  1 loop /snap/core22/1722
loop1                  7:1    0  73.9M  1 loop /snap/core22/1748
loop2                  7:2    0 144.5M  1 loop /snap/docker/3064
loop3                  7:3    0  38.8M  1 loop /snap/snapd/21759
loop4                  7:4    0  44.4M  1 loop /snap/snapd/23545
loop5                  7:5    0 139.6M  1 loop /snap/docker/2976
sda                    8:0    0    25G  0 disk
├─sda1                 8:1    0     1M  0 part
├─sda2                 8:2    0     2G  0 part /boot
└─sda3                 8:3    0    23G  0 part
  └─ubuntu--vg-lv--0 252:0    0    23G  0 lvm  /
sdb                    8:16   0   5.7G  0 disk
sdc                    8:32   0     6G  0 disk
sdd                    8:48   0   5.8G  0 disk
```
```
sudo mdadm --create --verbose /dev/md0 -l 5 -n 3 /dev/sd{b,c,d}
[sudo] password for vk:
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 512K
mdadm: size set to 5971456K
mdadm: largest drive (/dev/sdc) exceeds size (5971456K) by more than 1%
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
vk@vk:~$ cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md0 : active raid5 sdd[3] sdc[1] sdb[0]
      11942912 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [UU_]
      [===============>.....]  recovery = 79.9% (4773300/5971456) finish=0.1min speed=153977K/sec

unused devices: <none>
vk@vk:~$ sudo mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Wed Mar 12 11:12:05 2025
        Raid Level : raid5
        Array Size : 11942912 (11.39 GiB 12.23 GB)
     Used Dev Size : 5971456 (5.69 GiB 6.11 GB)
      Raid Devices : 3
     Total Devices : 3
       Persistence : Superblock is persistent

       Update Time : Wed Mar 12 11:12:45 2025
             State : clean
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : vk:0  (local to host vk)
              UUID : b444d38c:7aa1772c:49df911a:0254f6ae
            Events : 18

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       3       8       48        2      active sync   /dev/sdd
```
 - создал таблицу разделов GPT:
```
vk@vk:~$ sudo parted -s /dev/md0 mklabel gpt
```
 - создал 5 разделов
```
vk@vk:~$ sudo parted /dev/md0 mkpart primary ext4 0% 20%
Information: You may need to update /etc/fstab.

vk@vk:~$ sudo parted /dev/md0 mkpart primary ext4 20% 40%
Information: You may need to update /etc/fstab.

vk@vk:~$ sudo parted /dev/md0 mkpart primary ext4 40% 60%
Information: You may need to update /etc/fstab.

vk@vk:~$ sudo parted /dev/md0 mkpart primary ext4 60% 80%
Information: You may need to update /etc/fstab.

vk@vk:~$ sudo parted /dev/md0 mkpart primary ext4 80% 100%
Information: You may need to update /etc/fstab.

vk@vk:~$ sudo parted /dev/md0 print
Model: Linux Software RAID Array (md)
Disk /dev/md0: 12.2GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name     Flags
 1      1049kB  2446MB  2445MB               primary
 2      2446MB  4892MB  2445MB               primary
 3      4892MB  7338MB  2446MB               primary
 4      7338MB  9783MB  2445MB               primary
 5      9783MB  12.2GB  2445MB               primary
```
 - отформатировал разделы в ext4, примонтировал разделы к файловой системе:
```
vk@vk:~$ lsblk
NAME                 MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
loop0                  7:0    0  73.9M  1 loop  /snap/core22/1722
loop1                  7:1    0  73.9M  1 loop  /snap/core22/1748
loop2                  7:2    0 144.5M  1 loop  /snap/docker/3064
loop3                  7:3    0  38.8M  1 loop  /snap/snapd/21759
loop4                  7:4    0  44.4M  1 loop  /snap/snapd/23545
loop5                  7:5    0 139.6M  1 loop  /snap/docker/2976
sda                    8:0    0    25G  0 disk
├─sda1                 8:1    0     1M  0 part
├─sda2                 8:2    0     2G  0 part  /boot
└─sda3                 8:3    0    23G  0 part
  └─ubuntu--vg-lv--0 252:0    0    23G  0 lvm   /
sdb                    8:16   0   5.7G  0 disk
└─md0                  9:0    0  11.4G  0 raid5
  ├─md0p1            259:0    0   2.3G  0 part  /mnt/1
  ├─md0p2            259:1    0   2.3G  0 part  /mnt/2
  ├─md0p3            259:2    0   2.3G  0 part  /mnt/3
  ├─md0p4            259:3    0   2.3G  0 part  /mnt/4
  └─md0p5            259:4    0   2.3G  0 part  /mnt/5
sdc                    8:32   0     6G  0 disk
└─md0                  9:0    0  11.4G  0 raid5
  ├─md0p1            259:0    0   2.3G  0 part  /mnt/1
  ├─md0p2            259:1    0   2.3G  0 part  /mnt/2
  ├─md0p3            259:2    0   2.3G  0 part  /mnt/3
  ├─md0p4            259:3    0   2.3G  0 part  /mnt/4
  └─md0p5            259:4    0   2.3G  0 part  /mnt/5
sdd                    8:48   0   5.8G  0 disk
└─md0                  9:0    0  11.4G  0 raid5
  ├─md0p1            259:0    0   2.3G  0 part  /mnt/1
  ├─md0p2            259:1    0   2.3G  0 part  /mnt/2
  ├─md0p3            259:2    0   2.3G  0 part  /mnt/3
  ├─md0p4            259:3    0   2.3G  0 part  /mnt/4
  └─md0p5            259:4    0   2.3G  0 part  /mnt/5

vk@vk:~$ sudo mkfs.ext4 /dev/md0p1
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 596992 4k blocks and 149264 inodes
Filesystem UUID: 7409083e-b45e-48ed-8e07-c5926d182dff
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

vk@vk:~$ sudo mkfs.ext4 /dev/md0p2
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 596992 4k blocks and 149264 inodes
Filesystem UUID: 62d7ab86-3642-4748-98e1-b87f9e77f0fb
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

vk@vk:~$ sudo mkfs.ext4 /dev/md0p3
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 597248 4k blocks and 149568 inodes
Filesystem UUID: f05488e3-b24b-4196-ae41-22fa4d4a0129
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

vk@vk:~$ sudo mkfs.ext4 /dev/md0p4
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 596992 4k blocks and 149264 inodes
Filesystem UUID: c82888e4-c7c9-46aa-ad28-4a6714b8b4fd
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

vk@vk:~$ sudo mkfs.ext4 /dev/md0p5
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 596992 4k blocks and 149264 inodes
Filesystem UUID: b2ad033e-ed59-44df-b363-81f823c8d617
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

vk@vk:~$ sudo mkdir /mnt/1
vk@vk:~$ sudo mkdir /mnt/2
vk@vk:~$ sudo mkdir /mnt/3
vk@vk:~$ sudo mkdir /mnt/4
vk@vk:~$ sudo mkdir /mnt/5
vk@vk:~$ sudo mount /dev/md0p1 /mnt/1
vk@vk:~$ sudo mount /dev/md0p2 /mnt/2
vk@vk:~$ sudo mount /dev/md0p3 /mnt/3
vk@vk:~$ sudo mount /dev/md0p4 /mnt/4
vk@vk:~$ sudo mount /dev/md0p5 /mnt/5
```
 - наполнил 1 и 5 раздел данными:
```
sudo cp -r /var/log/* /mnt/1
sudo cp -r /var/log/* /mnt/5
vk@vk:~$ df -h
Filesystem                    Size  Used Avail Use% Mounted on
tmpfs                         392M  1.6M  390M   1% /run
/dev/mapper/ubuntu--vg-lv--0   23G   18G  3.4G  85% /
tmpfs                         2.0G  1.1M  2.0G   1% /dev/shm
tmpfs                         5.0M     0  5.0M   0% /run/lock
/dev/sda2                     2.0G  285M  1.6G  16% /boot
tmpfs                         392M   12K  392M   1% /run/user/1000
/dev/md0p1                    2.2G  1.1G 1014M  52% /mnt/1
/dev/md0p2                    2.2G   24K  2.1G   1% /mnt/2
/dev/md0p3                    2.2G   24K  2.1G   1% /mnt/3
/dev/md0p4                    2.2G   24K  2.1G   1% /mnt/4
/dev/md0p5                    2.2G  1.1G 1014M  52% /mnt/5
```
 - сломал 1 диск, данные на месте:
```
vk@vk:~$ sudo mdadm /dev/md0 --fail /dev/sdc
mdadm: set /dev/sdc faulty in /dev/md0
vk@vk:~$ sudo mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Wed Mar 12 11:12:05 2025
        Raid Level : raid5
        Array Size : 11942912 (11.39 GiB 12.23 GB)
     Used Dev Size : 5971456 (5.69 GiB 6.11 GB)
      Raid Devices : 3
     Total Devices : 3
       Persistence : Superblock is persistent

       Update Time : Wed Mar 12 12:09:31 2025
             State : clean, degraded
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 1
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : vk:0  (local to host vk)
              UUID : b444d38c:7aa1772c:49df911a:0254f6ae
            Events : 25

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       -       0        0        1      removed
       3       8       48        2      active sync   /dev/sdd

       1       8       32        -      faulty   /dev/sdc
vk@vk:~$ ll /mnt
total 28
drwxr-xr-x  7 root root 4096 Mar 12 12:02 ./
drwxr-xr-x 23 root root 4096 Oct 25 06:46 ../
drwxr-xr-x 14 root root 4096 Mar 12 12:05 1/
drwxr-xr-x  3 root root 4096 Mar 12 12:01 2/
drwxr-xr-x  3 root root 4096 Mar 12 12:02 3/
drwxr-xr-x  3 root root 4096 Mar 12 12:02 4/
drwxr-xr-x 14 root root 4096 Mar 12 12:06 5/
vk@vk:~$ ll /mnt/1
total 79588
drwxr-xr-x 14 root root     4096 Mar 12 12:05 ./
drwxr-xr-x  7 root root     4096 Mar 12 12:02 ../
-rw-r--r--  1 root root        0 Mar 12 12:05 alternatives.log
-rw-r--r--  1 root root    11502 Mar 12 12:05 alternatives.log.1
-rw-r--r--  1 root root     4145 Mar 12 12:05 alternatives.log.2.gz
-rw-r-----  1 root root        0 Mar 12 12:05 apport.log
-rw-r-----  1 root root      372 Mar 12 12:05 apport.log.1
drwxr-xr-x  2 root root     4096 Mar 12 12:05 apt/
-rw-r-----  1 root root    25806 Mar 12 12:05 auth.log
-rw-r-----  1 root root    53180 Mar 12 12:05 auth.log.1
-rw-r-----  1 root root      646 Mar 12 12:05 auth.log.2.gz
-rw-r-----  1 root root    10325 Mar 12 12:05 auth.log.3.gz
-rw-r-----  1 root root    24314 Mar 12 12:05 auth.log.4.gz
-rw-r--r--  1 root root    61229 Mar 12 12:05 bootstrap.log
-rw-r-----  1 root root      384 Mar 12 12:05 btmp
-rw-r-----  1 root root        0 Mar 12 12:05 btmp.1
-rw-r-----  1 root root    86059 Mar 12 12:05 cloud-init.log
-rw-r-----  1 root root     4630 Mar 12 12:05 cloud-init-output.log
drwxr-xr-x  2 root root     4096 Mar 12 12:05 dist-upgrade/
-rw-r-----  1 root root    54657 Mar 12 12:05 dmesg
-rw-r-----  1 root root    54799 Mar 12 12:05 dmesg.0
-rw-r-----  1 root root    16315 Mar 12 12:05 dmesg.1.gz
-rw-r-----  1 root root    16235 Mar 12 12:05 dmesg.2.gz
-rw-r-----  1 root root    15682 Mar 12 12:05 dmesg.3.gz
-rw-r-----  1 root root    16135 Mar 12 12:05 dmesg.4.gz
-rw-r--r--  1 root root    97517 Mar 12 12:05 dpkg.log
-rw-r--r--  1 root root     3167 Mar 12 12:05 dpkg.log.1
-rw-r--r--  1 root root     1118 Mar 12 12:05 dpkg.log.2.gz
-rw-r--r--  1 root root    65439 Mar 12 12:05 dpkg.log.3.gz
-rw-r--r--  1 root root        0 Mar 12 12:05 faillog
-rw-r--r--  1 root root     3737 Mar 12 12:05 fontconfig.log
drwxr-x---  4 root root     4096 Mar 12 12:05 installer/
drwxr-xr-x  3 root root     4096 Mar 12 12:05 journal/
-rw-r-----  1 root root   212823 Mar 12 12:05 kern.log
-rw-r-----  1 root root    91913 Mar 12 12:05 kern.log.1
-rw-r-----  1 root root    17292 Mar 12 12:05 kern.log.2.gz
-rw-r-----  1 root root    42209 Mar 12 12:05 kern.log.3.gz
-rw-r-----  1 root root    74612 Mar 12 12:05 kern.log.4.gz
drwxr-xr-x  2 root root     4096 Mar 12 12:05 landscape/
-rw-r--r--  1 root root   292292 Mar 12 12:05 lastlog
drwx------  2 root root    16384 Mar 12 12:01 lost+found/
-rw-r-----  1 root root     1270 Mar 12 12:05 mail.log
-rw-r-----  1 root root     1856 Mar 12 12:05 mail.log.1
-rw-r-----  1 root root      199 Mar 12 12:05 mail.log.2.gz
-rw-r-----  1 root root      630 Mar 12 12:05 mail.log.3.gz
-rw-r-----  1 root root      897 Mar 12 12:05 mail.log.4.gz
drwxr-xr-x  2 root root     4096 Mar 12 12:05 nginx/
drwxr-xr-t  2 root root     4096 Mar 12 12:05 postgresql/
drwx------  2 root root     4096 Mar 12 12:05 private/
lrwxrwxrwx  1 root root       39 Mar 12 12:05 README -> ../../usr/share/doc/systemd/README.logs
drwxr-x---  2 root root     4096 Mar 12 12:05 redis/
-rw-r-----  1 root root  5376482 Mar 12 12:05 syslog
-rw-r-----  1 root root 38726330 Mar 12 12:05 syslog.1
-rw-r-----  1 root root    66725 Mar 12 12:05 syslog.2.gz
-rw-r-----  1 root root 10190960 Mar 12 12:05 syslog.3.gz
-rw-r-----  1 root root 25879784 Mar 12 12:05 syslog.4.gz
drwxr-xr-x  2 root root     4096 Mar 12 12:05 sysstat/
-rw-r--r--  1 root root        0 Mar 12 12:05 ubuntu-advantage-apt-hook.log
drwxr-x---  2 root root     4096 Mar 12 12:05 unattended-upgrades/
-rw-r--r--  1 root root    21888 Mar 12 12:05 wtmp
vk@vk:~$ cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md0 : active raid5 sdd[3] sdc[1](F) sdb[0]
      11942912 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [U_U]

unused devices: <none>
vk@vk:~$ sudo mdadm /dev/md0 --remove /dev/sdc
mdadm: hot removed /dev/sdc from /dev/md0
vk@vk:~$ ll /mnt/1
total 79588
drwxr-xr-x 14 root root     4096 Mar 12 12:05 ./
drwxr-xr-x  7 root root     4096 Mar 12 12:02 ../
-rw-r--r--  1 root root        0 Mar 12 12:05 alternatives.log
-rw-r--r--  1 root root    11502 Mar 12 12:05 alternatives.log.1
-rw-r--r--  1 root root     4145 Mar 12 12:05 alternatives.log.2.gz
-rw-r-----  1 root root        0 Mar 12 12:05 apport.log
-rw-r-----  1 root root      372 Mar 12 12:05 apport.log.1
drwxr-xr-x  2 root root     4096 Mar 12 12:05 apt/
-rw-r-----  1 root root    25806 Mar 12 12:05 auth.log
-rw-r-----  1 root root    53180 Mar 12 12:05 auth.log.1
-rw-r-----  1 root root      646 Mar 12 12:05 auth.log.2.gz
-rw-r-----  1 root root    10325 Mar 12 12:05 auth.log.3.gz
-rw-r-----  1 root root    24314 Mar 12 12:05 auth.log.4.gz
-rw-r--r--  1 root root    61229 Mar 12 12:05 bootstrap.log
-rw-r-----  1 root root      384 Mar 12 12:05 btmp
-rw-r-----  1 root root        0 Mar 12 12:05 btmp.1
-rw-r-----  1 root root    86059 Mar 12 12:05 cloud-init.log
-rw-r-----  1 root root     4630 Mar 12 12:05 cloud-init-output.log
drwxr-xr-x  2 root root     4096 Mar 12 12:05 dist-upgrade/
-rw-r-----  1 root root    54657 Mar 12 12:05 dmesg
-rw-r-----  1 root root    54799 Mar 12 12:05 dmesg.0
-rw-r-----  1 root root    16315 Mar 12 12:05 dmesg.1.gz
-rw-r-----  1 root root    16235 Mar 12 12:05 dmesg.2.gz
-rw-r-----  1 root root    15682 Mar 12 12:05 dmesg.3.gz
-rw-r-----  1 root root    16135 Mar 12 12:05 dmesg.4.gz
-rw-r--r--  1 root root    97517 Mar 12 12:05 dpkg.log
-rw-r--r--  1 root root     3167 Mar 12 12:05 dpkg.log.1
-rw-r--r--  1 root root     1118 Mar 12 12:05 dpkg.log.2.gz
-rw-r--r--  1 root root    65439 Mar 12 12:05 dpkg.log.3.gz
-rw-r--r--  1 root root        0 Mar 12 12:05 faillog
-rw-r--r--  1 root root     3737 Mar 12 12:05 fontconfig.log
drwxr-x---  4 root root     4096 Mar 12 12:05 installer/
drwxr-xr-x  3 root root     4096 Mar 12 12:05 journal/
-rw-r-----  1 root root   212823 Mar 12 12:05 kern.log
-rw-r-----  1 root root    91913 Mar 12 12:05 kern.log.1
-rw-r-----  1 root root    17292 Mar 12 12:05 kern.log.2.gz
-rw-r-----  1 root root    42209 Mar 12 12:05 kern.log.3.gz
-rw-r-----  1 root root    74612 Mar 12 12:05 kern.log.4.gz
drwxr-xr-x  2 root root     4096 Mar 12 12:05 landscape/
-rw-r--r--  1 root root   292292 Mar 12 12:05 lastlog
drwx------  2 root root    16384 Mar 12 12:01 lost+found/
-rw-r-----  1 root root     1270 Mar 12 12:05 mail.log
-rw-r-----  1 root root     1856 Mar 12 12:05 mail.log.1
-rw-r-----  1 root root      199 Mar 12 12:05 mail.log.2.gz
-rw-r-----  1 root root      630 Mar 12 12:05 mail.log.3.gz
-rw-r-----  1 root root      897 Mar 12 12:05 mail.log.4.gz
drwxr-xr-x  2 root root     4096 Mar 12 12:05 nginx/
drwxr-xr-t  2 root root     4096 Mar 12 12:05 postgresql/
drwx------  2 root root     4096 Mar 12 12:05 private/
lrwxrwxrwx  1 root root       39 Mar 12 12:05 README -> ../../usr/share/doc/systemd/README.logs
drwxr-x---  2 root root     4096 Mar 12 12:05 redis/
-rw-r-----  1 root root  5376482 Mar 12 12:05 syslog
-rw-r-----  1 root root 38726330 Mar 12 12:05 syslog.1
-rw-r-----  1 root root    66725 Mar 12 12:05 syslog.2.gz
-rw-r-----  1 root root 10190960 Mar 12 12:05 syslog.3.gz
-rw-r-----  1 root root 25879784 Mar 12 12:05 syslog.4.gz
drwxr-xr-x  2 root root     4096 Mar 12 12:05 sysstat/
-rw-r--r--  1 root root        0 Mar 12 12:05 ubuntu-advantage-apt-hook.log
drwxr-x---  2 root root     4096 Mar 12 12:05 unattended-upgrades/
-rw-r--r--  1 root root    21888 Mar 12 12:05 wtmp
vk@vk:~$ ll /mnt
total 28
drwxr-xr-x  7 root root 4096 Mar 12 12:02 ./
drwxr-xr-x 23 root root 4096 Oct 25 06:46 ../
drwxr-xr-x 14 root root 4096 Mar 12 12:05 1/
drwxr-xr-x  3 root root 4096 Mar 12 12:01 2/
drwxr-xr-x  3 root root 4096 Mar 12 12:02 3/
drwxr-xr-x  3 root root 4096 Mar 12 12:02 4/
drwxr-xr-x 14 root root 4096 Mar 12 12:06 5/
vk@vk:~$ sudo mdadm --zero-superblock /dev/sdc
```
 - добавил обратно:
```
vk@vk:~$ sudo mdadm /dev/md0 --add /dev/sdc
mdadm: added /dev/sdc
vk@vk:~$ sudo mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Wed Mar 12 11:12:05 2025
        Raid Level : raid5
        Array Size : 11942912 (11.39 GiB 12.23 GB)
     Used Dev Size : 5971456 (5.69 GiB 6.11 GB)
      Raid Devices : 3
     Total Devices : 3
       Persistence : Superblock is persistent

       Update Time : Wed Mar 12 12:12:27 2025
             State : clean, degraded, recovering
    Active Devices : 2
   Working Devices : 3
    Failed Devices : 0
     Spare Devices : 1

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

    Rebuild Status : resync

              Name : vk:0  (local to host vk)
              UUID : b444d38c:7aa1772c:49df911a:0254f6ae
            Events : 32

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       4       8       32        1      active sync   /dev/sdc
       3       8       48        2      active sync   /dev/sdd
```
