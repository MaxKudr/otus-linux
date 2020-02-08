# Урок 02. "Дисковая подсистема"

# Домашнее задание

Системный администратор обязан уметь работать дисковой подсистемой, делать это без ошибок, не допускать потерю данных. В этом задании необходимо продемонстрировать умение работать с software raid и инструментами для работы с работы с разделами (`parted`, `fdisk`, `lsblk`):

- добавить в Vagrantfile еще дисков
- сломать/починить raid
- собрать R0/R5/R10 - на выбор 
- создать на рейде GPT раздел и 5 партиций

В качестве проверки принимаются - измененный Vagrantfile, скрипт для создания рейда.

\* доп. задание - Vagrantfile, который сразу собирает систему с подключенным рейдом

** перенесети работающую систему с одним диском на RAID1. Даунтайм на загрузку с нового диска предполагается. В качестве проверки принимается вывод команды `lsblk` до и после и описание хода решения (можно воспользовать утилитой Script).

Критерии оценки:

- 4 принято - сдан Vagrantfile и скрипт для сборки, который можно запустить на поднятом образе
- 5 сделано доп задание

## Результат

Результатом выполнения домашнего задания является Vagrantfile, в котором при помощи ansible provision выполняется подготовка raid5 массива и перенос существующей виртульной машины на этот массив (выполнение задания со * и **).

```bash
# vagrant up
```

После выполнения provisioning выполнить скрипт , который остановит виртуальную машину и удалит из текущей конфигурации диск IDE, оставив только диски с raid5. 

```bash
# ./after_provision.sh
```

Выполнить повторный запуск виртуальной машины. Запуск виртуальной машины будет осуществлен с raid5 массива.

```bash
# vagrant up
```

### Ломаем и чиним массив

Текущее состояние:

```bash
# lsblk 
NAME    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda       8:0    0   20G  0 disk  
├─sda1    8:1    0 1007K  0 part  
├─sda2    8:2    0  499M  0 part  
│ └─md2   9:2    0  994M  0 raid5 /boot
└─sda3    8:3    0 19.5G  0 part  
  └─md3   9:3    0   39G  0 raid5 /
sdb       8:16   0   20G  0 disk  
├─sdb1    8:17   0 1007K  0 part  
├─sdb2    8:18   0  499M  0 part  
│ └─md2   9:2    0  994M  0 raid5 /boot
└─sdb3    8:19   0 19.5G  0 part  
  └─md3   9:3    0   39G  0 raid5 /
sdc       8:32   0   20G  0 disk  
├─sdc1    8:33   0 1007K  0 part  
├─sdc2    8:34   0  499M  0 part  
│ └─md2   9:2    0  994M  0 raid5 /boot
└─sdc3    8:35   0 19.5G  0 part  
  └─md3   9:3    0   39G  0 raid5 /
```

```bash
# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md3 : active raid5 sdb3[1] sdc3[2] sda3[0]
      40882176 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
      
md2 : active raid5 sdc2[2] sdb2[1] sda2[0]
      1017856 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
```

- Ломаем диск:

```bash
# mdadm /dev/md3 --fail /dev/sdc3
mdadm: set /dev/sdc3 faulty in /dev/md3
```

- Проверяем состояние рейда:

```bash
# mdadm -D /dev/md3
/dev/md3:
           Version : 1.2
     Creation Time : Mon Aug 19 09:07:52 2019
        Raid Level : raid5
        Array Size : 40882176 (38.99 GiB 41.86 GB)
     Used Dev Size : 20441088 (19.49 GiB 20.93 GB)
      Raid Devices : 3
     Total Devices : 3
       Persistence : Superblock is persistent

       Update Time : Mon Aug 19 10:10:19 2019
             State : clean, degraded 
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 1
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : lesson-02:3  (local to host lesson-02)
              UUID : 3dc613d5:9c8f7ad0:26ae4b4f:48533886
            Events : 10

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
       -       0        0        2      removed

       2       8       35        -      faulty   /dev/sdc3
```

- Удаляем сбойный диск:

```bash
# mdadm /dev/md3 --remove /dev/sdc3
mdadm: hot removed /dev/sdc3 from /dev/md3
```

- Снова проверяем состояние рейда:

```bash
# mdadm -D /dev/md3
/dev/md3:
           Version : 1.2
     Creation Time : Mon Aug 19 09:07:52 2019
        Raid Level : raid5
        Array Size : 40882176 (38.99 GiB 41.86 GB)
     Used Dev Size : 20441088 (19.49 GiB 20.93 GB)
      Raid Devices : 3
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Mon Aug 19 10:11:49 2019
             State : clean, degraded 
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : lesson-02:3  (local to host lesson-02)
              UUID : 3dc613d5:9c8f7ad0:26ae4b4f:48533886
            Events : 17

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
       -       0        0        2      removed
```

- Восстанавливаем рейд:

```bash
# mdadm /dev/md3 --add /dev/sdc3
mdadm: added /dev/sdc3
```

- Проверяем что диск добавился и началась синхронизация:

```bash
# mdadm -D /dev/md3
/dev/md3:
           Version : 1.2
     Creation Time : Mon Aug 19 09:07:52 2019
        Raid Level : raid5
        Array Size : 40882176 (38.99 GiB 41.86 GB)
     Used Dev Size : 20441088 (19.49 GiB 20.93 GB)
      Raid Devices : 3
     Total Devices : 3
       Persistence : Superblock is persistent

       Update Time : Mon Aug 19 10:13:49 2019
             State : clean, degraded, recovering 
    Active Devices : 2
   Working Devices : 3
    Failed Devices : 0
     Spare Devices : 1

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

    Rebuild Status : 3% complete

              Name : lesson-02:3  (local to host lesson-02)
              UUID : 3dc613d5:9c8f7ad0:26ae4b4f:48533886
            Events : 27

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
       3       8       35        2      spare rebuilding   /dev/sdc3
```

```bash
# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md3 : active raid5 sdc3[3] sdb3[1] sda3[0]
      40882176 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [UU_]
      [=>...................]  recovery =  9.3% (1902464/20441088) finish=16.3min speed=18853K/sec
      
md2 : active raid5 sdc2[2] sdb2[1] sda2[0]
      1017856 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]      
```

- По завершению синхронизации проверяем состояние рейда:

```bash
# mdadm -D /dev/md3
/dev/md3:
           Version : 1.2
     Creation Time : Mon Aug 19 09:07:52 2019
        Raid Level : raid5
        Array Size : 40882176 (38.99 GiB 41.86 GB)
     Used Dev Size : 20441088 (19.49 GiB 20.93 GB)
      Raid Devices : 3
     Total Devices : 3
       Persistence : Superblock is persistent

       Update Time : Mon Aug 19 11:03:27 2019
             State : clean 
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : lesson-02:3  (local to host lesson-02)
              UUID : 3dc613d5:9c8f7ad0:26ae4b4f:48533886
            Events : 66

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
       3       8       35        2      active sync   /dev/sdc3
```

