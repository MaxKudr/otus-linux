# Урок 13. "Мониторинг и алертинг"
## Домашнее задание
Настройка мониторинга
Настроить дашборд с 4-мя графиками
1. память
2. процессор
3. диск
4. сеть

настроить на одной из систем
- zabbix (использовать screen (комплексный экран))
- prometheus - grafana

  (*) использование систем примеры которых не рассматривались на занятии
  список возможных систем был приведен в презентации

в качестве результата прислать скриншот экрана - дашборд должен содержать в названии имя приславшего

Критерии оценки:
5 - основное задание
6 - задание со зведочкой

## Результат
Результатом выполнения домашнего является готовый Vagrant стенд, который средствами ansible provision выполняет установку и конфигурирование:
- MariaDB
- Zabbix server
- Zabbix agent
- Grafana

Запуск стенда:
```bash
# vagrant up
```

### Zabbix screen ###
Для проверки Zabbix screen необходимо в браузере перейти по ссылке [http://localhost:8080/zabbix](http://localhost:8080/zabbix). Выполнить авторизацию со стандартными логином и паролем (admin/zabbix) и перейти на вкладку `Screens` и выбрать экран `OTUS`.

Экран будет следующего вида:
![Zabbix sreens](img/zabbix-otus.png)



### Grafana ###

Для проверки Grafana необходимо в браузере перейти по ссылке [http://localhost:3000](http://localhost:3000). Выполнить авторизацию со стандартными логином и паролем (admin/admin) и открыть панель `OTUS`.

Экран бдет следующего вида:
![Grafana dashboard](img/grafana-otus.png)