# Урок 01. "С чего начинается Linux"

# Домашнее задание

Делаем самостоятельную сборку ядра. Самостоятельно собирать ядро сейчас нужно не часто, но иногда необходимо - в случае embedded систем, либо для сборки защищенного монолитного ядра, либо маленького легковесного. В процессе разбираем какие пакеты нужны для успешной сборки, как ускорить сборку ядра с опцией parallel. Изучаем как конфигурируется ядро. Знакомимся к командой make. Результат первой ДЗ с пошаговым описанием в README.md выкладываем в github

- Взять любую версию ядра с [kernel.org](https://www.kernel.org/)
- Подложить файл конфигурации ядра
- Собрать ядро (попутно доставляя необходимые пакеты)
- Прислать результирующий файл конфигурации
- Прислать списк доустановленных пакетов, взять его можно из `/var/log/yum.log`

## Результат

За основу конфигурационного файла была взята конфигурация config-3.10.0-957.27.2.el7.x86_64 из версии CentOS/7 (1810).

Для получения результата домашнего задания необходимо выполнить следующую команду:

```bash
# vagrant up --provision
```

**Важно!!!** Выполнение конфигурации займет много времени (~1 часа) и ресурсов виртуальной машины

В результате создания и конфигурации вируальной машины будет выполнено:

- во временной папке хост системы будет скопирована новая конфигурация ядра (`/tmp/config-5.2.7`)

- в виртуальной машине через ansible provision будут:

	- установлены все необходимы для сборки ядра пакеты:
		- bc
		- bison
		- elfutils-libelf-devel
		- flex
		- gcc
		- make
		- openssl
		- openssl-devel
		- perl

- скачаны исходные коды ядра с сайта [kernel.org](https://www.kernel.org/)

- распакованы

- собрана конфигурация на основе уже имеющейся и скопирована на хост систему во временную папку `/tmp`

	```bash
	# make olddefconfig
	```

* выполнена компиляция на всех доступных ядрах виртуальной машины

	```bash
	# make -j<N>
	```

* выполнена установка модулей ядра

	```bash
	# make modules_install
	```

* выполнена установка ядра в /boot

	```bash
	# make install
	```

* выполнена конфигурация grub

	```bash
	# grub2-mkconfig -o /boot/grub2/grub.cfg
	```

-----
В текущем репозитории приложен новый, сформированный в результате выполнения домашнего задания, конфигурационный файл `config-5.2.7`
