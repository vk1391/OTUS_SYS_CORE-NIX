# RPM
1. Создать свой RPM пакет из nginx.
2. Создать свой репозиторий и разместить там ранее собранный RPM.
В качестве OC используется ALma Linux 9.5
- Для данного задания нам понадобятся следующие установленные пакеты:
  ```
  yum install -y wget rpmdevtools rpm-build createrepo yum-utils cmake gcc git nano
  ```
- Для примера возьмем пакет Nginx и соберем его.
- Загрузим SRPM пакет Nginx для дальнейшей работы над ним:
   ```
   mkdir rpm && cd rpm
   yumdownloader --source nginx # инструмент для загрузки RPM-пакетов из репозиториев Yum
  ```
 - При установке такого пакета в домашней директории создается дерево каталогов для сборки, далее поставим все зависимости для сборки пакета Nginx:
  ```
rpm -Uvh nginx*.src.rpm # Если необходимо обновить некий пакет rpm_some_package, но без всяких изменений в конфигурационных файлов ( если отсутствует пакет, то  он будет установлен)
yum-builddep nginx # программа для установки необходимых зависимостей для сборки RPM-пакета 
  ```
 - Теперь можно приступить к сборке RPM пакета:
```
cd ~/rpmbuild/SPECS/
rpmbuild -ba nginx.spec -D 'debug_package %{nil}' # -ba — собрать бинарный пакет и пакет с исходным кодом,-D 'debug_package %{nil}' - При значении %{nil} сборка проходит без создания debuginfo.
```
 - Копируем пакеты в общий каталог:
```
cp ~/rpmbuild/RPMS/noarch/* ~/rpmbuild/RPMS/x86_64/
cd ~/rpmbuild/RPMS/x86_64
```
 - Теперь можно установить наш пакет и убедиться, что nginx работает:
```
yum localinstall *.rpm
systemctl start nginx
systemctl status nginx
```
 - Далее мы будем использовать его для доступа к своему репозиторию.
## Создать свой репозиторий и разместить там ранее собранный RPM

 - Теперь приступим к созданию своего репозитория. Директория для статики у Nginx по умолчанию /usr/share/nginx/html. Создадим там каталог repo:

```
mkdir /usr/share/nginx/html/repo
```
 - Копируем туда наши собранные RPM-пакеты:
```
cp ~/rpmbuild/RPMS/x86_64/*.rpm /usr/share/nginx/html/repo/
```
 - Инициализируем репозиторий командой:
```
createrepo /usr/share/nginx/html/repo/
```

 - Для прозрачности настроим в NGINX доступ к листингу каталога. В файле /etc/nginx/nginx.conf в блоке server добавим следующие директивы:
```
	index index.html index.html;
	autoindex on;
```
 - Проверяем синтаксис и перезапускаем NGINX:
```
nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
nginx -s reload
```
 - Теперь ради интереса можно посмотреть в браузере или с помощью curl:
```
curl -a http://localhost/repo/
```

 - Все готово для того, чтобы протестировать репозиторий.
 - Добавим его в /etc/yum.repos.d:
```
cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF
```
 - Убедимся, что репозиторий подключился и посмотрим, что в нем есть:
```
yum repolist enabled | grep otus
otus otus-linux 2
```
 - Добавим пакет в наш репозиторий:
```
cd /usr/share/nginx/html/repo/
wget https://repo.percona.com/yum/percona-release-latest.noarch.rpm
```
 - Обновим список пакетов в репозитории:
```
createrepo /usr/share/nginx/html/repo/
yum makecache
yum list | grep otus
percona-release.noarch 	1.0-27 		otus
```
 - Все прошло успешно. В случае, если вам потребуется обновить репозиторий (а это
делается при каждом добавлении файлов) снова, то выполните команду
```
createrepo /usr/share/nginx/html/repo/.
```

