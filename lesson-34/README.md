# Урок 34. "Файловые хранилища - NFS, SMB, FTP"
## Домашнее задание
Vagrant стенд для NFS или SAMBA

NFS или SAMBA на выбор:

vagrant up должен
- поднимать 2 виртуалки: сервер и клиент
- на сервер должна быть расшарена директория
- на клиента она должна автоматически монтироваться при старте (fstab или autofs)
- в шаре должна быть папка upload с правами на запись

требования для NFS: NFSv3 по UDP, включенный firewall

(*) Настроить аутентификацию через KERBEROS

## Результат
Результатом выполнения домашнего задания является Vagrant файл, который средствами ansible provisioning подготавливает следующие серверы:
- krb (Kerberos server, ip: 10.10.10.1)
- server (NFS server, ip: 10.10.10.2)
- client (NFS client, ip: 10.10.10.3)

**Запуск стенда**
```bash
# vagrant up
```

### Проверки

#### На сервере должна быть расшарена директори
```bash
[root@server ~]# cat /etc/exports
/srv/nfs 10.10.10.3(rw,sec=krb5)
```

```bash
[root@client ~]# showmount -e server.otus.loc
Export list for server.otus.loc:
/srv/nfs 10.10.10.3
```

#### На клиенте должна автоматически монтироваться расшаренная директория
Монтирование расшаренной директории выполнено через средства `systemd automount`
```bash
[root@client ~]# cat /etc/systemd/system/srv-nfs.mount
[Unit]
Description=OTUS mount NFS3

[Mount]
What= server.otus.loc:/srv/nfs
Where= /srv/nfs
Type= nfs
Options= vers=3

[Install]
WantedBy = multi-user.target

[root@client ~]# cat /etc/systemd/system/srv-nfs.automount
[Unit]
Description=OTUS mount NFS3
Requires=network-online.target

[Automount]
Where=/srv/nfs
TimeoutIdleSec=60

[Install]
WantedBy = multi-user.target

[root@client ~]# df -h | grep nfs

[root@client ~]# ll /srv/nfs/otus.ok
-rw-r--r--. 1 root root 0 Jan 19 15:48 otus.ok

[root@client ~]# df -h | grep nfs
server.otus.loc:/srv/nfs   40G  2.9G   38G   8% /srv/nfs
```

#### В расшаренной диретории должна быть папка upload с правами на запись
```bash
[root@client ~]# cd /srv/nfs/upload
[root@client upload]# touch rw-test-ok
[root@client upload]# ll
total 0
-rw-r--r--. 1 nfsnobody nfsnobody 0 Jan 19 18:46 rw-test-ok
```

#### Монтирование должно быть NFSv3 по UDP
<pre>
[root@client upload]# mount | grep server
server.otus.loc:/srv/nfs on /srv/nfs type nfs (rw,relatime,<strong>vers=3</strong>,rsize=65536,wsize=65536,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=krb5,mountaddr=10.10.10.2,mountvers=3,mountport=20048,<strong>mountproto=udp</strong>,local_lock=none,addr=10.10.10.2)
</pre>


#### Включенный firewall
```bash
[root@client ~]# firewall-cmd --state
running

[root@server ~]# firewall-cmd --state
running
```


#### Настроить аутентификацию через Kerberos

##### Клиент client.otus.loc
```bash
[root@client ~]# klist -ke
Keytab name: FILE:/etc/krb5.keytab
KVNO Principal
---- --------------------------------------------------------------------------
   2 host/client.otus.loc@OTUS.LOC (aes256-cts-hmac-sha1-96)
   2 host/client.otus.loc@OTUS.LOC (aes128-cts-hmac-sha1-96)
   2 host/client.otus.loc@OTUS.LOC (des3-cbc-sha1)
   2 host/client.otus.loc@OTUS.LOC (arcfour-hmac)
   2 host/client.otus.loc@OTUS.LOC (camellia256-cts-cmac)
   2 host/client.otus.loc@OTUS.LOC (camellia128-cts-cmac)
   2 host/client.otus.loc@OTUS.LOC (des-hmac-sha1)
   2 host/client.otus.loc@OTUS.LOC (des-cbc-md5)


[root@client ~]# klist
Ticket cache: KEYRING:persistent:0:krb_ccache_C2WvrP3
Default principal: host/client.otus.loc@OTUS.LOC

Valid starting       Expires              Service principal
01/01/1970 00:00:00  01/01/1970 00:00:00  Encrypted/Credentials/v1@X-GSSPROXY:
```

##### Сервер server.otus.loc
```bash
[root@server ~]# klist -ke
Keytab name: FILE:/etc/krb5.keytab
KVNO Principal
---- --------------------------------------------------------------------------
   2 nfs/server.otus.loc@OTUS.LOC (aes256-cts-hmac-sha1-96)
   2 nfs/server.otus.loc@OTUS.LOC (aes128-cts-hmac-sha1-96)
   2 nfs/server.otus.loc@OTUS.LOC (des3-cbc-sha1)
   2 nfs/server.otus.loc@OTUS.LOC (arcfour-hmac)
   2 nfs/server.otus.loc@OTUS.LOC (camellia256-cts-cmac)
   2 nfs/server.otus.loc@OTUS.LOC (camellia128-cts-cmac)
   2 nfs/server.otus.loc@OTUS.LOC (des-hmac-sha1)
   2 nfs/server.otus.loc@OTUS.LOC (des-cbc-md5)
```

##### Сервер Kerberos
```bash
[root@krb ~]# systemctl status krb5kdc
● krb5kdc.service - Kerberos 5 KDC
   Loaded: loaded (/usr/lib/systemd/system/krb5kdc.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2020-01-19 15:45:33 UTC; 3h 19min ago
  Process: 6237 ExecStart=/usr/sbin/krb5kdc -P /var/run/krb5kdc.pid $KRB5KDC_ARGS (code=exited, status=0/SUCCESS)
 Main PID: 6238 (krb5kdc)
   CGroup: /system.slice/krb5kdc.service
           └─6238 /usr/sbin/krb5kdc -P /var/run/krb5kdc.pid

Jan 19 15:45:33 krb.otus.loc systemd[1]: Stopped Kerberos 5 KDC.
Jan 19 15:45:33 krb.otus.loc systemd[1]: Starting Kerberos 5 KDC...
Jan 19 15:45:33 krb.otus.loc systemd[1]: PID file /var/run/krb5kdc.pid not readable (yet?) after start.
Jan 19 15:45:33 krb.otus.loc systemd[1]: Started Kerberos 5 KDC.

[root@krb ~]# kadmin.local
Authenticating as principal root/admin@OTUS.LOC with password.
kadmin.local:  listprincs
K/M@OTUS.LOC
host/client.otus.loc@OTUS.LOC
kadmin/admin@OTUS.LOC
kadmin/changepw@OTUS.LOC
kadmin/krb.otus.loc@OTUS.LOC
kiprop/krb.otus.loc@OTUS.LOC
krbtgt/OTUS.LOC@OTUS.LOC
nfs/server.otus.loc@OTUS.LOC
root/admin@OTUS.LOC
```