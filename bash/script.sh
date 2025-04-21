#!/bin/bash
date
echo 'Список IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта'
awk '{print $1}' access.log | sort | uniq -c  | sort -n -r
echo 'Список запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта'
awk '{print $7, $11}' access.log | grep http | sort | uniq -c | sort -n -r
echo 'Ошибки веб-сервера/приложения c момента последнего запуска'
cat access.log | awk '{print $9}' |  grep -Eo [4-5][0-9][0-9] | sort | uniq | xargs -I ER grep -w ER access.log
echo 'Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта'
cat access.log | awk '{print $9}' | grep  [2-5][0-9][0-9] | sort | uniq -c | sort -n -r
echo 'Предотвращение одновременного запуска нескольких копий, до его завершения'
ps -ax | grep script | awk '{print $1}'
ps -ax | grep script | awk '{print $1}' | xargs -I PROC kill -9 PROC
