#!/bin/bash
exec > output 2>&1
sudo ionice -c 3 time -f "Название:%C\nВремя выполнения:%e" nice sleep 10 &
sudo time -f "Название:%C\nВремя выполнения:%e" nice -n -11 sleep 11 &
sleep 1s && ps -axl | grep sleep &
sleep 2s && iotop -b -n 1 | grep sleep &
