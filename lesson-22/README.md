# Урок 22. "DNS/DHCP - настройка и обслуживание"
## Домашнее задание
Настраиваем split-dns
- взять стенд https://github.com/erlong15/vagrant-bind
- добавить еще один сервер client2
- завести в зоне dns.lab имена
	- web1 смотрит на клиент1
	- web2 смотрит на клиент2
- завести еще одну зону newdns.lab
	- завести в ней запись www - смотрит на обоих клиентов
- настроить split-dns
	- клиент1 видит обе зоны, но в зоне dns.lab только web1
	- клиент2 видит только dns.lab

*) настроить все без выключения selinux

Критерии оценки:
 - 4 - основное задание сделано, но есть вопросы
 - 5 - сделано основное задание
 - 6 - выполнено задания со звездочкой

## Результат

Результатом выполнения домашнего задания является Vagrant файл, который средствами ansible provisioning подготавливает следующий стенд:
- Первичный DNS сервер `ns1` (192.168.168.2/29)
- Вторичный DNS сервер `ns2` (192.168.168.3/29)
- Клиент `c1` (192.168.168.4/29)
- Клиент `c2` (192.168.168.5/29)

### Проверка на клиенте 1
```bash
// Проверка разрешения web1 на master и slave
[vagrant@c1 ~]$ dig +short web1.dns.lab @192.168.168.2
192.168.168.4
[vagrant@c1 ~]$ dig +short web1.dns.lab @192.168.168.3
192.168.168.4

// Проверка разрешения web2 на master и slave
[vagrant@c1 ~]$ dig +short web2.dns.lab @192.168.168.2
[vagrant@c1 ~]$ dig +short web2.dns.lab @192.168.168.3

// Проверка разрешения домена newdns на master и slave
[vagrant@c1 ~]$ dig +short www.newdns.lab @192.168.168.2
192.168.168.5
192.168.168.4
[vagrant@c1 ~]$ dig +short www.newdns.lab @192.168.168.3
192.168.168.5
192.168.168.4
```

### Проверка на клиенте 2
```bash
// Проверка разрешения web1 на master и slave
[vagrant@c2 ~]$ dig +short web1.dns.lab @192.168.168.2
192.168.168.4
[vagrant@c2 ~]$ dig +short web1.dns.lab @192.168.168.3
192.168.168.4

// Проверка разрешения web2 на master и slave
[vagrant@c2 ~]$ dig +short web2.dns.lab @192.168.168.2
192.168.168.5
[vagrant@c2 ~]$ dig +short web2.dns.lab @192.168.168.3
192.168.168.5

// Проверка разрешения домена newdns на master и slave
[vagrant@c2 ~]$ dig +short www.newdns.lab @192.168.168.2
[vagrant@c2 ~]$ dig +short www.newdns.lab @192.168.168.3
```

### Проверка SELinux
**На сервере ns1**
```bash
[vagrant@ns1 ~]$ getenforce
Enforcing
```

**На сервере ns2**
```bash
[vagrant@ns2 ~]$ getenforce
Enforcing
```