# ZFS
## 1. Введение
  ZFS(Zettabyte File System) — файловая система, созданная компанией Sun Microsystems в 2004-2005 годах для ОС Solaris. Эта файловая система поддерживает большие объёмы данных, объединяет в себе концепции файловой системы, RAID-массивов, менеджера логических дисков и 
принципы легковесных файловых систем. 
ZFS продолжает активно развиваться. К примеру проект FreeNAS использует возможности ZFS для реализации ОС для управления SAN/NAS хранилищ.


Из-за лицензионных ограничений, поддержка ZFS в GNU/Linux ограничена. По умолчанию ZFS отсутствует в ядре linux. 


Основное преимущество ZFS — это её полный контроль над физическими носителями, логическими томами и постоянное поддержание консистенции файловой системы. Оперируя на разных уровнях абстракции данных, ZFS способна обеспечить высокую скорость доступа к ним, контроль их целостности, а также минимизацию фрагментации данных. ZFS гибко настраивается, позволяет в процессе работы изменять объём дискового пространства и задавать разный размер блоков данных для разных применений, обеспечивает параллельность выполнения операций чтения-записи

![alt text](https://mega-obzor.ru/wp-content/uploads/2019/08/federated-ZFS-storage-1024x768.png)
## 2. Цели домашнего задания
Научится самостоятельно устанавливать ZFS, настраивать пулы, изучить основные возможности ZFS. 
## 3. Описание домашнего задания
 - Определить алгоритм с наилучшим сжатием:
 - Определить какие алгоритмы сжатия поддерживает zfs (gzip, zle, lzjb, lz4);
 - создать 4 файловых системы на каждой применить свой алгоритм сжатия;
 - для сжатия использовать либо текстовый файл, либо группу файлов.
 - Определить настройки пула.
 - С помощью команды zfs import собрать pool ZFS.
 - Командами zfs определить настройки:
    - размер хранилища;
    - тип pool;
    - значение recordsize;
    - какое сжатие используется;
    - какая контрольная сумма используется.
 - Работа со снапшотами:
   - скопировать файл из удаленной директории;
   - восстановить файл локально. zfs receive;
   - найти зашифрованное сообщение в файле secret_message.

## 4. Выполнение

### Определение алгоритма с наилучшим сжатием
 - Установим пакет утилит для ZFS:
   ```sudo apt install zfsutils-linux```
 - Создаём пул из двух дисков в режиме RAID 1:
   ```zpool create otus1 mirror /dev/sdb /dev/sdc```


 - Создадим ещё 3 пула: 
 ```
zpool create otus2 mirror /dev/sdd /dev/sde
zpool create otus3 mirror /dev/sdf /dev/sdg
zpool create otus4 mirror /dev/sdh /dev/sdi
 ```

 - Смотрим информацию о пулах:
```
zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
otus1   480M   116K   480M        -         -     0%     0%  1.00x    ONLINE  -
otus2   480M   116K   480M        -         -     0%     0%  1.00x    ONLINE  -
otus3   480M   146K   480M        -         -     0%     0%  1.00x    ONLINE  -
otus4   480M   166K   480M        -         -     0%     0%  1.00x    ONLINE  -
```
 - Команда zpool status показывает информацию о каждом диске, состоянии сканирования и об ошибках чтения, записи и совпадения хэш-сумм. Команда zpool list показывает информацию о размере пула, количеству занятого и свободного места, дедупликации и т.д. 
 - Добавим разные алгоритмы сжатия в каждую файловую систему:
   - Алгоритм lzjb: ```zfs set compression=lzjb otus1```
   - Алгоритм lz4:  ```zfs set compression=lz4 otus2```
   - Алгоритм gzip: ```zfs set compression=gzip-9 otus3```
   - Алгоритм zle:  ```zfs set compression=zle otus4```

 - Проверим, что все файловые системы имеют разные методы сжатия:
```
zfs get all | grep compression
otus1  compression           lzjb                   local
otus2  compression           lz4                    local
otus3  compression           gzip-9                 local
otus4  compression           zle                    local
```
 - Сжатие файлов будет работать только с файлами, которые были добавлены после включение настройки сжатия. 
 - Cкачаем один и тот же текстовый файл во все пулы:
```
for i in {1..4}; do wget -P /otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done
```
Проверим, сколько места в ФС занял файл:
```
root@vk:/home/vk# du /otus1
22097   /otus1
root@vk:/home/vk# du /otus2
18007   /otus2
root@vk:/home/vk# du /otus3
10966   /otus3
root@vk:/home/vk# du /otus4
40195   /otus4
```
 - Уже на этом этапе видно, что самый оптимальный метод сжатия у нас используется в пуле otus3.
 - Проверим, сколько места занимает один и тот же файл в разных пулах и проверим степень сжатия файлов:
```
root@vk:/home/vk# zfs list
NAME    USED  AVAIL  REFER  MOUNTPOINT
otus1  21.7M   330M  21.6M  /otus1
otus2  17.7M   334M  17.6M  /otus2
otus3  10.9M   341M  10.7M  /otus3
otus4  39.4M   313M  39.3M  /otus4
root@vk:/home/vk#  zfs get all | grep compressratio | grep -v ref
otus1  compressratio         1.81x                  -
otus2  compressratio         2.23x                  -
otus3  compressratio         3.65x                  -
otus4  compressratio         1.00x                  -
```
 - Таким образом, у нас получается, что алгоритм gzip-9 самый эффективный по сжатию
### Определение настроек пула
 - Скачиваем архив в домашний каталог: 
```wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download'``` 
 - Разархивируем его:
```
tar -xzvf archive.tar.gz
zpoolexport/
zpoolexport/filea
zpoolexport/fileb
```
 - Проверим, возможно ли импортировать данный каталог в пул:
```
zpool import -d zpoolexport/
   pool: otus
     id: 6554193320433390805
  state: ONLINE
status: Some supported features are not enabled on the pool.
	(Note that they may be intentionally disabled if the
	'compatibility' property is set.)
 action: The pool can be imported using its name or numeric identifier, though
	some features will not be available without an explicit 'zpool upgrade'.
 config:


	otus                         ONLINE
	  mirror-0                   ONLINE
	    /root/zpoolexport/filea  ONLINE
	    /root/zpoolexport/fileb  ONLINE
```
 - Данный вывод показывает нам имя пула, тип raid и его состав. 
 - Сделаем импорт данного пула к нам в ОС:
```
zpool import -d zpoolexport/ otus
zpool status
  pool: otus
 state: ONLINE
status: Some supported and requested features are not enabled on the pool.
	The pool can still be used, but some features are unavailable.
action: Enable all features using 'zpool upgrade'. Once this is done,
	the pool may no longer be accessible by software that does not support
	the features. See zpool-features(7) for details.
config:


	NAME                         STATE     READ WRITE CKSUM
	otus                         ONLINE       0     0     0
	  mirror-0                   ONLINE       0     0     0
	    /root/zpoolexport/filea  ONLINE       0     0     0
	    /root/zpoolexport/fileb  ONLINE       0     0     0

errors: No known data errors
```

 - Команда ```zpool status``` выдаст нам информацию о составе импортированного пула.
 - Если у Вас уже есть пул с именем otus, то можно поменять его имя во время импорта: ```zpool import -d zpoolexport/ otus newotus```
 - Далее нам нужно определить настройки: ```zpool get all otus```
 - Запрос сразу всех параметром файловой системы: ```zfs get all otus```
 - C помощью команды grep можно уточнить конкретный параметр, например:
   - Размер:
``` zfs get available otus
[root@zfs ~]# zfs get available otus
NAME  PROPERTY   VALUE  SOURCE
otus  available  350M   -
```
   - Тип:
```
zfs get readonly otus
NAME  PROPERTY  VALUE   SOURCE
otus  readonly  off     default
```
По типу FS мы можем понять, что позволяет выполнять чтение и запись
   - Значение recordsize:
```
zfs get recordsize otus
NAME  PROPERTY    VALUE    SOURCE
otus  recordsize  128K     local
```

   - Тип сжатия (или параметр отключения):
```
zfs get compression otus
NAME  PROPERTY     VALUE     SOURCE
otus  compression  zle       local
```

   - Тип контрольной суммы: 
```
zfs get checksum otus
NAME  PROPERTY  VALUE      SOURCE
otus  checksum  sha256     local
```
### Работа со снапшотом, поиск сообщения от преподавателя
 - Скачаем файл, указанный в задании:
```wget -O otus_task2.file --no-check-certificate https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI&export=download```
 - Восстановим файловую систему из снапшота:
```zfs receive otus/test@today < otus_task2.file```
 - Далее, ищем в каталоге /otus/test файл с именем “secret_message”:
```
find /otus/test -name "secret_message"
/otus/test/task1/file_mess/secret_message
```
 - Смотрим содержимое найденного файла:
```cat /otus/test/task1/file_mess/secret_message
https://otus.ru/lessons/linux-hl/
```
