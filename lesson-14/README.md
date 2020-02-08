# Урок 14. "Резервное копирование."
## Домашнее задание
Настраиваем бэкапы
Настроить стенд Vagrant с двумя виртуальными машинами server и client.

Настроить политику бэкапа директории /etc с клиента:
1. Полный бэкап - раз в день
2. Инкрементальный - каждые 10 минут
3. Дифференциальный - каждые 30 минут

Запустить систему на два часа. Для сдачи ДЗ приложить list jobs, list files jobid=<id>
и сами конфиги bacula-*

* Настроить доп. Опции - сжатие, шифрование, дедупликация

## Результат

Результатом выполнения домашнего задания является Vagrant стенд, в котором при помощи ansible provisioning выполняется конфигурация СРК Bacula для сервера и клиента.

Запуск стенда:
```bash
# vagrant up
```

### Проверка общей работоспособности ###
Самое первое запланированное задание проходит как Full, в которое попали 2,394 файла и директории.

| JobId | Name                | StartTime           | Type | Level | JobFiles | JobBytes   | JobStatus |
|-------|---------------------|---------------------|------|-------|----------|------------|-----------|
|     1 | otus-client_fs      | 2019-09-27 06:25:14 | B    | F     |    2,394 | 11,467,344 | T         |


Создадим на клиенте новый файл:
```bash
# cd /etc
# dd if=/dev/zero of=otus-1 bs=10M count=1
```
В результате выполнения дифференциального и инкрементального бэкапов получаем следующий результат:

| JobId | Name                | StartTime           | Type | Level | JobFiles | JobBytes   | JobStatus |
|-------|---------------------|---------------------|------|-------|----------|------------|-----------|
|     2 | otus-client_fs      | 2019-09-27 06:30:02 | B    | D     |        2 |     14,736 | T         |
|     3 | otus-client_fs      | 2019-09-27 06:35:02 | B    | I     |        0 |          0 | T         |


### Проверка сжатия резервных копий ###
Создадим на клиенте новый файл:
```bash
# cd /etc
# dd if=/dev/zero of=otus-2 bs=10M count=1
```
Выполним инкрементальное резервное копирование. В результате выполнения задания получаем следующий вывод в лог файле:
```
  Build OS:               x86_64-redhat-linux-gnu redhat (Core)
  JobId:                  6
  Job:                    otus-client_fs.2019-09-27_06.41.43_08
  Backup Level:           Incremental, since=2019-09-27 06:41:13
  Client:                 "otus-client" 5.2.13 (19Jan13) x86_64-redhat-linux-gnu,redhat,(Core)
  FileSet:                "otus-client-FS-compress" 2019-09-27 06:25:01
  Pool:                   "files-pool" (From Job resource)
  Catalog:                "OTUSCatalog" (From Client resource)
  Storage:                "backup-sd" (From Job resource)
  Scheduled time:         27-Sep-2019 06:41:42
  Start time:             27-Sep-2019 06:41:45
  End time:               27-Sep-2019 06:41:46
  Elapsed time:           1 sec
  Priority:               10
  FD Files Written:       2
  SD Files Written:       2
  FD Bytes Written:       14,736 (14.73 KB)
  SD Bytes Written:       15,222 (15.22 KB)
  Rate:                   14.7 KB/s
  Software Compression:   99.9 %
  VSS:                    no
  Encryption:             yes
  Accurate:               no
  Volume name(s):         vol-0001
  Volume Session Id:      6
  Volume Session Time:    1569565489
  Last Volume Bytes:      2,464,405 (2.464 MB)
  Non-fatal FD errors:    0
  SD Errors:              0
  FD termination status:  OK
  SD termination status:  OK
  Termination:            Backup OK
```

Как видим `Software Compression: 99.9 %` и размер бэкапа ~15КБ.


### Проверка шифрования ###
Также в результате выполнения предыдущего задания из лог файла получаем информацию `Encryption: yes`, т.е. шифрование включено.


### Проверка дедупликации
Выполним базовое задание для создания опорного бэкапа.

| JobId | Name                | StartTime           | Type | Level | JobFiles | JobBytes   | JobStatus |
|-------|---------------------|---------------------|------|-------|----------|------------|-----------|
|     8 | otus-client_base_dd | 2019-09-27 06:49:46 | B    | B     |    2,394 | 28,301,024 | T         |

Создадим на клиенте новый файл:
```bash
# cd /etc
# dd if=/dev/zero of=otus-3 bs=10M count=1
```

Выполним полный бэкап клиента:

| JobId | Name                | StartTime           | Type | Level | JobFiles | JobBytes   | JobStatus |
|-------|---------------------|---------------------|------|-------|----------|------------|-----------|
|     8 | otus-client_base_dd | 2019-09-27 06:49:46 | B    | B     |    2,396 | 28,301,024 | T         |
|     9 | otus-client_fs_dd   | 2019-09-27 07:09:08 | B    | F     |    2,397 | 10,487,056 | T         |

Как видим, прошел полный бэкап, в который входят все файлы, но размер равен только новому файлу, фактически выполнен дифференциальный бэкап.
