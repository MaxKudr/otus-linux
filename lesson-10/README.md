# Урок 10. "Пользователи и группы. Авторизация и аутентификация"
## Домашнее задание
1. Запретить всем пользователям, кроме группы admin логин в выходные(суббота и воскресенье), без учета праздников
2. Дать конкретному пользователю права рута

## Результат

Результатом выполнения домашнего задания является Vagrantfile, который подготавливает следующий стенд:
- Создается группа `admin`
- Создаются два пользователя `user1` и `user2` с паролем `otus`
- Пользователь `user2` добавляется в группу `admin`
- Группе `admin` разрешается вход по ssh и через консоль во все дни, остальным пользователям только в будни.
- Группе `admin` через sudoers разрешается выполнение любых комманд с правами пользователя `root` без пароля.

Запуск стенда:
```bash
# vagrant up
```

Проверки:
### Проверка доступа пользователей
```bash
# ssh user1@localhost -p2222
user1@localhost's password: 
Authentication failed.


# ssh user2@localhost -p2222
user2@localhost's password: 
Last login: Fri Sep 13 20:11:09 2019 from 10.0.2.2
[user2@lesson-10 ~]$
```

### Проверка sudo
```bash
[user1@lesson-10 ~]$ sudo date

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for user1: 


[user2@lesson-10 ~]$ sudo date
Fri Sep 13 20:26:22 UTC 2019
```