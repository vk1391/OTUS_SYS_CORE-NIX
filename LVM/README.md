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
 - добавил диск sdb2 22G.
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
```
