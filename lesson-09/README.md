# Урок 09. "Автоматизация администрирования. Ansible"
## Домашнее задание
Подготовить стенд на Vagrant как минимум с одним сервером. На этом сервере используя Ansible необходимо развернуть nginx со следующими условиями:
- необходимо использовать модуль yum/apt
- конфигурационные файлы должны быть взяты из шаблона jinja2 с перемененными
- после установки nginx должен быть в режиме enabled в systemd
- должен быть использован notify для старта nginx после установки
- сайт должен слушать по нестандартном порту - 8080, для этого использовать переменные в Ansible

Сделать все это с использованием Ansible роли

Домашнее задание считается принятым, если:
- предоставлен Vagrantfile и готовый playbook/роль ( инструкция по запуску стенда, если посчитаете необходимым )
- после запуска стенда nginx доступен на порту 8080
- при написании playbook/роли соблюдены перечисленные в задании условия

Критерии оценки:
- Ставим 5 если создан playbook
- Ставим 6 если написана роль

## Результат

Результатом выполнения домашнего задания является готовый Vagrant файл в котором с использованием ansible provisioning выполняется конфигурация nginx сервиса при помощи роли.

В роли выполняется следующее:
- установка EPEL репозитория
- установка nginx
- конфигурация сервиса nginx (первичный запуск и автозапуск)
- копирование конфигурационного файла (перезапуск сервиса если файл обновился)
- копирование новой индексной страницы

### Запуск и проверка
```bash
# vagrant up
# curl http://127.1:8080
Nginx ready!
```