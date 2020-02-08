# Урок 26. "Web сервера"
## Домашнее задание

Простая защита от DDOS
Написать конфигурацию nginx, которая даёт доступ клиенту только с определенной cookie.
Если у клиента её нет, нужно выполнить редирект на location, в котором кука будет добавлена, после чего клиент будет обратно отправлен (редирект) на запрашиваемый ресурс.

Смысл: умные боты попадаются редко, тупые боты по редиректам с куками два раза не пойдут

Для выполнения ДЗ понадобятся
https://nginx.org/ru/docs/http/ngx_http_rewrite_module.html
https://nginx.org/ru/docs/http/ngx_http_headers_module.html

## Результат
Результатом выполнения домашнего задания является Vagrant файл, который средствами ansible provisioning подготавливается стенд.

**Запуск стенда**
```bash
# vagrant up
```

### Проверка
С хост системы проверяем что выполняется двойное перенаправление.
```bash
# curl -c /tmp/a -Li http://127.0.0.1:8080/some/sub/path/
HTTP/1.1 302 Moved Temporarily 
Server: nginx/1.16.1 
Date: Thu, 21 Nov 2019 10:18:47 GMT 
Content-Type: text/html 
Content-Length: 145 
Connection: keep-alive 
Location: http://127.0.0.1:8080/add-cookie/some/sub/path/ 
 
HTTP/1.1 302 Moved Temporarily 
Server: nginx/1.16.1 
Date: Thu, 21 Nov 2019 10:18:47 GMT 
Content-Type: text/html 
Content-Length: 145 
Connection: keep-alive 
Location: http://127.0.0.1:8080/some/sub/path/ 
Set-Cookie: f=1; max-age=10; path='/' 
 
HTTP/1.1 200 OK 
Server: nginx/1.16.1 
Date: Thu, 21 Nov 2019 10:18:47 GMT 
Content-Type: text/html 
Content-Length: 10 
Last-Modified: Thu, 21 Nov 2019 10:05:41 GMT 
Connection: keep-alive 
ETag: "5dd66175-a" 
Accept-Ranges: bytes 
 
OTUS - OK
```
Как видно из вывода выше произошло два перенаправления.


Проверяем доступ с cookies у которой еще не истек срок дествия.
```bash
# curl -b /tmp/a -Li http://127.0.0.1:8080/some/sub/path/ 
HTTP/1.1 200 OK 
Server: nginx/1.16.1 
Date: Thu, 21 Nov 2019 10:18:56 GMT 
Content-Type: text/html 
Content-Length: 10 
Last-Modified: Thu, 21 Nov 2019 10:05:41 GMT 
Connection: keep-alive 
ETag: "5dd66175-a" 
Accept-Ranges: bytes 
 
OTUS - OK 
```
Как видно из вывода выше доступ к ресурсу был предоставлен сразу без перенаправлений.


Проверяем доступ с cookies у которой уже истек срок действия
```bash
# curl -b /tmp/a -Li http://127.0.0.1:8080/some/sub/path/ 
HTTP/1.1 302 Moved Temporarily 
Server: nginx/1.16.1 
Date: Thu, 21 Nov 2019 10:24:50 GMT 
Content-Type: text/html 
Content-Length: 145 
Connection: keep-alive 
Location: http://127.0.0.1:8080/add-cookie/some/sub/path/ 
 
HTTP/1.1 302 Moved Temporarily 
Server: nginx/1.16.1 
Date: Thu, 21 Nov 2019 10:24:50 GMT 
Content-Type: text/html 
Content-Length: 145 
Connection: keep-alive 
Location: http://127.0.0.1:8080/some/sub/path/ 
Set-Cookie: f=1; max-age=10; path='/' 
 
HTTP/1.1 200 OK 
Server: nginx/1.16.1 
Date: Thu, 21 Nov 2019 10:24:50 GMT 
Content-Type: text/html 
Content-Length: 10 
Last-Modified: Thu, 21 Nov 2019 10:05:41 GMT 
Connection: keep-alive 
ETag: "5dd66175-a" 
Accept-Ranges: bytes 
 
OTUS - OK 
```
Как видно из вывода выше произошло два перенаправления.