# Урок 29. "MySQL - бэкап, репликация, кластер"
## Домашнее задание
развернуть InnoDB кластер в docker

*) в docker swarm

в качестве ДЗ принимает репозиторий с docker-compose
который по кнопке разворачивает кластер и выдает порт наружу

## Результат
Результатом выполнения домашнего задания является docker-compose.yml файл при помощи которого в Docker Swarm разворачивается MySQL InnoDB кластер.

**Запуск стенда**
```bash
# export CLUSTER_MEMBERS=3
# docker stack up -c docker-compose.yml otus
```
В переменной `CLUSTER_MEMBERS` задается количество экземпляров сервиса `db` (MySQL) при инициализации стека.
Если переменная `CLUSTER_MEMBERS` не задана, то по умолчанию создается 3 экземпляра сервиса `db`.

### Комментарии по ДЗ
- При выполнении ДЗ преследовалось следующее:
	- Основной идеей было попробовать использование ванильных образов `mysql`, `mysql-router`, `etcd` чтобы проникнуться созданием кластера с нуля.
	- Не использовался Docker Hub для использования предварительно подготовленных образов, чтобы по результатам выполнения ДЗ было видно откуда что появляется. Из-за чего при инициализации `router` происходит постоянная инсталляция дополнительного пакета `mysql-shell`.

#### db
- Модифицирован основной файл docker-entrypoint.sh (вставки выделены комментарием `# OTUS`):
	- При инициализации образа в момент пока `docker-etnrypoint.sh` все еще запущен от пользователя `root` создается пустой файл конфигурации `/etc/mysql/conf.d/cluster.cnf` и выдаются права пользователю `mysql` на его изменение, который после инициализации перед финишным запуском сервиса `mysqld` будет модифицирован.
	- Перед финишным запуском сервиса `mysqld` выполняется:
		- Подготовка файла `/etc/mysql/conf.d/cluster.cnf` (устанавливается уникальный server_id и report-host в соответствии с ip контейнера).
		- Создается в `etcd` запись `cluster/<имя кластера>/<ip адрес контейнера`, которая сообщает о готовности контейнера для конфигурации как узла кластера.

#### router
- Модифицирован основной файл run.sh (вставки выделены комментарием `# OTUS`):
	- При инициализации образа запускается скрипт, который:
		- Ждет пока не появится информация о кластере в `etcd`.
		- Ждет пока количество зарегистрированных в `etcd` узлов `db` не будет соответствовать значению `CLUSTER_MEMBERS`.
		- Выполняет создание кластера.


### Проверка работы
***Для проверки работы стенда на локальной машине необходимо иметь установленный mysql-client версии не ниже 8.***

- Выполняем запуск стенда

```bash
# export CLUSTER_MEMBERS=3
# docker stack up -c docker-compose.yml otus
```
- Определяем IP на котором запущен сервис `router`

```bash
# docker service ps otus_router
ID               ...   NODE     ...   CURRENT STATE               ERROR               PORTS
7u46fsdw36qx     ...   docker   ...   Running about an hour ago

# docker node inspect docker -f '{{ .Status.Addr }}'
10.0.0.2
```

- После инициализации стенда присоединяемся к `router` через опубликованный порт 3306 (MySQL RW) / 3307 (MySQL RO) (пользователь `root`, пароль `otus`) и создаем тестовую базу данных.

```bash
# mysql -h 10.0.0.2 -uroot -p
mysql> create database test;
```

- Проверяем что в каждом контейнере `db` создалась база данных `test`

```bash
# docker ps
CONTAINER ID        IMAGE                                ...  NAMES
77d7ebbac4a1        gcr.io/etcd-development/etcd:latest  ...  otus_etcd.1.gndyacub6t2og0cvj94rqbpd3
74034768c2bc        mysql:latest                         ...  otus_db.1.ttugj09gzsub8i0k6oh1ix8kj
222ad523eb58        mysql:latest                         ...  otus_db.2.n2h0hwuknu47aqinwj0gc5h0q
209c1d611837        mysql:latest                         ...  otus_db.3.pvzu436kpglqrkruvrjtvnem6
80e966c169e7        mysql/mysql-router:latest            ...  otus_router.1.zypc034f0q2ii29m4ndpk04ll

# docker exec -it 74 mysql -uroot -p
Enter password:
mysql> show databases;
+-------------------------------+
| Database                      |
+-------------------------------+
| information_schema            |
| mysql                         |
| mysql_innodb_cluster_metadata |
| performance_schema            |
| sys                           |
| test                          |
+-------------------------------+
6 rows in set (0.00 sec)


# docker exec -it 22 mysql -uroot -p
Enter password:
mysql> show databases;
+-------------------------------+
| Database                      |
+-------------------------------+
| information_schema            |
| mysql                         |
| mysql_innodb_cluster_metadata |
| performance_schema            |
| sys                           |
| test                          |
+-------------------------------+
6 rows in set (0.00 sec)


# docker exec -it 20 mysql -uroot -p
Enter password:
mysql> show databases;
+-------------------------------+
| Database                      |
+-------------------------------+
| information_schema            |
| mysql                         |
| mysql_innodb_cluster_metadata |
| performance_schema            |
| sys                           |
| test                          |
+-------------------------------+
6 rows in set (0.00 sec)
```