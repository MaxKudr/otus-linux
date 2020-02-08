# Урок 08. "Инициализация системы. Systemd и SysV"
## Домашнее задание
Управление автозагрузкой сервисов происходит через systemd. Вместо cron'а тоже используется systemd. И много других возможностей. В ДЗ нужно написать свой systemd-unit.
1. Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig
2. Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.
3. Дополнить юнит-файл apache httpd возможностью запустить несколько инстансов сервера с разными конфигами
4. (*)Скачать демо-версию Atlassian Jira и переписать основной скрипт запуска на unit-файл
Задание необходимо сделать с использованием Vagrantfile и proviosioner shell (или ansible, на Ваше усмотрение)

## Результат
Результатом выполнения домашнего задания являются 4 Vagrant файла.

### Задание 1
В данном задании инсталлируется сервис `mon-log` со своим таймеров, который мониторит файл `/var/log/mon-log`каждые 30 сек.  на наличие слова `OTUS` (параметры берутся из конгфигурационного файла `/etc/sysconfig/mon-log`). Если нашлось слово в лог-файле, сервис пишет в журнал сообщение что нашлось слово в наблюдаемом файле. При каждом запуске сервиса по таймеру анализ лога проводится с того места, где остановился на прошлом запуске.

Запуск стенда:
```bash
# cd p1
# vagrant up
```

Проверка:
```bash
# vi /var/log/mon-log
 1st line
 2nd line
 OTUS
 3rd line
 
# journalctl -efn
:
Sep 11 21:09:00 lesson-08-p1 systemd[1]: Starting Monitoring log service...
Sep 11 21:09:00 lesson-08-p1 mon-log[5393]: Find "OTUS" in file /var/log/mon-log
Sep 11 21:09:00 lesson-08-p1 systemd[1]: Started Monitoring log service.
:
```

### Задание 2
В данном задании инсталлируется пакет `spawn-fcgi` совместно с `http` и `php`. Удалаяется init-скрипт и устанавливается systemd unit файл. После чего запускается сервис `spawn-fcgi`. Т.к. в рамках данного задания цель показать запуск сервиса, то интеграция `httpd` и `spawn-fcgi` (`php-cgi`)  не выполнялась.

Запуск стенда:
```bash
# cd p2
# vagrant up
```

Проверка:
```bash
# systemctl status spawn-fcgi
● spawn-fcgi.service - Spawn FastCGI service to be used by web servers
   Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2019-09-11 21:15:15 UTC; 2min 55s ago
  Process: 5563 ExecStart=/usr/bin/spawn-fcgi $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 5564 (php-cgi)
   CGroup: /system.slice/spawn-fcgi.service
           ├─5564 /usr/bin/php-cgi
           ├─5567 /usr/bin/php-cgi
:
:
Sep 11 21:15:15 lesson-08-p2 systemd[1]: Starting Spawn FastCGI service to be used by web servers...
Sep 11 21:15:15 lesson-08-p2 spawn-fcgi[5563]: spawn-fcgi: child spawned successfully: PID: 5564
Sep 11 21:15:15 lesson-08-p2 systemd[1]: Started Spawn FastCGI service to be used by web servers.

# ps axf
:
 5564 ?        Ss     0:00 /usr/bin/php-cgi
 5567 ?        S      0:00  \_ /usr/bin/php-cgi
 5568 ?        S      0:00  \_ /usr/bin/php-cgi
 5569 ?        S      0:00  \_ /usr/bin/php-cgi
 5570 ?        S      0:00  \_ /usr/bin/php-cgi
 5571 ?        S      0:00  \_ /usr/bin/php-cgi
:
```


### Задание 3
В данном задании выполняется:
- инсталляция пакета `httpd`
- клонирование конфигурационных файлов под два экземпляра (otus-1, otus-2)
- устанавливается новый systemd unit файл `httpd@.server`
- вносятся изменения в конфигурации для запуска сервисов на различных портах (otus-1 - 8080, otus-2 - 8008)
- одновременный запуск двух экземпляров

Запуск стенда:
```bash
# cd p3
# vagrant up
```

Проверка:
```bash
# systemctl status httpd@*
● httpd@otus-1.service - The Apache HTTP Server for otus-1 config
   Loaded: loaded (/etc/systemd/system/httpd@.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2019-09-11 21:28:09 UTC; 1min 16s ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 5575 (httpd)
:
:
● httpd@otus-2.service - The Apache HTTP Server for otus-2 config
   Loaded: loaded (/etc/systemd/system/httpd@.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2019-09-11 21:28:10 UTC; 1min 15s ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 5653 (httpd)


# ss -nlt | grep 80
LISTEN     0      128         :::8008                    :::*
LISTEN     0      128         :::8080                    :::*


# curl http://localhost:8008
OTUS lesson 08 part 3


# curl http://localhost:8080
OTUS lesson 08 part 3
```

### Задание 4

В данном задании выполняется:
- установка Java OpenJDK 11
- создание пользователя `jira`
- скачивание и установка *Atlassian Jira Software*
- внесение изменений в конфигурацию *Jira Software*
- установка systemd unit файл
- запуск *Jira Software*

Запуск стенда:
```bash
# cd p4
# vagrant up
```

Проверка:
```bash
# systemctl status jira-software
● jira-software.service - Atlassioan Jira Software application
   Loaded: loaded (/etc/systemd/system/jira-software.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2019-09-11 21:38:32 UTC; 3min 43s ago
  Process: 5542 ExecStart=/usr/share/jira-software/bin/start-jira.sh (code=exited, status=0/SUCCESS)
 Main PID: 5581 (java)
   CGroup: /system.slice/jira-software.service
           └─5581 /usr/bin/java -Djava.util.logging.config.file=/usr/share/jira-software/conf/logging.properties -D...


# ss src :8080 -nlt
State      Recv-Q Send-Q              Local Address:Port  ...
LISTEN     0      100                            :::8080  ...
```