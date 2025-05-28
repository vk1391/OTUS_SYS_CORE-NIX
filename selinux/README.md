# Практика c SELinux
## 1. Запустить Nginx на нестандартном порту 3-мя разными способами:
    - переключатели setsebool;
    - добавление нестандартного порта в имеющийся тип;
    - формирование и установка модуля SELinux.
## 2. Обеспечить работоспособность приложения при включенном selinux.
    - развернуть приложенный стенд https://github.com/Nickmob/vagrant_selinux_dns_problems; 
    - выяснить причину неработоспособности механизма обновления зоны (см. README);
    - предложить решение (или решения) для данной проблемы;
    - выбрать одно из решений для реализации, предварительно обосновав выбор;
    - реализовать выбранное решение и продемонстрировать его работоспособность.

# Запустить Nginx на нестандартном порту 3-мя разными способами:
1. Создаём виртуальную машину
  Код стенда можно получить из репозитория: https://github.com/Nickmob/vagrant_selinux 
  Результатом выполнения команды vagrant up станет созданная виртуальная машина с установленным nginx, который работает на порту TCP 4881. Порт TCP 4881 уже проброшен до хоста. SELinux включен.
  Во время развёртывания стенда попытка запустить nginx завершится с ошибкой.
Для начала проверим, что в ОС отключен файервол: systemctl status firewalld

```
[root@selinux ~]# systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:firewalld(1)
```
Также можно проверить, что конфигурация nginx настроена без ошибок: nginx -t
```
[root@selinux ~]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

Далее проверим режим работы SELinux: getenforce 
```
[root@selinux ~]# getenforce
 Enforcing
```
Должен отображаться режим Enforcing. Данный режим означает, что SELinux будет блокировать запрещенную активность.
2. Переключатели setsebool;
Разрешим в SELinux работу nginx на порту TCP 4881 c помощью переключателей setsebool
Находим в логах (/var/log/audit/audit.log) информацию о блокировании порта
Копируем время, в которое был записан этот лог, и, с помощью утилиты audit2why смотрим 
```
cat /var/log/audit/audit.log | grep denied	 
type=AVC msg=audit(1748350420.945:718): avc:  denied  { name_bind } for  pid=6621 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0
[root@selinux ~]# grep 1748350420.945:718 /var/log/audit/audit.log | audit2why
type=AVC msg=audit(1748350420.945:718): avc:  denied  { name_bind } for  pid=6621 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0

        Was caused by:
        The boolean nis_enabled was set incorrectly.
        Description:
        Allow nis to enabled

        Allow access by executing:
        # setsebool -P nis_enabled 1
```
Утилита audit2why покажет почему трафик блокируется. Исходя из вывода утилиты, мы видим, что нам нужно поменять параметр nis_enabled. 
Включим параметр nis_enabled и перезапустим nginx: setsebool -P nis_enabled on
```

[root@selinux ~]# setsebool -P nis_enabled 1
[root@selinux ~]# systemctl restart nginx
 ```
Проверить статус параметра можно с помощью команды: getsebool -a | grep nis_enabled
```
[root@selinux ~]# getsebool -a | grep nis_enabled
nis_enabled --> on
```
Вернём запрет работы nginx на порту 4881 обратно. Для этого отключим nis_enabled: setsebool -P nis_enabled off
После отключения nis_enabled служба nginx снова не запустится.
3. добавление нестандартного порта в имеющийся тип
Теперь разрешим в SELinux работу nginx на порту TCP 4881 c помощью добавления нестандартного порта в имеющийся тип:
Поиск имеющегося типа, для http трафика: semanage port -l | grep http
```
[root@selinux ~]# semanage port -l | grep http
http_cache_port_t              tcp      8080, 8118, 8123, 10001-10010
http_cache_port_t              udp      3130
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
pegasus_https_port_t           tcp      5989
```
Добавим порт в тип http_port_t: semanage port -a -t http_port_t -p tcp 4881
```
[root@selinux ~]# semanage port -a -t http_port_t -p tcp 4881
[root@selinux ~]# semanage port -l | grep  http_port_t
http_port_t                    tcp      4881, 80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
```
Теперь перезапускаем службу nginx и проверим её работу: systemctl restart nginx
[root@selinux ~]# systemctl restart nginx
Удалить нестандартный порт из имеющегося типа можно с помощью команды: semanage port -d -t http_port_t -p tcp 4881
```
[root@selinux ~]# semanage port -d -t http_port_t -p tcp 4881
[root@selinux ~]# semanage port -l | grep  http_port_t
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
```
4 формирование и установка модуля SELinux
Разрешим в SELinux работу nginx на порту TCP 4881 c помощью формирования и установки модуля SELinux:
Попробуем снова запустить Nginx: systemctl start nginx
```
[root@selinux ~]# systemctl start nginx
Job for nginx.service failed because the control process exited with error code. See "systemctl status nginx.service" and "journalctl -xe" for details.
```
Nginx не запустится, так как SELinux продолжает его блокировать. Посмотрим логи SELinux, которые относятся к Nginx: 
```
[root@selinux ~]# grep nginx /var/log/audit/audit.log
...
type=SYSCALL msg=audit(1637045467.417:510): arch=c000003e syscall=49 success=no exit=-13 a0=6 a1=558922a5a7b8 a2=10 a3=7ffe62da3900 items=0 ppid=1 pid=2133 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="nginx" exe="/usr/sbin/nginx" subj=system_u:system_r:httpd_t:s0 key=(null)
type=SERVICE_START msg=audit(1637045467.419:511): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nginx comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=failed'
```
Воспользуемся утилитой audit2allow для того, чтобы на основе логов SELinux сделать модуль, разрешающий работу nginx на нестандартном порту: 
```
grep nginx /var/log/audit/audit.log | audit2allow -M nginx
[root@selinux ~]# grep nginx /var/log/audit/audit.log | audit2allow -M nginx
******************** IMPORTANT ***********************
To make this policy package active, execute:


semodule -i nginx.pp


```

Audit2allow сформировал модуль, и сообщил нам команду, с помощью которой можно применить данный модуль: semodule -i nginx.pp
```
[root@selinux ~]# semodule -i nginx.pp
```
Попробуем снова запустить nginx: systemctl start nginx
```
[root@selinux ~]# systemctl start nginx
```
После добавления модуля nginx запустился без ошибок. При использовании модуля изменения сохранятся после перезагрузки. 
Просмотр всех установленных модулей: semodule -l
Для удаления модуля воспользуемся командой: semodule -r nginx
```
[root@selinux ~]# semodule -r nginx
libsemanage.semanage_direct_remove_key: Removing last nginx module (no other nginx module exists at another priority).
```
# Обеспечить работоспособность приложения при включенном selinux




