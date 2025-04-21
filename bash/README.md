# BASH
 - Список IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
   ```
   awk '{print $1}' access.log | sort | uniq -c  | sort -n -r
   ```
 - Список запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
   ```
   awk '{print $7, $11}' access.log | grep http | sort | uniq -c | sort -n -r
   ```
 - Ошибки веб-сервера/приложения c момента последнего запуска
   ```
   cat access.log | awk '{print $9}' |  grep -Eo [4-5][0-9][0-9] | sort | uniq | xargs -I ER grep -w ER access.log
   ```
 - Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта
   ```
   cat access.log | awk '{print $9}' | grep  [2-5][0-9][0-9] | sort | uniq -c | sort -n -r
   ```
 - Предотвращение одновременного запуска нескольких копий, до его завершения
  ```
  ps -ax | grep script | awk '{print $1}'
  ps -ax | grep script | awk '{print $1}' | xargs -I PROC kill -9 PROC
  ```
 - Результат:
  ```
root@vk:/home/vk# bash script.sh
Mon Apr 21 01:08:50 PM UTC 2025
Список IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
     45 93.158.167.130
     39 109.236.252.130
     37 212.57.117.19
     33 188.43.241.106
     31 87.250.233.68
     24 62.75.198.172
     22 148.251.223.21
     20 185.6.8.9
     17 217.118.66.161
     16 95.165.18.146
     12 95.108.181.93
     12 62.210.252.196
     12 185.142.236.35
     12 162.243.13.195
      8 163.179.32.118
      7 87.250.233.75
      6 167.99.14.153
      6 165.22.19.102
      5 71.6.199.23
      5 5.45.203.12
      4 87.250.233.120
      4 141.8.141.136
      4 107.179.102.58
      3 89.32.248.234
      3 87.250.233.76
      3 86.109.170.96
      3 67.205.140.232
      3 66.249.64.204
      3 66.249.64.202
      3 64.20.39.18
      3 60.208.103.154
      3 54.39.196.33
      3 54.208.102.37
      3 5.255.251.4
      3 52.204.135.251
      3 51.158.182.48
      3 45.32.61.237
      3 45.119.80.34
      3 41.226.27.17
      3 37.97.241.247
      3 35.240.189.61
      3 35.220.141.147
      3 35.197.133.238
      3 221.132.27.142
      3 216.10.242.46
      3 213.32.18.50
      3 213.202.100.91
      3 210.14.72.78
      3 209.124.74.244
      3 207.46.13.153
      3 195.161.115.183
      3 192.169.232.246
      3 188.166.2.191
      3 185.37.228.115
      3 185.2.5.13
      3 178.128.60.114
      3 178.128.121.8
      3 174.142.104.196
      3 173.212.196.211
      3 167.86.96.137
      3 167.71.136.40
      3 165.227.60.134
      3 165.22.42.101
      3 164.132.96.137
      3 159.65.126.173
      3 158.69.224.11
      3 149.28.24.41
      3 149.202.81.101
      3 140.143.135.247
      3 139.180.174.55
      3 137.74.1.112
      3 134.209.8.115
      3 13.234.166.154
      3 123.31.31.12
      3 115.146.121.237
      3 111.90.159.43
      3 104.248.10.36
      3 104.243.26.147
      3 104.238.94.107
      3 104.216.14.166
      3 103.111.52.54
      2 91.121.79.16
      2 8.29.198.27
      2 78.39.67.210
      2 77.247.110.165
      2 61.219.11.153
      2 5.45.74.36
      2 5.45.203.15
      2 46.229.168.145
      2 46.229.168.144
      2 46.229.168.142
      2 46.229.168.138
      2 37.9.113.173
      2 23.228.90.99
      2 194.58.113.224
      2 193.106.30.99
      2 185.12.124.78
      2 182.254.243.249
      2 176.9.56.104
      2 165.227.50.203
      2 164.132.119.83
      2 141.8.189.176
      2 110.249.212.46
      1 93.120.131.74
      1 92.55.222.11
      1 88.229.210.251
      1 87.250.244.2
      1 87.10.76.101
      1 85.108.65.190
      1 78.85.128.175
      1 78.142.211.173
      1 77.247.110.69
      1 77.247.110.201
      1 71.6.232.7
      1 71.6.232.4
      1 70.40.109.121
      1 66.249.64.203
      1 66.249.64.200
      1 66.249.64.199
      1 5.44.173.80
      1 54.36.150.4
      1 54.36.150.0
      1 54.36.149.102
      1 54.198.159.218
      1 5.255.251.125
      1 5.226.52.170
      1 5.160.111.41
      1 51.254.59.114
      1 46.72.156.204
      1 46.229.168.161
      1 46.229.168.153
      1 46.229.168.152
      1 46.229.168.151
      1 46.229.168.149
      1 46.229.168.146
      1 46.229.168.143
      1 46.229.168.141
      1 46.229.168.140
      1 46.229.168.137
      1 46.229.168.133
      1 46.229.168.132
      1 46.229.168.130
      1 40.77.167.165
      1 217.196.115.205
      1 209.17.96.74
      1 209.17.96.226
      1 207.46.13.94
      1 207.46.13.113
      1 201.13.204.106
      1 200.33.155.30
      1 198.108.66.176
      1 191.96.41.52
      1 191.115.71.210
      1 190.28.94.157
      1 189.8.68.41
      1 189.172.143.220
      1 188.40.80.134
      1 184.105.247.196
      1 181.214.191.196
      1 172.104.242.173
      1 162.213.37.124
      1 162.213.36.225
      1 157.55.39.97
      1 157.55.39.76
      1 157.55.39.73
      1 157.55.39.179
      1 157.55.39.178
      1 141.8.141.135
      1 128.14.136.18
      1 123.136.117.238
      1 122.228.19.80
      1 118.139.177.119
      1 104.152.52.35
      1 103.240.249.197
Список запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
      4 /wp-content/themes/llorix-one-lite/fonts/fontawesome-webfont.woff2?v=4.6.3 "https://dbadmins.ru/wp-content/themes/llorix-one-lite/css/font-awesome.min.css?ver=4.4.0"
      4 / "http://dbadmins.ru/"
      3 /wp-includes/js/wp-emoji-release.min.js?ver=5.0.4 "https://dbadmins.ru/"
      3 /wp-includes/js/wp-embed.min.js?ver=5.0.4 "https://dbadmins.ru/"
      3 /wp-includes/css/dist/block-library/style.min.css?ver=5.0.4 "https://dbadmins.ru/"
      3 /wp-content/uploads/2016/10/WebHostingSolution.jpg "https://dbadmins.ru/"
      3 /wp-content/themes/llorix-one-lite/style.css?ver=1.0.0 "https://dbadmins.ru/"
      3 /wp-content/themes/llorix-one-lite/js/vendor/bootstrap.min.js?ver=3.3.7 "https://dbadmins.ru/"
      3 /wp-content/themes/llorix-one-lite/js/skip-link-focus-fix.js?ver=1.0.0 "https://dbadmins.ru/"
      3 /wp-content/themes/llorix-one-lite/js/custom.home.js?ver=1.0.0 "https://dbadmins.ru/"
      3 /wp-content/themes/llorix-one-lite/js/custom.all.js?ver=2.0.2 "https://dbadmins.ru/"
      3 /wp-content/themes/llorix-one-lite/images/no-thumbnail-latest-news.jpg "https://dbadmins.ru/"
      3 /wp-content/themes/llorix-one-lite/images/loader-red.gif "https://dbadmins.ru/wp-content/themes/llorix-one-lite/style.css?ver=1.0.0"
      3 /wp-content/themes/llorix-one-lite/css/font-awesome.min.css?ver=4.4.0 "https://dbadmins.ru/"
      3 /wp-content/themes/llorix-one-lite/css/bootstrap.min.css?ver=3.3.1 "https://dbadmins.ru/"
      3 /wp-content/plugins/pc-google-analytics/assets/js/frontend.min.js?ver=1.0.0 "https://dbadmins.ru/"
      3 /wp-content/plugins/pc-google-analytics/assets/css/frontend.css?ver=1.0.0 "https://dbadmins.ru/"
      3 /wp-content/plugins/llorix-one-companion//css/style.css?ver=5.0.4 "https://dbadmins.ru/"
      2 /wp-content/plugins/uploadify/readme.txt "http://dbadmins.ru/wp-content/plugins/uploadify/readme.txt"
      2 /wp-content/plugins/uploadify/includes/check.php "http://dbadmins.ru/wp-content/plugins/uploadify/includes/check.php"
      2 /wp-admin/admin-post.php?page=301bulkoptions "http://dbadmins.ru/wp-admin/admin-post.php?page=301bulkoptions"
      2 /wp-admin/admin-ajax.php?page=301bulkoptions "http://dbadmins.ru/wp-admin/admin-ajax.php?page=301bulkoptions"
      2 / "https://dbadmins.ru/"
      2 / "http://dbadmins.ru"
      2 /favicon.ico "https://dbadmins.ru/"
      2 /%D0%A3%D0%B4%D0%B0%D0%BB%D0%B5%D0%BD%D0%BD%D0%BE%D0%B5-%D0%B0%D0%B4%D0%BC%D0%B8%D0%BD%D0%B8%D1%81%D1%82%D1%80%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-%D0%A1%D0%A3%D0%91%D0%94-oracle/ "https://dbadmins.ru/"
      2 /category/%d0%97%d0%b0%d0%bf%d0%b8%d1%81%d0%ba%d0%b8-%d0%b0%d0%b4%d0%bc%d0%b8%d0%bd%d0%b0/ "https://dbadmins.ru/"
      2 /1 "http://dbadmins.ru/1"
      1 /wp-includes/js/wp-emoji-release.min.js?ver=5.0.4 "https://dbadmins.ru/2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/"
      1 /wp-includes/js/wp-emoji-release.min.js?ver=5.0.4 "https://dbadmins.ru/2016/10/17/%D0%9F%D1%80%D0%BE%D0%B4%D0%BE%D0%BB%D0%B6%D0%B0%D0%B5%D0%BC-%D1%8D%D0%BA%D1%81%D0%BF%D0%B5%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-%D1%81-lacp/"
      1 /wp-includes/js/wp-embed.min.js?ver=5.0.4 "https://dbadmins.ru/tag/transparent-tablespaces/"
      1 /wp-includes/js/wp-embed.min.js?ver=5.0.4 "https://dbadmins.ru/tag/overcommit_ratio/"
      1 /wp-includes/js/wp-embed.min.js?ver=5.0.4 "https://dbadmins.ru/2017/09/28/"
      1 /wp-includes/js/wp-embed.min.js?ver=5.0.4 "https://dbadmins.ru/2016/12/14/virtualenv-%D0%B4%D0%BB%D1%8F-%D0%BF%D0%BB%D0%B0%D0%B3%D0%B8%D0%BD%D0%BE%D0%B2-python-scrappy-%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82-%D0%BD%D0%B0-debian-jessie/"
      1 /wp-includes/js/wp-embed.min.js?ver=5.0.4 "https://dbadmins.ru/2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/"
      1 /wp-includes/js/wp-embed.min.js?ver=5.0.4 "https://dbadmins.ru/2016/10/17/%D0%9F%D1%80%D0%BE%D0%B4%D0%BE%D0%BB%D0%B6%D0%B0%D0%B5%D0%BC-%D1%8D%D0%BA%D1%81%D0%BF%D0%B5%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-%D1%81-lacp/"
      1 /wp-includes/js/comment-reply.min.js?ver=5.0.4 "https://dbadmins.ru/2017/05/19/%d0%be%d0%b1%d0%bd%d0%b0%d1%80%d1%83%d0%b6%d0%b5%d0%bd%d0%b8%d0%b5-%d0%bd%d0%be%d0%b2%d1%8b%d1%85-scsi-%d1%83%d1%81%d1%82%d1%80%d0%be%d0%b9%d1%81%d1%82%d0%b2-%d1%80%d0%b0%d1%81%d1%88%d0%b8%d1%80/"
      1 /wp-includes/js/comment-reply.min.js?ver=5.0.4 "https://dbadmins.ru/2016/12/14/virtualenv-%D0%B4%D0%BB%D1%8F-%D0%BF%D0%BB%D0%B0%D0%B3%D0%B8%D0%BD%D0%BE%D0%B2-python-scrappy-%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82-%D0%BD%D0%B0-debian-jessie/"
      1 /wp-includes/js/comment-reply.min.js?ver=5.0.4 "https://dbadmins.ru/2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/"
      1 /wp-includes/js/comment-reply.min.js?ver=5.0.4 "https://dbadmins.ru/2016/10/17/%D0%9F%D1%80%D0%BE%D0%B4%D0%BE%D0%BB%D0%B6%D0%B0%D0%B5%D0%BC-%D1%8D%D0%BA%D1%81%D0%BF%D0%B5%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-%D1%81-lacp/"
      1 /wp-includes/css/dist/block-library/style.min.css?ver=5.0.4 "https://dbadmins.ru/2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/"
      1 /wp-includes/css/dist/block-library/style.min.css?ver=5.0.4 "https://dbadmins.ru/2016/10/17/%D0%9F%D1%80%D0%BE%D0%B4%D0%BE%D0%BB%D0%B6%D0%B0%D0%B5%D0%BC-%D1%8D%D0%BA%D1%81%D0%BF%D0%B5%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-%D1%81-lacp/"
      1 /wp-cron.php?doing_wp_cron=1565816515.1302280426025390625000 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565816515.1302280426025390625000"
      1 /wp-cron.php?doing_wp_cron=1565813746.0306749343872070312500 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565813746.0306749343872070312500"
      1 /wp-cron.php?doing_wp_cron=1565809064.3519101142883300781250 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565809064.3519101142883300781250"
      1 /wp-cron.php?doing_wp_cron=1565805548.2867050170898437500000 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565805548.2867050170898437500000"
      1 /wp-cron.php?doing_wp_cron=1565804989.2034769058227539062500 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565804989.2034769058227539062500"
      1 /wp-cron.php?doing_wp_cron=1565803543.6812090873718261718750 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565803543.6812090873718261718750"
      1 /wp-cron.php?doing_wp_cron=1565801969.5889279842376708984375 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565801969.5889279842376708984375"
      1 /wp-cron.php?doing_wp_cron=1565799677.3172910213470458984375 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565799677.3172910213470458984375"
      1 /wp-cron.php?doing_wp_cron=1565795656.8273639678955078125000 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565795656.8273639678955078125000"
      1 /wp-cron.php?doing_wp_cron=1565794821.8002350330352783203125 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565794821.8002350330352783203125"
      1 /wp-cron.php?doing_wp_cron=1565792067.0530738830566406250000 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565792067.0530738830566406250000"
      1 /wp-cron.php?doing_wp_cron=1565787459.9350829124450683593750 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565787459.9350829124450683593750"
      1 /wp-cron.php?doing_wp_cron=1565784086.7978200912475585937500 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565784086.7978200912475585937500"
      1 /wp-cron.php?doing_wp_cron=1565780249.6808691024780273437500 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565780249.6808691024780273437500"
      1 /wp-cron.php?doing_wp_cron=1565776688.9177799224853515625000 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565776688.9177799224853515625000"
      1 /wp-cron.php?doing_wp_cron=1565773050.3219890594482421875000 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565773050.3219890594482421875000"
      1 /wp-cron.php?doing_wp_cron=1565769624.2795310020446777343750 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565769624.2795310020446777343750"
      1 /wp-cron.php?doing_wp_cron=1565767056.5768508911132812500000 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565767056.5768508911132812500000"
      1 /wp-cron.php?doing_wp_cron=1565762786.4766530990600585937500 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565762786.4766530990600585937500"
      1 /wp-cron.php?doing_wp_cron=1565760219.4257180690765380859375 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565760219.4257180690765380859375"
      1 /wp-cron.php?doing_wp_cron=1565758629.1767649650573730468750 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565758629.1767649650573730468750"
      1 /wp-cron.php?doing_wp_cron=1565755676.3754100799560546875000 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565755676.3754100799560546875000"
      1 /wp-cron.php?doing_wp_cron=1565751459.7073841094970703125000 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565751459.7073841094970703125000"
      1 /wp-cron.php?doing_wp_cron=1565748350.8502669334411621093750 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565748350.8502669334411621093750"
      1 /wp-content/themes/llorix-one-lite/style.css?ver=1.0.0 "https://dbadmins.ru/2017/05/19/%D1%81%D0%BC%D0%B5%D0%BD%D0%B0-%D0%BF%D0%B0%D1%80%D0%BE%D0%BB%D1%8F-%D1%83-asmsnmp/"
      1 /wp-content/themes/llorix-one-lite/style.css?ver=1.0.0 "https://dbadmins.ru/2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/"
      1 /wp-content/themes/llorix-one-lite/style.css?ver=1.0.0 "https://dbadmins.ru/2016/10/17/%D0%9F%D1%80%D0%BE%D0%B4%D0%BE%D0%BB%D0%B6%D0%B0%D0%B5%D0%BC-%D1%8D%D0%BA%D1%81%D0%BF%D0%B5%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-%D1%81-lacp/"
      1 /wp-content/themes/llorix-one-lite/js/vendor/bootstrap.min.js?ver=3.3.7 "https://dbadmins.ru/2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/"
      1 /wp-content/themes/llorix-one-lite/js/vendor/bootstrap.min.js?ver=3.3.7 "https://dbadmins.ru/2016/10/17/%D0%9F%D1%80%D0%BE%D0%B4%D0%BE%D0%BB%D0%B6%D0%B0%D0%B5%D0%BC-%D1%8D%D0%BA%D1%81%D0%BF%D0%B5%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-%D1%81-lacp/"
      1 /wp-content/themes/llorix-one-lite/js/skip-link-focus-fix.js?ver=1.0.0 "https://dbadmins.ru/2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/"
      1 /wp-content/themes/llorix-one-lite/js/skip-link-focus-fix.js?ver=1.0.0 "https://dbadmins.ru/2016/10/17/%D0%9F%D1%80%D0%BE%D0%B4%D0%BE%D0%BB%D0%B6%D0%B0%D0%B5%D0%BC-%D1%8D%D0%BA%D1%81%D0%BF%D0%B5%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-%D1%81-lacp/"
      1 /wp-content/themes/llorix-one-lite/js/custom.all.js?ver=2.0.2 "https://dbadmins.ru/2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/"
      1 /wp-content/themes/llorix-one-lite/js/custom.all.js?ver=2.0.2 "https://dbadmins.ru/2016/10/17/%D0%9F%D1%80%D0%BE%D0%B4%D0%BE%D0%BB%D0%B6%D0%B0%D0%B5%D0%BC-%D1%8D%D0%BA%D1%81%D0%BF%D0%B5%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-%D1%81-lacp/"
      1 /wp-content/themes/llorix-one-lite/fonts/fontawesome-webfont.woff?v=4.6.3 "https://dbadmins.ru/2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/"
      1 /wp-content/themes/llorix-one-lite/fonts/fontawesome-webfont.eot? "https://dbadmins.ru/2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/"
      1 /wp-content/themes/llorix-one-lite/css/font-awesome.min.css?ver=4.4.0 "https://dbadmins.ru/2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/"
      1 /wp-content/themes/llorix-one-lite/css/font-awesome.min.css?ver=4.4.0 "https://dbadmins.ru/2016/10/17/%D0%9F%D1%80%D0%BE%D0%B4%D0%BE%D0%BB%D0%B6%D0%B0%D0%B5%D0%BC-%D1%8D%D0%BA%D1%81%D0%BF%D0%B5%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-%D1%81-lacp/"
      1 /wp-content/themes/llorix-one-lite/css/bootstrap.min.css?ver=3.3.1 "https://dbadmins.ru/2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/"
      1 /wp-content/themes/llorix-one-lite/css/bootstrap.min.css?ver=3.3.1 "https://dbadmins.ru/2016/10/17/%D0%9F%D1%80%D0%BE%D0%B4%D0%BE%D0%BB%D0%B6%D0%B0%D0%B5%D0%BC-%D1%8D%D0%BA%D1%81%D0%BF%D0%B5%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-%D1%81-lacp/"
      1 /wp-content/plugins/pc-google-analytics/assets/js/frontend.min.js?ver=1.0.0 "https://dbadmins.ru/2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/"
      1 /wp-content/plugins/pc-google-analytics/assets/js/frontend.min.js?ver=1.0.0 "https://dbadmins.ru/2016/10/17/%D0%9F%D1%80%D0%BE%D0%B4%D0%BE%D0%BB%D0%B6%D0%B0%D0%B5%D0%BC-%D1%8D%D0%BA%D1%81%D0%BF%D0%B5%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-%D1%81-lacp/"
      1 /wp-content/plugins/pc-google-analytics/assets/css/frontend.css?ver=1.0.0 "https://dbadmins.ru/2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/"
      1 /wp-content/plugins/pc-google-analytics/assets/css/frontend.css?ver=1.0.0 "https://dbadmins.ru/2016/10/17/%D0%9F%D1%80%D0%BE%D0%B4%D0%BE%D0%BB%D0%B6%D0%B0%D0%B5%D0%BC-%D1%8D%D0%BA%D1%81%D0%BF%D0%B5%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-%D1%81-lacp/"
      1 /wp-content/plugins/llorix-one-companion//css/style.css?ver=5.0.4 "https://dbadmins.ru/2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/"
      1 /wp-content/plugins/llorix-one-companion//css/style.css?ver=5.0.4 "https://dbadmins.ru/2016/10/17/%D0%9F%D1%80%D0%BE%D0%B4%D0%BE%D0%BB%D0%B6%D0%B0%D0%B5%D0%BC-%D1%8D%D0%BA%D1%81%D0%BF%D0%B5%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-%D1%81-lacp/"
      1 /web-server-%D0%BF%D0%BE%D0%B4-%D0%BA%D0%BB%D1%8E%D1%87/ "https://dbadmins.ru/"
      1 / "https://yandex.ru/"
      1 http://110.249.212.46/testget?q=23333&port=80 "-"
      1 http://110.249.212.46/testget?q=23333&port=443 "-"
      1 /favicon.ico "https://dbadmins.ru/favicon.ico"
      1 /favicon.ico "https://dbadmins.ru/2016/10/17/%D0%9F%D1%80%D0%BE%D0%B4%D0%BE%D0%BB%D0%B6%D0%B0%D0%B5%D0%BC-%D1%8D%D0%BA%D1%81%D0%BF%D0%B5%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-%D1%81-lacp/"
      1 /%D0%9F%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BA%D0%BE%D0%BD%D1%84%D0%B8%D0%B3%D1%83%D1%80%D0%B0%D1%86%D0%B8%D0%B9-%D0%B4%D0%BB%D1%8F-%D0%B2%D1%8B%D1%81/ "https://dbadmins.ru/"
      1 /category/%D0%97%D0%B0%D0%BF%D0%B8%D1%81%D0%BA%D0%B8-%D0%B0%D0%B4%D0%BC%D0%B8%D0%BD%D0%B0/ "https://dbadmins.ru/"
      1 /author/greed/ "https://dbadmins.ru/"
      1 /author/admin/ "https://dbadmins.ru/"
      1 /2017/11/01/standby-recover-from-service/ "https://dbadmins.ru/"
      1 /2017/11/01/ "https://dbadmins.ru/"
      1 /2017/09/28/ "https://dbadmins.ru/"
      1 /2017/09/28/%D0%BF%D1%80%D0%BE%D0%B1%D0%BB%D0%B5%D0%BC%D1%8B-dataguard-%D0%BF%D1%80%D0%B8-%D0%B4%D0%BE%D0%B1%D0%B0%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B8-%D0%BD%D0%BE%D0%B2%D0%BE%D0%B9-pdb-%D0%BD%D0%B0-%D0%BE/ "https://dbadmins.ru/"
      1 /2017/09/28/%D0%BF%D1%80%D0%BE%D0%B1%D0%BB%D0%B5%D0%BC%D0%B0-%D1%81-data-pump-%D0%BD%D0%B0-pdb/ "https://dbadmins.ru/"
      1 /2017/08/03/ora-00600-internal-error-code-arguments-k2gteget-pdbid-%D0%B2-oracle-12-0-1/ "https://dbadmins.ru/"
      1 /2017/08/03/ "https://dbadmins.ru/"
      1 /2017/08/03/enq-tm-contention/ "https://dbadmins.ru/"
      1 /2017/08/03/%D0%BC%D0%BE%D0%BD%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%BD%D0%B3-%D1%81-%D0%BF%D0%BE%D0%BC%D0%BE%D1%89%D1%8C%D1%8E-sysstat/ "https://dbadmins.ru/"
      1 /2017/06/07/pdb-warning-%D0%BE-%D1%81%D1%83%D1%89%D0%B5%D1%81%D1%82%D0%B2%D1%83%D1%8E%D1%89%D0%B5%D0%BC-%D0%B8%D0%BC%D0%B5%D0%BD%D0%B8-%D1%81%D0%B5%D1%80%D0%B2%D0%B8%D1%81%D0%B0/ "https://dbadmins.ru/"
      1 /2017/06/07/ "https://dbadmins.ru/"
      1 /2017/05/19/ "https://dbadmins.ru/"
      1 /2017/05/19/%D1%81%D0%BC%D0%B5%D0%BD%D0%B0-%D0%BF%D0%B0%D1%80%D0%BE%D0%BB%D1%8F-%D1%83-asmsnmp/ "https://dbadmins.ru/"
      1 /2017/05/19/%d0%be%d0%b1%d0%bd%d0%b0%d1%80%d1%83%d0%b6%d0%b5%d0%bd%d0%b8%d0%b5-%d0%bd%d0%be%d0%b2%d1%8b%d1%85-scsi-%d1%83%d1%81%d1%82%d1%80%d0%be%d0%b9%d1%81%d1%82%d0%b2-%d1%80%d0%b0%d1%81%d1%88%d0%b8%d1%80/ "https://dbadmins.ru/category/%d0%97%d0%b0%d0%bf%d0%b8%d1%81%d0%ba%d0%b8-%d0%b0%d0%b4%d0%bc%d0%b8%d0%bd%d0%b0/"
      1 /2017/05/19/%D0%BE%D0%B1%D0%BD%D0%B0%D1%80%D1%83%D0%B6%D0%B5%D0%BD%D0%B8%D0%B5-%D0%BD%D0%BE%D0%B2%D1%8B%D1%85-scsi-%D1%83%D1%81%D1%82%D1%80%D0%BE%D0%B9%D1%81%D1%82%D0%B2-%D1%80%D0%B0%D1%81%D1%88%D0%B8%D1%80/ "https://dbadmins.ru/"
      1 /2017/05/19/%D0%BC%D0%BE%D0%BD%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%BD%D0%B3-%D0%B1%D1%8D%D0%BA%D0%B0%D0%BF%D0%BE%D0%B2/ "https://dbadmins.ru/"
      1 /2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/ "https://www.google.ru/url?sa=t&rct=j&q=&esrc=s&source=web&cd=39&cad=rja&uact=8&ved=2ahUKEwiht6u56YHkAhXMb5oKHbX6D044HhAWMAh6BAgJEAE&url=https%3A%2F%2Fdbadmins.ru%2F2016%2F10%2F26%2F%25D0%25B8%25D0%25B7%25D0%25BC%25D0%25B5%25D0%25BD%25D0%25B5%25D0%25BD%25D0%25B8%25D0%25B5-%25D1%2581%25D0%25B5%25D1%2582%25D0%25B5%25D0%25B2%25D1%258B%25D1%2585-%25D0%25BD%25D0%25B0%25D1%2581%25D1%2582%25D1%2580%25D0%25BE%25D0%25B5%25D0%25BA-%25D0%25B4%25D0%25BB%25D1%258F-oracle-rac%2F&usg=AOvVaw3QLNad7whqTwvL_SWmN23l"
      1 /2016/10/17/%D0%9F%D1%80%D0%BE%D0%B4%D0%BE%D0%BB%D0%B6%D0%B0%D0%B5%D0%BC-%D1%8D%D0%BA%D1%81%D0%BF%D0%B5%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-%D1%81-lacp/ "https://www.google.ru/"
Ошибки веб-сервера/приложения c момента последнего запуска
162.243.13.195 - - [14/Aug/2019:09:31:47 +0300] "POST /wp-admin/admin-ajax.php?page=301bulkoptions HTTP/1.1" 400 11 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36"rt=0.241 uct="0.000" uht="0.241" urt="0.241"
162.243.13.195 - - [14/Aug/2019:09:31:50 +0300] "GET /wp-admin/admin-ajax.php?page=301bulkoptions HTTP/1.1" 400 11 "http://dbadmins.ru/wp-admin/admin-ajax.php?page=301bulkoptions" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36"rt=0.237 uct="0.000" uht="0.237" urt="0.237"
62.210.252.196 - - [14/Aug/2019:11:57:31 +0300] "POST /wp-admin/admin-ajax.php?page=301bulkoptions HTTP/1.1" 400 11 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36"rt=0.236 uct="0.000" uht="0.236" urt="0.236"
62.210.252.196 - - [14/Aug/2019:11:57:34 +0300] "GET /wp-admin/admin-ajax.php?page=301bulkoptions HTTP/1.1" 400 11 "http://dbadmins.ru/wp-admin/admin-ajax.php?page=301bulkoptions" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36"rt=0.232 uct="0.000" uht="0.232" urt="0.232"
60.208.103.154 - - [14/Aug/2019:11:59:33 +0300] "\x16\x03\x01\x00Z\x01\x00\x00V\x03\x01]S\xCD{\xA0\xFF\x0F\x93B\x04\x97\x8B|2i\x17\xE44Z\xAD\xE9\x2243B\x85E6b\xB1{\xB6\x00\x00\x18\x00/\x005\x00\x05\x00" 400 173 "-" "-"rt=0.189 uct="-" uht="-" urt="-"
60.208.103.154 - - [14/Aug/2019:11:59:33 +0300] "\x16\x03\x01\x00Z\x01\x00\x00V\x03\x01]S\xCD{\x8D\xA5\xE6\xAD\xDE&\x18\xC9\xDA\xB1\xCA\xE1\xE2\x05\x83\x00\xDE/\xB3G\x18j\x85\xC7\xBD\xDEvp\x00\x00\x18\x00/\x005\x00\x05\x00" 400 173 "-" "-"rt=0.194 uct="-" uht="-" urt="-"
118.139.177.119 - - [14/Aug/2019:12:58:37 +0300] "GET /w00tw00t.at.ISC.SANS.DFind:) HTTP/1.1" 400 173 "-" "-"rt=0.241 uct="-" uht="-" urt="-"
8.29.198.27 - - [14/Aug/2019:13:14:34 +0300] "GET /feed/ HTTP/1.1" 200 36082 "-" "Feedly/1.0 (+http://www.feedly.com/fetcher.html; 1 subscribers; like FeedFetcher-Google)"rt=0.400 uct="0.000" uht="0.231" urt="0.383"
110.249.212.46 - - [14/Aug/2019:13:17:41 +0300] "GET http://110.249.212.46/testget?q=23333&port=80 HTTP/1.1" 400 173 "-" "-"rt=2.710 uct="-" uht="-" urt="-"
110.249.212.46 - - [14/Aug/2019:13:17:41 +0300] "GET http://110.249.212.46/testget?q=23333&port=443 HTTP/1.1" 400 173 "-" "-"rt=2.716 uct="-" uht="-" urt="-"
61.219.11.153 - - [14/Aug/2019:13:47:51 +0300] "\x01A\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" 400 173 "-" "-"rt=0.295 uct="-" uht="-" urt="-"
61.219.11.153 - - [14/Aug/2019:17:33:54 +0300] "\x01A\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" 400 173 "-" "-"rt=0.283 uct="-" uht="-" urt="-"
185.142.236.35 - - [14/Aug/2019:19:23:14 +0300] "" 400 0 "-" "-"rt=0.000 uct="-" uht="-" urt="-"
185.142.236.35 - - [14/Aug/2019:19:23:15 +0300] "" 400 0 "-" "-"rt=0.000 uct="-" uht="-" urt="-"
185.142.236.35 - - [14/Aug/2019:19:23:15 +0300] "" 400 0 "-" "-"rt=0.000 uct="-" uht="-" urt="-"
185.142.236.35 - - [14/Aug/2019:19:23:15 +0300] "" 400 0 "-" "-"rt=0.000 uct="-" uht="-" urt="-"
185.142.236.35 - - [14/Aug/2019:19:23:18 +0300] "quit" 400 173 "-" "-"rt=0.011 uct="-" uht="-" urt="-"
185.142.236.35 - - [14/Aug/2019:19:23:22 +0300] "" 400 0 "-" "-"rt=0.000 uct="-" uht="-" urt="-"
89.32.248.234 - - [14/Aug/2019:22:11:35 +0300] "POST /xmlrpc.php HTTP/1.1" 200 292 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0"rt=0.400 uct="0.000" uht="0.248" urt="0.248"
172.104.242.173 - - [14/Aug/2019:23:22:13 +0300] "9\xCD\xC3V\x8C&\x12Dz/\xB7\xC0t\x96C\xE2" 400 173 "-" "-"rt=0.010 uct="-" uht="-" urt="-"
217.118.66.161 - - [14/Aug/2019:10:21:00 +0300] "GET /wp-content/themes/llorix-one-lite/fonts/fontawesome-webfont.eot? HTTP/1.1" 403 46 "https://dbadmins.ru/2016/10/26/%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85-%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B5%D0%BA-%D0%B4%D0%BB%D1%8F-oracle-rac/" "Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; Touch; rv:11.0) like Gecko"rt=0.000 uct="0.000" uht="0.000" urt="0.000"
93.158.167.130 - - [14/Aug/2019:05:02:20 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
87.250.233.68 - - [14/Aug/2019:05:04:20 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
107.179.102.58 - - [14/Aug/2019:05:22:10 +0300] "GET /wp-content/plugins/uploadify/readme.txt HTTP/1.1" 404 200 "http://dbadmins.ru/wp-content/plugins/uploadify/readme.txt" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.152 Safari/537.36"rt=0.000 uct="-" uht="-" urt="-"
87.250.244.2 - - [14/Aug/2019:06:07:07 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
77.247.110.165 - - [14/Aug/2019:06:13:53 +0300] "HEAD /robots.txt HTTP/1.0" 404 0 "-" "-"rt=0.018 uct="-" uht="-" urt="-"
87.250.233.76 - - [14/Aug/2019:06:45:20 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
71.6.199.23 - - [14/Aug/2019:07:07:19 +0300] "GET /robots.txt HTTP/1.1" 404 3652 "-" "-"rt=0.000 uct="-" uht="-" urt="-"
71.6.199.23 - - [14/Aug/2019:07:07:20 +0300] "GET /sitemap.xml HTTP/1.1" 404 3652 "-" "-"rt=0.000 uct="-" uht="-" urt="-"
71.6.199.23 - - [14/Aug/2019:07:07:20 +0300] "GET /.well-known/security.txt HTTP/1.1" 404 3652 "-" "-"rt=0.000 uct="-" uht="-" urt="-"
71.6.199.23 - - [14/Aug/2019:07:07:21 +0300] "GET /favicon.ico HTTP/1.1" 404 3652 "-" "python-requests/2.19.1"rt=0.000 uct="-" uht="-" urt="-"
141.8.141.136 - - [14/Aug/2019:07:09:43 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
93.158.167.130 - - [14/Aug/2019:08:10:56 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
87.250.233.68 - - [14/Aug/2019:08:21:48 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
78.39.67.210 - - [14/Aug/2019:08:23:41 +0300] "GET /admin/config.php HTTP/1.1" 404 29500 "-" "curl/7.15.5 (x86_64-redhat-linux-gnu) libcurl/7.15.5 OpenSSL/0.9.8b zlib/1.2.3 libidn/0.6.5"rt=0.480 uct="0.000" uht="0.192" urt="0.243"
176.9.56.104 - - [14/Aug/2019:08:30:17 +0300] "GET /1 HTTP/1.1" 404 29513 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:64.0) Gecko/20100101 Firefox/64.0"rt=0.233 uct="0.000" uht="0.182" urt="0.233"
87.250.233.75 - - [14/Aug/2019:09:21:46 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
162.243.13.195 - - [14/Aug/2019:09:31:48 +0300] "GET /1 HTTP/1.1" 404 29500 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:64.0) Gecko/20100101 Firefox/64.0"rt=0.308 uct="0.000" uht="0.187" urt="0.237"
162.243.13.195 - - [14/Aug/2019:09:31:52 +0300] "GET /1 HTTP/1.1" 404 29500 "http://dbadmins.ru/1" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:64.0) Gecko/20100101 Firefox/64.0"rt=0.303 uct="0.000" uht="0.180" urt="0.230"
93.158.167.130 - - [14/Aug/2019:10:27:26 +0300] "GET /robots.txt HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)"rt=0.000 uct="-" uht="-" urt="-"
93.158.167.130 - - [14/Aug/2019:10:27:30 +0300] "GET /sitemap.xml HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)"rt=0.000 uct="-" uht="-" urt="-"
93.158.167.130 - - [14/Aug/2019:10:27:34 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
87.250.233.68 - - [14/Aug/2019:11:32:44 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
141.8.141.136 - - [14/Aug/2019:11:33:32 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
77.247.110.201 - - [14/Aug/2019:11:56:29 +0300] "GET /admin/config.php HTTP/1.1" 404 3652 "-" "curl/7.19.7 (x86_64-redhat-linux-gnu) libcurl/7.19.7 NSS/3.27.1 zlib/1.2.3 libidn/1.18 libssh2/1.4.2"rt=0.000 uct="-" uht="-" urt="-"
62.210.252.196 - - [14/Aug/2019:11:57:32 +0300] "GET /1 HTTP/1.1" 404 29500 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:64.0) Gecko/20100101 Firefox/64.0"rt=0.540 uct="0.000" uht="0.183" urt="0.540"
62.210.252.196 - - [14/Aug/2019:11:57:35 +0300] "GET /1 HTTP/1.1" 404 29500 "http://dbadmins.ru/1" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:64.0) Gecko/20100101 Firefox/64.0"rt=0.262 uct="0.000" uht="0.212" urt="0.262"
60.208.103.154 - - [14/Aug/2019:11:59:33 +0300] "GET /manager/html HTTP/1.1" 404 3652 "-" "User-Agent:Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705"rt=0.000 uct="-" uht="-" urt="-"
93.158.167.130 - - [14/Aug/2019:12:35:00 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
87.250.233.68 - - [14/Aug/2019:13:36:55 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
5.45.203.12 - - [14/Aug/2019:13:41:42 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
93.158.167.130 - - [14/Aug/2019:14:50:19 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
87.250.233.68 - - [14/Aug/2019:14:52:27 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
141.8.141.136 - - [14/Aug/2019:15:52:52 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
93.158.167.130 - - [14/Aug/2019:16:18:16 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
5.45.203.12 - - [14/Aug/2019:16:53:55 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
77.247.110.69 - - [14/Aug/2019:17:19:49 +0300] "HEAD /robots.txt HTTP/1.0" 404 0 "-" "-"rt=0.019 uct="-" uht="-" urt="-"
87.250.233.76 - - [14/Aug/2019:17:52:20 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
93.158.167.130 - - [14/Aug/2019:17:55:02 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
87.250.233.68 - - [14/Aug/2019:19:02:51 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
93.158.167.130 - - [14/Aug/2019:19:16:50 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
185.142.236.35 - - [14/Aug/2019:19:23:18 +0300] "GET /.well-known/security.txt HTTP/1.1" 404 169 "-" "-"rt=0.000 uct="-" uht="-" urt="-"
87.250.233.68 - - [14/Aug/2019:20:03:43 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
93.158.167.130 - - [14/Aug/2019:20:40:19 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
87.250.233.68 - - [14/Aug/2019:20:42:50 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
5.45.203.12 - - [14/Aug/2019:21:50:58 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
93.158.167.130 - - [14/Aug/2019:22:05:00 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
87.250.233.68 - - [14/Aug/2019:22:56:43 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
93.158.167.130 - - [14/Aug/2019:23:31:56 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
77.247.110.165 - - [14/Aug/2019:23:44:18 +0300] "HEAD /robots.txt HTTP/1.0" 404 0 "-" "-"rt=0.017 uct="-" uht="-" urt="-"
87.250.233.68 - - [15/Aug/2019:00:00:37 +0300] "GET / HTTP/1.1" 404 169 "-" "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots yabs01)"rt=0.000 uct="-" uht="-" urt="-"
182.254.243.249 - - [15/Aug/2019:00:24:38 +0300] "GET /webdav/ HTTP/1.1" 404 3652 "-" "Mozilla/5.0"rt=0.222 uct="-" uht="-" urt="-"
182.254.243.249 - - [15/Aug/2019:00:24:38 +0300] "PROPFIND / HTTP/1.1" 405 173 "-" "-"rt=0.214 uct="-" uht="-" urt="-"
62.75.198.172 - - [14/Aug/2019:08:23:40 +0300] "POST /wp-cron.php?doing_wp_cron=1565760219.4257180690765380859375 HTTP/1.1" 499 0 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565760219.4257180690765380859375" "WordPress/5.0.4; https://dbadmins.ru"rt=1.001 uct="-" uht="-" urt="-"
62.75.198.172 - - [14/Aug/2019:20:25:44 +0300] "POST /wp-cron.php?doing_wp_cron=1565803543.6812090873718261718750 HTTP/1.1" 499 0 "https://dbadmins.ru/wp-cron.php?doing_wp_cron=1565803543.6812090873718261718750" "WordPress/5.0.4; https://dbadmins.ru"rt=1.002 uct="-" uht="-" urt="-"
193.106.30.99 - - [14/Aug/2019:06:02:50 +0300] "GET /wp-includes/ID3/comay.php HTTP/1.1" 500 595 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36"rt=0.000 uct="-" uht="-" urt="-"
107.179.102.58 - - [14/Aug/2019:20:46:45 +0300] "GET /wp-content/plugins/uploadify/includes/check.php HTTP/1.1" 500 595 "http://dbadmins.ru/wp-content/plugins/uploadify/includes/check.php" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.152 Safari/537.36"rt=0.000 uct="-" uht="-" urt="-"
193.106.30.99 - - [14/Aug/2019:22:04:04 +0300] "POST /wp-content/uploads/2018/08/seo_script.php HTTP/1.1" 500 595 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36"rt=0.062 uct="-" uht="-" urt="-"
Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта
    498 200
     95 301
     51 404
      7 400
      3 500
      2 499
      1 405
      1 403
      1 304
Предотвращение одновременного запуска нескольких копий, до его завершения
70171
70201
Killed
```
