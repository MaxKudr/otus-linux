# Урок 03. "Файловые системы и LVM"
# Домашнее задание
### Работа с LVM

На имеющемся образе /dev/mapper/VolGroup00-LogVol00 38G 738M 37G 2% /
- уменьшить том под / до 8G
- выделить том под /home
- выделить том под /var
- /var - сделать в mirror
- /home - сделать том для снэпшотов
- прописать монтирование в fstab

попробовать с разными опциями и разными файловыми системами ( на выбор)
- сгенерить файлы в /home/
- снять снэпшот
- удалить часть файлов
- восстановится со снэпшота
- залоггировать работу можно с помощью утилиты script

На нашей куче дисков попробовать поставить btrfs/zfs - с кешем, снэпшотами - разметить здесь каталог /opt

Критерии оценки:
- основная часть обязательна
- задание со звездочкой +1 балл

## Результат
Решение домашнего задания выполняется в несолько этапов.

### LVM
Подготовка стенда:
```bash
# vagrant up --no-provision
# vagrant provision --provision-with=stage1
# vagrant reload
# vagrant provision --provision-with=stage2
```
После выполнения вышеприведенных команд будет выполнено следующее:
- Уменьшен root до 8ГБ
- Перенесены директории home и var на отдельные lvm тома.

#### Работа со снэпшотами
Сгенерируем несколько файлов в /home
```bash
# cd /home
# for i in {1..9}; do echo $RANDOM > $i; done
# ll /home
total 40
-rw-r--r--. 1 root    root      6 Aug 22 15:30 1
-rw-r--r--. 1 root    root      6 Aug 22 15:30 2
-rw-r--r--. 1 root    root      6 Aug 22 15:30 3
-rw-r--r--. 1 root    root      6 Aug 22 15:30 4
-rw-r--r--. 1 root    root      5 Aug 22 15:30 5
-rw-r--r--. 1 root    root      6 Aug 22 15:30 6
-rw-r--r--. 1 root    root      5 Aug 22 15:30 7
-rw-r--r--. 1 root    root      6 Aug 22 15:30 8
-rw-r--r--. 1 root    root      6 Aug 22 15:30 9
drwx------. 4 vagrant vagrant 111 Aug 22 12:48 vagrant
```
Создадим снэпшот
```bash
# lvcreate -L100M -s -nhome-snap /dev/VolGroup00/home
# lvs
  LV        VG         Attr       LSize   Pool Origin Data%  Meta%  Move 
  LogVol00  VolGroup00 -wi-ao----   8.00g
  LogVol01  VolGroup00 -wi-ao----   1.50g
  home      VolGroup00 owi-aos---   2.00g
  home-snap VolGroup00 swi-a-s--- 128.00m      home   0.00
  var       VolGroup00 -wi-ao----   2.00g
```
Удалим часть файлов
```bash
# for i in {1..5}; do rm -f /home/$i; done
# ll
total 16
-rw-r--r--. 1 root    root      6 Aug 22 15:30 6
-rw-r--r--. 1 root    root      5 Aug 22 15:30 7
-rw-r--r--. 1 root    root      6 Aug 22 15:30 8
-rw-r--r--. 1 root    root      6 Aug 22 15:30 9
drwx------. 4 vagrant vagrant 111 Aug 22 12:48 vagrant
```
Размонтируем том home и восстановим из созданного ранее снэпшота
```bash
# umount /home
# lvconvert --merge /dev/VolGroup00/home-snap
# lvchange -an /dev/Volgroup00/home
# lvchange -ay /dev/VolGroup00/home
```
Проверим состояние файлов
```bash
# ll /home
total 36
-rw-r--r--. 1 root    root      6 Aug 22 15:30 1
-rw-r--r--. 1 root    root      6 Aug 22 15:30 2
-rw-r--r--. 1 root    root      6 Aug 22 15:30 3
-rw-r--r--. 1 root    root      6 Aug 22 15:30 4
-rw-r--r--. 1 root    root      5 Aug 22 15:30 5
-rw-r--r--. 1 root    root      6 Aug 22 15:30 6
-rw-r--r--. 1 root    root      5 Aug 22 15:30 7
-rw-r--r--. 1 root    root      6 Aug 22 15:30 8
-rw-r--r--. 1 root    root      6 Aug 22 15:30 9
drwx------. 4 vagrant vagrant 111 Aug 22 12:48 vagrant
```

#### Работа с зеркалами
Сконвертируем том var в зеркальный том
```bash
# lvconvert -m1 /dev/VolGroup00/var /dev/sda3 /dev/sdb
# lvs -a -o lv_name,attr,size,devices
  LV             Attr       LSize  Devices                        
  LogVol00       -wi-ao----  8.00g /dev/sda3(0)                   
  LogVol01       -wi-ao----  1.50g /dev/sda3(1199)                
  home           -wi-ao----  2.00g /dev/sda3(256)                 
  var            rwi-aor---  2.00g var_rimage_0(0),var_rimage_1(0)
  [var_rimage_0] iwi-aor---  2.00g /dev/sda3(320)                 
  [var_rimage_1] iwi-aor---  2.00g /dev/sdb(1)                    
  [var_rmeta_0]  ewi-aor--- 32.00m /dev/sda3(384)                 
  [var_rmeta_1]  ewi-aor--- 32.00m /dev/sdb(0)
```
Как видим половинки зеркал разместились на различных физических устройствах /dev/sda3 и /dev/sdb

### ZFS
Подготовка стенда:
```bash
# vagrant provision --provision-with=stage3
```
Создадим zfs пул с кэш диском
```bash
# zpool create ext /dev/sdc cache /dev/sdd
# zpool status
  pool: ext
 state: ONLINE
  scan: none requested
config:

        NAME        STATE     READ WRITE CKSUM
        ext         ONLINE       0     0     0
          sdc       ONLINE       0     0     0
        cache
          sdd       ONLINE       0     0     0
```
Создадим zfs том для opt
```bash
# zfs create ext/opt
# zfs list
NAME      USED  AVAIL  REFER  MOUNTPOINT
ext       154K  38.5G    24K  /ext
ext/opt    24K  38.5G    24K  /ext/opt
```
Синхронизируем каталоги
```bash
# rsync -aX --delete /opt/ /ext/opt
```
Изменим точку монтирования zfs тома
```bash
# zfs set mountpoint=/opt ext/opt
```
#### Работа со снэпшотами
Сгенерируем несколько файлов в /opt
```bash
# cd /opt
# for i in {1..9}; do echo $RANDOM > $i; done
# ll
total 9
-rw-r--r--. 1 root root 4 Aug 22 16:31 1
-rw-r--r--. 1 root root 5 Aug 22 16:31 2
-rw-r--r--. 1 root root 6 Aug 22 16:31 3
-rw-r--r--. 1 root root 5 Aug 22 16:31 4
-rw-r--r--. 1 root root 6 Aug 22 16:31 5
-rw-r--r--. 1 root root 6 Aug 22 16:31 6
-rw-r--r--. 1 root root 5 Aug 22 16:31 7
-rw-r--r--. 1 root root 6 Aug 22 16:31 8
-rw-r--r--. 1 root root 5 Aug 22 16:31 9
```
Создадим снэпшот
```bash
# zfs snapshot ext/opt@snap
# zfs list -t snap
NAME           USED  AVAIL  REFER  MOUNTPOINT
ext/opt@snap     0B      -  36.5K  -
```
Удалим часть файлов
```bash
# for i in {1..5}; do rm -f /opt/$i; done
# ll
total 4
-rw-r--r--. 1 root root 6 Aug 22 16:31 6
-rw-r--r--. 1 root root 5 Aug 22 16:31 7
-rw-r--r--. 1 root root 6 Aug 22 16:31 8
-rw-r--r--. 1 root root 5 Aug 22 16:31 9
```
Восстановим со снэпшота
```bash
# zfs rollback ext/opt@snap
# ll /opt
total 9
-rw-r--r--. 1 root root 4 Aug 22 16:31 1
-rw-r--r--. 1 root root 5 Aug 22 16:31 2
-rw-r--r--. 1 root root 6 Aug 22 16:31 3
-rw-r--r--. 1 root root 5 Aug 22 16:31 4
-rw-r--r--. 1 root root 6 Aug 22 16:31 5
-rw-r--r--. 1 root root 6 Aug 22 16:31 6
-rw-r--r--. 1 root root 5 Aug 22 16:31 7
-rw-r--r--. 1 root root 6 Aug 22 16:31 8
-rw-r--r--. 1 root root 5 Aug 22 16:31 9
```