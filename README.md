# OTUS_SYS_CORE-NIX
## Цель:
1. Запустить ВМ c Ubuntu.
2. Обновить ядро ОС на новейшую стабильную версию из mainline-репозитория.
3. Оформить отчет в README-файле в GitHub-репозитории.


 - Был установлен Ubuntu server 24.04.1:
```
uname -r
6.8.0-48-generic
```
 - Из  https://kernel.ubuntu.com/mainline/ было скачана и установлена актуальная версия ядра:
```
 wget https://kernel.ubuntu.com/mainline/v6.13.5/amd64/linux-headers-6.13.5-061305-generic_6.13.5-061305.202502271338_amd64.deb
 wget https://kernel.ubuntu.com/mainline/v6.13.5/amd64/linux-headers-6.13.5-061305_6.13.5-061305.202502271338_all.deb
 wget https://kernel.ubuntu.com/mainline/v6.13.5/amd64/linux-image-unsigned-6.13.5-061305-generic_6.13.5-061305.202502271338_amd64.deb
 wget  https://kernel.ubuntu.com/mainline/v6.13.5/amd64/linux-modules-6.13.5-061305-generic_6.13.5-061305.202502271338_amd64.deb
 sudo dpkg -i *.deb
 ```
 - Обновляем конфигурацию загрузчика,выставляем высший преоритет новому ядру при загрузке:
```
sudo update-grub
sudo grub-set-default 0
```
 - Перезагружаем ОС, проверяем:
```
uname -r
6.13.5-061305-generic
```
