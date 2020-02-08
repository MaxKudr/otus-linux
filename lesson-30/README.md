# Урок 30. "PostgreSQL"
## Домашнее задание
PostgreSQL
- Настроить hot_standby репликацию с использованием слотов
- Настроить правильное резервное копирование

Для сдачи работы присылаем ссылку на репозиторий, в котором должны обязательно быть Vagranfile и плейбук Ansible, конфигурационные файлы postgresql.conf, pg_hba.conf и recovery.conf, а так же конфиг barman, либо скрипт резервного копирования. Команда "vagrant up" должна поднимать машины с настроенной репликацией и резервным копированием. Рекомендуется в README.md файл вложить результаты (текст или скриншоты) проверки работы репликации и резервного копирования.

## Результат
Результатом выполнения домашнего задания является Vagrant файл, который средствами ansible provisioning подготавливает следующий стенд:
- `master` сервер с установленным PostgreSQL сервером
- `slave` сервер с установленным PostgreSQL сервером и настроенной репликацией `hot_standby`
- `barman` сервер с установленным и настроенный средством резервного копирования `barman`. Резервное копирование выполняется с реплики `slave`

**Запуск стенда**
```bash
# vagrant up
```

### Проверка репликации
Зайдем на `master` сервер в консоль PostgreSQL провери статус репликации и создадим тестовую базу данных `otus`
```bash
$ vagrant ssh master
$ sudo -i

# su - postgres -c psql

postgres=# select * from pg_stat_replication;
-[ RECORD 1 ]----+------------------------------
pid              | 6622
usesysid         | 16384
usename          | repluser
application_name | walreceiver
client_addr      | 10.10.10.2
client_hostname  |
client_port      | 60964
backend_start    | 2019-12-24 20:01:06.429896+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/6000148
write_lsn        | 0/6000148
flush_lsn        | 0/6000148
replay_lsn       | 0/6000148
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2019-12-24 20:34:34.155729+00


postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(3 rows)

postgres=# create database otus;
CREATE DATABASE

postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 otus      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(4 rows)
```

Зайдем на `slave` сервер и проверим репликацию
```bash
$ vagrant ssh slave
$ sudo -i

# su - postgres -c psql

postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 otus      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(4 rows)
```

### Проверка резервного копирования
Зайдем на `barman` сервер и проверим состояние системы `barman`
```bash
$ vagrant ssh slave
$ sudo -i

# barman check slave
Server slave:
        PostgreSQL: OK
        is_superuser: OK
        PostgreSQL streaming: OK
        wal_level: OK
        replication slot: OK
        directories: OK
        retention policy settings: OK
        backup maximum age: OK (no last_backup_maximum_age provided)
        compression settings: OK
        failed backups: OK (there are 0 failed backups)
        minimum redundancy requirements: OK (have 0 backups, expected at least 0)
        pg_basebackup: OK
        pg_basebackup compatible: OK
        pg_basebackup supports tablespaces mapping: OK
        systemid coherence: OK (no system Id stored on disk)
        pg_receivexlog: OK
        pg_receivexlog compatible: OK
        receive-wal running: OK
        archiver errors: OK
```

Запустим выполнение резервной копии сервера `slave`
```bash
# barman backup slave --wait
Starting backup using postgres method for server slave in /var/lib/barman/slave/base/20191224T202709
Backup start at LSN: 0/5000148
Starting backup copy via pg_basebackup for 20191224T202709
Copy done (time: 10 seconds)
Finalising the backup.
This is the first backup for server slave
WAL segments preceding the current backup have been found:
        000000010000000000000003 from server slave has been removed
        000000010000000000000004 from server slave has been removed
Backup size: 31.0 MiB
Backup end at LSN: 0/5000148 (000000010000000000000005, 00000148)
Backup completed (start time: 2019-12-24 20:27:09.332564, elapsed time: 13 seconds)
Waiting for the WAL file 000000010000000000000005 from server 'slave'
Processing xlog segments from streaming for slave
        000000010000000000000005
```

Чтобы долго не ждать получения WAL, на `master` сервере можно выполнить команду смены wal.
```bash
postgres=# select * from pg_switch_wal();
```

Проверим список существующих резервных копий для сервера `slave`
```bash
# barman list-backup slave
slave 20191224T202709 - Tue Dec 24 20:27:19 2019 - Size: 47.0 MiB - WAL Size: 0 B
```