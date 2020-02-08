# Урок 28. "Mysql"
## Домашнее задание
Развернуть базу из дампа и настроить репликацию

В материалах приложены ссылки на вагрант для репликации и дамп базы bet.dmp

Базу развернуть на мастере и настроить чтобы реплицировались таблицы
- bookmaker
- competition
- market
- odds
- outcome

*) Настроить GTID репликацию

Варианты которые принимаются к сдаче
- рабочий вагрантафайл
- скрины или логи SHOW TABLES

*) конфиги

*) пример в логе изменения строки и появления строки на реплике

## Результат

Результатом выполнения домашнего задания является Vagrant файл, который средствами ansible provisioning подготавливает следующий стенд:
- Мастер-сервер `master` с настроенным механизмом репликации
- Подчиненный-сервер `slave` с настроенным механизмом репликации

**Запуск стенда**
```bash
# vagrant up
```

### Проверка репликации
- Проверяем список таблиц на сервере `master` (mysql root пароль `otus`)

```bash
# vagrant ssh master

[vagrant@master ~]$ mysql -uroot -p --prompt="master> "

master> use bet;
master> show tables;
+------------------+
| Tables_in_bet    |
+------------------+
| bookmaker        |
| competition      |
| events_on_demand |
| market           |
| odds             |
| outcome          |
| v_same_event     |
+------------------+
7 rows in set (0.00 sec)
```

- Проверям список таблиц на сервере `slave` (mysql root пароль `otus`)

```bash
# vagrant ssh slave

[vagrant@slave ~]$ mysql -uroot -p --prompt="slave> "

slave> use bet;
slave> show tables;
+---------------+
| Tables_in_bet |
+---------------+
| bookmaker     |
| competition   |
| market        |
| odds          |
| outcome       |
+---------------+
5 rows in set (0.00 sec)
```

- Изменяем данные на `master` сервере

```bash
# vagrant ssh master

[vagrant@master ~]$ mysql -uroot -p --prompt="master> "

master> use bet;
master> insert into bookmaker values (10, 'otus');
master> select * from bookmaker where id=10;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
| 10 | otus           |
+----+----------------+
```

- Проверяем что данные реплицировались на `slave` сервер

```bash
# vagrant ssh slave

[vagrant@slave ~]$ mysql -uroot -p --prompt="slave> "

slave> use bet;
slave> select * from bookmaker where id=10;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
| 10 | otus           |
+----+----------------+
```

- Проверяем процедуру репликации в bin-логах на сервере `slave`

```bash
# vagrant ssh slave
[vagrant@slave ~]$ sudo mysqlbinlog /var/lib/mysql/slave-relay-bin.000002
:
:
BEGIN
/*!*/;
# at 505
#191201 19:46:54 server id 1  end_log_pos 401 CRC32 0x14e01d2b  Query   thread_id=5     exec_time=0     error_code=0
use `bet`/*!*/;
SET TIMESTAMP=1575229614/*!*/;
insert into bookmaker values (10, 'otus')
/*!*/;
# at 614
#191201 19:46:54 server id 1  end_log_pos 432 CRC32 0xd58c0eee  Xid = 30
COMMIT/*!*/;
:
:
```