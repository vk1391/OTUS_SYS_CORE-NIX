# Systemd — создание unit-файла
1. Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова (файл лога и ключевое слово должны задаваться в /etc/default).
2. Установить spawn-fcgi и создать unit-файл (spawn-fcgi.sevice) с помощью переделки init-скрипта (https://gist.github.com/cea2k/1318020).
3. Доработать unit-файл Nginx (nginx.service) для запуска нескольких инстансов сервера с разными конфигурационными файлами одновременно.

## 1. Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова
 - Создаем файл c переменными для нашего сервиса:
```
cat > /etc/default/watchlog
# Configuration file for my watchlog service
# Place it to /etc/default

# File and word in that file that we will be monit
WORD="error"
LOG=/var/log/*
```
 - создаем скрипт:
```
cat > /opt/watchlog.sh
#!/bin/bash

WORD=$1
LOG=$2
DATE=`date`

if grep -r $WORD $LOG &> /dev/null
then
logger "$DATE: I found word, MyLord!"
else
exit 0
fi
```
 - делаем скрипт исполняемым:
```
chmod +x /opt/watchlog.sh
```
- Создадим юнит для сервиса:
```
cat > /etc/systemd/system/watchlog.service
[Unit]
Description=My watchlog service

[Service]
Type=oneshot
EnvironmentFile=/etc/default/watchlog
ExecStart=/opt/watchlog.sh $WORD $LOG
```

 - Создадим юнит для таймера:
```
cat > /etc/systemd/system/watchlog.timer
[Unit]
Description=Run watchlog script every 30 second

[Timer]
# Run every 30 second
OnUnitActiveSec=30
Unit=watchlog.service

[Install]
WantedBy=multi-user.target
```
 - запускаем сервис и таймер:
```
systemctl start watchlog.timer && systemctl start watchlog.service
```
 - проверяем:
```
 grep -r MyLord /var/log/
grep: /var/log/journal/6073d0b6035d4fd2812dcdafd0b4e176/system.journal: binary file matches
/var/log/syslog:2025-04-17T12:08:02.375427+00:00 vk root: Thu Apr 17 12:08:02 PM UTC 2025: I found word, MyLord!
/var/log/syslog:2025-04-17T12:08:32.575574+00:00 vk root: Thu Apr 17 12:08:32 PM UTC 2025: I found word, MyLord!
/var/log/syslog:2025-04-17T12:09:13.507303+00:00 vk root: Thu Apr 17 12:09:13 PM UTC 2025: I found word, MyLord!
/var/log/syslog:2025-04-17T12:10:03.713157+00:00 vk root: Thu Apr 17 12:10:03 PM UTC 2025: I found word, MyLord!
/var/log/syslog:2025-04-17T12:10:42.563986+00:00 vk root: Thu Apr 17 12:10:42 PM UTC 2025: I found word, MyLord!
/var/log/syslog:2025-04-17T12:11:14.516832+00:00 vk root: Thu Apr 17 12:11:14 PM UTC 2025: I found word, MyLord!
/var/log/syslog:2025-04-17T12:11:52.570446+00:00 vk root: Thu Apr 17 12:11:52 PM UTC 2025: I found word, MyLord!
```
## 2. Установить spawn-fcgi и создать unit-файл (spawn-fcgi.sevice) с помощью переделки init-скрипта.
Выполнялось на ubuntu 24.04
 - обновляем базу пакетов:
```
apt update
```
 - устанавливаем необходимые пакеты:
```
apt install spawn-fcgi php php-cgi php-cli \
 apache2 libapache2-mod-fcgid -y
```
 - создадим диреекторию и файл с настройками для будущего сервиса в файле /etc/spawn-fcgi/fcgi.conf.
Он должен получится следующего вида
```
cat > /etc/spawn-fcgi/fcgi.conf
# You must set some working options before the "spawn-fcgi" service will work.
# If SOCKET points to a file, then this file is cleaned up by the init script.
#
# See spawn-fcgi(1) for all possible options.
#
# Example :
SOCKET=/var/run/php-fcgi.sock
OPTIONS="-u www-data -g www-data -s $SOCKET -S -M 0600 -C 32 -F 1 -- /usr/bin/php-cgi"
```

 - А сам юнит-файл будет примерно следующего вида:
```
cat > /etc/systemd/system/spawn-fcgi.service
[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target

[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/spawn-fcgi/fcgi.conf
ExecStart=/usr/bin/spawn-fcgi -n $OPTIONS
KillMode=process

[Install]
WantedBy=multi-user.target
```
 - Убеждаемся, что все успешно работает:

systemctl start spawn-fcgi
systemctl status spawn-fcgi
```
root@vk:/etc/nginx# systemctl status spawn-fcgi
● spawn-fcgi.service - Spawn-fcgi startup service by Otus
     Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; disabled; preset: enabled)
     Active: active (running) since Thu 2025-04-17 10:00:22 UTC; 2h 27min ago
   Main PID: 12352 (php-cgi)
      Tasks: 33 (limit: 4613)
     Memory: 14.6M (peak: 14.9M)
        CPU: 119ms
     CGroup: /system.slice/spawn-fcgi.service
```
## 3. Доработать unit-файл Nginx (nginx.service) для запуска нескольких инстансов сервера с разными конфигурационными файлами одновременно.
 - Установим Nginx из стандартного репозитория:
```
apt install nginx -y
```
 - Для запуска нескольких экземпляров сервиса модифицируем исходный service для использования различной конфигурации, а также PID-файлов. Для этого создадим новый Unit для работы с шаблонами (/etc/systemd/system/nginx@.service):
```
cat > /etc/systemd/system/nginx@.service

# Stop dance for nginx
# =======================
#
# ExecStop sends SIGSTOP (graceful stop) to the nginx process.
# If, after 5s (--retry QUIT/5) nginx is still running, systemd takes control
# and sends SIGTERM (fast shutdown) to the main process.
# After another 5s (TimeoutStopSec=5), and if nginx is alive, systemd sends
# SIGKILL to all the remaining processes in the process group (KillMode=mixed).
#
# nginx signals reference doc:
# http://nginx.org/en/docs/control.html
#
[Unit]
Description=A high performance web server and a reverse proxy server
Documentation=man:nginx(8)
After=network.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx-%I.pid
ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx-%I.conf -q -g 'daemon on; master_process on;'
ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx-%I.conf -g 'daemon on; master_process on;'
ExecReload=/usr/sbin/nginx -c /etc/nginx/nginx-%I.conf -g 'daemon on; master_process on;' -s reload
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx-%I.pid
TimeoutStopSec=5
KillMode=mixed

[Install]
WantedBy=multi-user.target
```
 - Далее необходимо создать два файла конфигурации (/etc/nginx/nginx-first.conf, /etc/nginx/nginx-second.conf). Их можно сформировать из стандартного конфига /etc/nginx/nginx.conf, с модификацией путей до PID-файлов и с сылками на разные конфигурации сервера(порт) :

pid /run/nginx-(first или second).pid;

http {
include /etc/nginx/sites-enabled/nginx-(first или second);
….
}
 - создадим два файла с шаблонами конфигурации в /etc/nginx/sites-available путем копирования default. в файлах меняем порт который будет слушать сервис:
```
server {
        listen 8080 default_server;
        listen [::]:8080 default_server;
```
```
server {
        listen 8080 default_server;
        listen [::]:8080 default_server;
```
 - создаем символическую ссылку на эти файлы с директории sites-enabled:
```
ln -s /etc/nginx/sites-available/nginx-first /etc/nginx/sites-enabled/nginx-first
ln -s /etc/nginx/sites-available/nginx-second /etc/nginx/sites-enabled/nginx-second
```

 - Проверим работу:
```
systemctl start nginx@first
systemctl start nginx@second
ss -ntlp
State   Recv-Q  Send-Q   Local Address:Port   Peer Address:Port Process
LISTEN  0       4096        127.0.0.54:53          0.0.0.0:*     users:(("systemd-resolve",pid=658,fd=17))
LISTEN  0       511            0.0.0.0:8080        0.0.0.0:*     users:(("nginx",pid=14178,fd=5),("nginx",pid=14177,fd=5),("nginx",pid=14176,fd=5),("nginx",pid=14175,fd=5),("nginx",pid=14174,fd=5))
LISTEN  0       511            0.0.0.0:8081        0.0.0.0:*     users:(("nginx",pid=14215,fd=5),("nginx",pid=14214,fd=5),("nginx",pid=14213,fd=5),("nginx",pid=14212,fd=5),("nginx",pid=14211,fd=5))
``
