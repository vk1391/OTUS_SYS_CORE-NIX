# NFS
 - Основная часть: 
   - запустить 2 виртуальных машины (сервер NFS и клиента);
   - на сервере NFS должна быть подготовлена и экспортирована директория; 
   - в экспортированной директории должна быть поддиректория с именем upload с правами на запись в неё; 
   - экспортированная директория должна автоматически монтироваться на клиенте при старте виртуальной машины (systemd, autofs или fstab — любым способом);
   - монтирование и работа NFS на клиенте должна быть организована с использованием NFSv3.
## Сторона сервера
```
sudo apt install nfs-kernel-server nmap -y # устанавливаем nfs server и nmap для определения адреса клиента
export ipv4=`nmap --open  10.0.2.0/24 -oG - -p 111 | awk '{print $2}' | head -2 | tail +2` # создал переменную в которой записывается результат скрипта, сканирующий локальную сеть по порту 111.
sudo mkdir /share # создаем католог
sudo chown -R nobody:nogroup /share # указываем, что к данному катологу могут иметь доступ только легитимные клиенты nfs
sudo chmod 0777 #/share даем разрешение на чтение,запись,исполнение файлов в катологе
sudo echo '/share '$ipv4'/32(rw,sync,root_squash)'>> /etc/exports # этой строкой определяется католог,клиент и права доступа к нему
sudo exportfs -rs # проверяем и применяем файл конфигурации nfs
```
## Сторона клиента
```
sudo apt install nfs-common nmap -y # устанавливаем nfs server и nmap для определения адреса сервера
sudo export ipv4='nmap --open  10.0.2.0/24 -oG - -p 111 | awk '{print $2}' | head -2 | tail +2' # создал переменную в которой записывается результат скрипта, сканирующий локальную сеть по порту 111.
sudo echo "'$ipv4':/share/ /mnt nfs vers=3,noauto,x-systemd.automount 0 0" >> /etc/fstab # добавил в автозагрузку католог nfs, c доп.параметрами(использовать версию 3 nfs)
sudo systemctl daemon-reload # заставляем перечитать конфигурацию всех демонов OC
sudo systemctl restart remote-fs.target # перезагружаем nfs клиента
sudo systemctl enable remote-fs.target # добавляем в автозагрузку nfs клиент
```
 - проверяем какая версия nfs:
```
systemd-1 on /mnt type autofs (rw,relatime,fd=60,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=24631)
nsfs on /run/snapd/ns/lxd.mnt type nsfs (rw)
10.0.2.15:/share/ on /mnt type nfs (rw,relatime,vers=3,rsize=524288,wsize=524288,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.0.2.15,mountvers=3,mountport=39807,mountproto=udp,local_lock=none,addr=10.0.2.15)
```

