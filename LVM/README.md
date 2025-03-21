# Файловые системы и LVM - 1
## Цель:
1. Уменьшить том под / до 22G.
2. Выделить том под /home.
3. Выделить том под /var - сделать в mirror.
4. /home - сделать том для снапшотов.
5. Прописать монтирование в fstab. Попробовать с разными опциями и разными файловыми системами (на выбор).
6. Работа со снапшотами:
 - сгенерить файлы в /home/;
 - снять снапшот;
 - удалить часть файлов;
 - восстановится со снапшота.
### 1.Уменьшить том под / до 22G
Что бы уменьшить том , где находится корень необходимо перенести все данные на другой диск подходящего размера и пересоздать LV с необходимым размером.
 - узнал сколько занимает /:
```
 du -sh /
21G     /
```
 - добавил диск sdb 22G.
 - необходимо выполнить следующие манипуляции:
создал pv,vg,lv на sdb для выполнения данной манипуляции
```
pvcreate /dev/sdb # создал PV
```
```
vgcreate vg_root /dev/sdb #создал VG
```
```
lvcreate -n lv_root -l +100%FREE /dev/vg_root # создал LV
```
```
mkfs.ext4 /dev/vg_root/lv_root # отформатировал диск в файловую систему ext4
```
```
mount /dev/vg_root/lv_root /mnt
rsync -avxHAX --progress / /mnt/ # примонтировал диск к папке mnt, скопировал в эту папрку весь корень(/)
```
```
for i in /proc/ /sys/ /dev/ /run/ /boot/; \
 do mount --bind $i /mnt/$i; done # обращение к файлам папок proc,sys,dev,run,boot через новый корень /mnt(/mnt/proc/, mnt/boot etc) 
```
```
chroot /mnt/ # меняем корневой каталог на /mnt
grub-mkconfig -o /boot/grub/grub.cfg # генерируем новую конфигурацию grub, проверяем на ошибки
```
```
update-initramfs -u # обновляем образ файловой системы, загруженный в ram, так как у нас поменялось расположение корневого каталога
```
```
reboot
```
```
lvremove /dev/ubuntu-vg/lv-0 # удаляем существующий LV
```
```
lvcreate -n ubuntu-vg/ubuntu-lv -L 22G /dev/ubuntu-vg # создаем новый уменьшеный LV
```
```
mkfs.ext4 /dev/ubuntu-vg/ubuntu-lv 
mount /dev/ubuntu-vg/ubuntu-lv /mnt
rsync -avxHAX --progress / /mnt/
 for i in /proc/ /sys/ /dev/ /run/ /boot/; \
 do mount --bind $i /mnt/$i; done
chroot /mnt/
grub-mkconfig -o /boot/grub/grub.cfg
update-initramfs -u # повторяем теже действия и можем перезагружать
```
## 2. Выделить том под /var в зеркало

```
du -sh /var
12G     /var
```
 - добавил диски sdc,sdd по 14 гб(2 гб на /home)
```
pvcreate /dev/sdc /dev/sdd # создал PV
vgcreate vg_var /dev/sdc /dev/sdd  # создал VG
lvcreate -L 12G -m1 -n lv_var vg_var # # создал LV lv_var размером 12G, c одним зеркалом на дисках, добавленных в VG vg_var
```
 - Создаем на нем ФС и перемещаем туда /var:
```
mkfs.ext4 /dev/vg_var/lv_var
mount /dev/vg_var/lv_var /mnt
cp -aR /var/* /mnt/
```
- удаляем старый /var, примонтируем новый /var
```
umount /mnt
rm -rf /var
mkdir var
mount /dev/vg_var/lv_var /var
```
## 3. Выделить том под /home,работа с снапшотами:
```
root@vk:/# du -sh /home
1.2G    /home
```
 - создаем LV 2Гб, выполняем теже манипуляции что и с предыдущими папками:
```
lvcreate -n LogVol_Home -L 2G /dev/vg_var
mkfs.ext4 /dev/vg_var/LogVol_Home
mount /dev/vg_var/LogVol_Home /mnt/
cp -aR /home/* /mnt/
rm -rf /home/*
umount /mnt
mount /dev/vg_var/LogVol_Home /home/
```
 - создаём файлы в директории home для наглядности:
```
touch /home/file{1..20}
```
```
root@vk:/# ll /home
total 28
drwxr-xr-x  4 root root  4096 Mar 21 10:48 ./
drwxr-xr-x 23 root root  4096 Mar 20 13:31 ../
-rw-r--r--  1 root root     0 Mar 21 10:48 file1
-rw-r--r--  1 root root     0 Mar 21 10:48 file10
-rw-r--r--  1 root root     0 Mar 21 10:48 file11
-rw-r--r--  1 root root     0 Mar 21 10:48 file12
-rw-r--r--  1 root root     0 Mar 21 10:48 file13
-rw-r--r--  1 root root     0 Mar 21 10:48 file14
-rw-r--r--  1 root root     0 Mar 21 10:48 file15
-rw-r--r--  1 root root     0 Mar 21 10:48 file16
-rw-r--r--  1 root root     0 Mar 21 10:48 file17
-rw-r--r--  1 root root     0 Mar 21 10:48 file18
-rw-r--r--  1 root root     0 Mar 21 10:48 file19
-rw-r--r--  1 root root     0 Mar 21 10:48 file2
-rw-r--r--  1 root root     0 Mar 21 10:48 file20
-rw-r--r--  1 root root     0 Mar 21 10:48 file3
-rw-r--r--  1 root root     0 Mar 21 10:48 file4
-rw-r--r--  1 root root     0 Mar 21 10:48 file5
-rw-r--r--  1 root root     0 Mar 21 10:48 file6
-rw-r--r--  1 root root     0 Mar 21 10:48 file7
-rw-r--r--  1 root root     0 Mar 21 10:48 file8
-rw-r--r--  1 root root     0 Mar 21 10:48 file9
drwx------  2 root root 16384 Mar 20 13:43 lost+found/
drwxr-x--- 15 vk   vk    4096 Mar 20 13:17 vk/
```
 - Снять снапшот:
```
lvcreate -L 100MB -s -n home_snap /dev/vg_var/LogVol_Home # ключ -s указывает на создание LV типа snapshot
```
 - Удалить часть файлов:
```
rm -f /home/file{11..20}
root@vk:/# ll /home
total 28
drwxr-xr-x  4 root root  4096 Mar 21 12:57 ./
drwxr-xr-x 23 root root  4096 Mar 20 13:31 ../
-rw-r--r--  1 root root     0 Mar 21 10:48 file1
-rw-r--r--  1 root root     0 Mar 21 10:48 file10
-rw-r--r--  1 root root     0 Mar 21 10:48 file2
-rw-r--r--  1 root root     0 Mar 21 10:48 file3
-rw-r--r--  1 root root     0 Mar 21 10:48 file4
-rw-r--r--  1 root root     0 Mar 21 10:48 file5
-rw-r--r--  1 root root     0 Mar 21 10:48 file6
-rw-r--r--  1 root root     0 Mar 21 10:48 file7
-rw-r--r--  1 root root     0 Mar 21 10:48 file8
-rw-r--r--  1 root root     0 Mar 21 10:48 file9
drwx------  2 root root 16384 Mar 20 13:43 lost+found/
drwxr-x--- 15 vk   vk    4096 Mar 20 13:17 vk/
```
 - Процесс восстановления из снапшота:
```
umount /home
lvconvert --merge /dev/vg_var/home_snap
mount /dev/mapper/ubuntu--vg-LogVol_Home /home
ll /home
total 28
drwxr-xr-x  4 root root  4096 Mar 21 13:07 ./
drwxr-xr-x 23 root root  4096 Mar 21 13:17 ../
-rw-r--r--  1 root root     0 Mar 21 13:07 file1
-rw-r--r--  1 root root     0 Mar 21 13:07 file10
-rw-r--r--  1 root root     0 Mar 21 13:07 file11
-rw-r--r--  1 root root     0 Mar 21 13:07 file12
-rw-r--r--  1 root root     0 Mar 21 13:07 file13
-rw-r--r--  1 root root     0 Mar 21 13:07 file14
-rw-r--r--  1 root root     0 Mar 21 13:07 file15
-rw-r--r--  1 root root     0 Mar 21 13:07 file16
-rw-r--r--  1 root root     0 Mar 21 13:07 file17
-rw-r--r--  1 root root     0 Mar 21 13:07 file18
-rw-r--r--  1 root root     0 Mar 21 13:07 file19
-rw-r--r--  1 root root     0 Mar 21 13:07 file2
-rw-r--r--  1 root root     0 Mar 21 13:07 file20
-rw-r--r--  1 root root     0 Mar 21 13:07 file3
-rw-r--r--  1 root root     0 Mar 21 13:07 file4
-rw-r--r--  1 root root     0 Mar 21 13:07 file5
-rw-r--r--  1 root root     0 Mar 21 13:07 file6
-rw-r--r--  1 root root     0 Mar 21 13:07 file7
-rw-r--r--  1 root root     0 Mar 21 13:07 file8
-rw-r--r--  1 root root     0 Mar 21 13:07 file9
drwx------  2 root root 16384 Mar 20 13:43 lost+found/
drwxr-x--- 15 vk   vk    4096 Mar 20 13:17 vk/
```
## 5.Прописать монтирование в fstab.
для того что бы после перезагрузки информация о дисках,ФС сохранялась, добавляем записи в /etc/fstab:
```
root@vk:/# cat /etc/fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/ubuntu-vg/lv-0 during curtin installation
/dev/disk/by-id/dm-uuid-LVM-a0wGLBau0JhnJNzatIzgk87P8CicCb9r4oyytlTGAtXgcTgVzcNRWAR0WoNQcqcp / ext4 defaults 0 1
# /boot was on /dev/sda2 during curtin installation
/dev/disk/by-uuid/ad95884d-a1b9-4ef0-9aa6-3178b408f75c /boot ext4 defaults 0 1
/swap.img       none    swap    sw      0       0
/dev/disk/by-uuid/ab1f8ae4-3e7d-40e6-a241-48c3b33b17a8 /var ext4 defaults 0 0
/dev/disk/by-uuid/ef5e0b0c-ad09-4f1a-94e4-ec0ad390ff70 /home ext4 defaults 0 0
```
