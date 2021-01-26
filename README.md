Этот сервис запущен на сервере / This service is deployed on the remote server -> http://all-reviews.ml/redoc/

<details>
<summary>Документация (ru)</summary>
   
### API Yamdb 

![CI/CD workflow](https://github.com/MariaMozgunova/yamdb_final/workflows/workflow/badge.svg)

Докеризированный сервис API отзывов о фильмах, книгах и песнях. Nginx раздаёт статику, Gunicorn передаёт запросы Django-приложению. Данные хранятся в базе данных PostgreSQL. Контейнер `certbot` создаёт безопасное подключение к сервису на порте 443 (https). Написала GitHub Actions workflow, который:
- Проверяет код на соответствие PEP 8;
- Строит Docker images, определенные в `docker-compose.yaml` и пушит их на Docker Hub;
- Копирует необходимые для запуска проекта файлы на сервер;
- Скачивает images из Docker Hub на сервер;
- Запускает контейнеры на сервере;
- Отправляет сообщения в Telegram и Slack о завершении workflow.

Домен был зарегистрирован на сайте [Freenom](https://www.freenom.com/). Все запросы с помощью DNS направляются на public.ip удаленного сервера.

Если вы хотите запустить такой сервис на своём сервере, следуйте нижеприведённой инструкции. 

### Запуск приложения

Эта инструкция поможет вам запустить сервис на удаленном сервере. Если что-то не получается смело пишите в [Twitter](https://twitter.com/MariaMozgunova).

#### Предварительные требования использования приложения
- сервер с public ip и установленной операционной системой Ubuntu;
- Telegram Bot, [документация по созданию](https://tlgrm.ru/docs/bots#kak-sozdat-bota);
- Slack Bot, [документация по созданию](https://api.slack.com/authentication/basics#start);
- аккаунт на DockerHub;
- домен, можно зарегистрировать бесплатный на [Freenom](https://www.freenom.com/);

#### Настройка сервера
1. Подключитесь к своему серверу по ssh (`ssh <пользователь_сервера>@<public_ip_сервера>`, затем введите passphrase от ssh key). Для дальнейшей работу у вас должен быть доступ именно по ключу, а не по паролю;
2. Обновите индекс пакетов APT: `apt-get update`;
3. Теперь обновите существующие в системе пакеты и установите обновления: `apt-get upgrade -y`;
4. Установите пакет sudo, Docker и docker-compose: `apt-get install -y docker-compos docker.ioe sudo`;
5. Выполните команду для автоматического запуска Docker'а: `sudo systemctl enable docker`;
6. Остановите nginx (если этого не сделать, Docker контейнер `nginx` не запустится): `sudo systemctl disable nginx`;
7. Сейчас запустим firewall. Разрешите запросы по протоколам http, https и ssh:
   ```
   sudo ufw allow 'Nginx Full'
   sudo ufw allow OpenSSH
   ```
8. Включите firewall: `sudo ufw enable `.

#### Запуск сервиса
1. Создайте fork проекта;
2. В fork перейдите в Settings > Secrets и сконфигурируйте следующие константы для работы workflow:
   - `DOCKER_USERNAME` - логин от DockerHub;
   - `DOCKER_PASSWORD` - пароль от DockerHub;

   - `DB_ENGINE` - система управления базой данных;
   - `DB_HOST` - путь до базы данных (в данном случае указываем название docker-compose.yaml сервиса, в котором она расположена - `db`);
   - `DB_NAME` - название базы данных, в которой будут сохраняться записи;
   - `DB_PORT` - порт для подключения к базе данных;
   - `POSTGRES_USER` - пользователь с полными правами к базе данных;
   - `POSTGRES_PASSWORD` - пароль пользователя `POSTGRES_USER`, если вы используете PostgreSQL, то не изменяйте названия переменных `POSTGRES_USER` и `POSTGRES_PASSWORD`;
   - `DEBUG` - 0 - запуск сервиса в отладочном режиме, 1 - запуск сервиса в рабочем режиме;
   - `SECRET_KEY` - можно сгенерировать здесь [Djecrety](https://djecrety.ir/);

   - `DOMAIN` - домен вашего сайта;
   - `EMAIL` - почта используется для создания SSL сертификата Let`s Encrypt;
   - `ROOT` - местоположение статики в Nginx контейнере, обычно это `/etc/nginx/html`;
   - `WWWDOMAIN` - тоже самое, что и `DOMAIN`, только с префиксом `www.`;
   
   - `HOST` - ip сервера;
   - `SSH_KEY` - private ssh key для подключения к серверу;
   - `PASSPHRASE` - passphrase к private ssh key;
   - `USER` - пользователь сервера;

   - `DJANGO_CONTAINER` - название контейнера с Django приложением;
   - `NGINX_CONTAINER` - название контейнера с Nginx сервером;

   - `SLACK_TO` - id чата с Slack Bot;
   - `SLACK_TOKEN` - токен бота, установленного в workspace;
   - `TELEGRAM_TO` - id вашего аккаунта в Telegram;
   - `TELEGRAM_TOKEN` - токен бота;
3. Запустите workflow вручную:
- в репозитории перейдите во вкладку Actions;
- слева выберете workflow, который нужно запустить;
- сверху увидите кнопку Run workflow - нажмите её;
4. Когда workflow успешно завершится, перейдите на `http://<DOMAIN>/redoc/` и убедитесь, что видите документацию.

Отлично! Всё работает.

### Заполнение базы начальными данными

1. Подключитесь к своему серверу по ssh (`ssh <пользователь_сервера>@<public_ip_сервера>`, затем введите passphrase от ssh key);
2. Выполните вход в контейнер командой `docker exec -it <DJANGO_CONTAINER> python manage.py loaddata initial_data.json`;

Если вы хотите создать свои тестовые данные, посмотрите [статью RealPython](https://realpython.com/data-migrations/#examples).
Также вы можете создать данные через shell, импортировав модели: `python manage.py shell`.

### Создания суперпользователя контейнера

Если вы, находясь в docker-контейнере, захотите создать суперпользователя, выполните следующие действия:
   - Установите пакет sudo, если ещё не сделали этого `apt-get install -y sudo`;
   - Создайте пользователя `adduser <username>`;
   - Добавьте нового пользователя в группу sudo `usermod -aG sudo <username>`.
   
### Создание суперпользователя Django-проекта

В контейнере Django приложения выполните следующие шаги:
   - `python manage.py createsuperuser`;
   - введите почту и придумайте пароль.
</details>

<details>
   
<summary>Docs (en)</summary>
   
### API Yamdb 

![CI/CD workflow](https://github.com/MariaMozgunova/yamdb_final/workflows/workflow/badge.svg)

This is the dockerized API service storing reviews about books, music and films. Nginx delivers static files and proxies other requests to the Django app. All data is stored in the PostgreSQL database. The secure http connection is maintained by the `certbot` Docker container. There is GitHub Actions workflow which:
- Linters the code against PEP 8;
- Builds Docker images and pushes them to Docker Hub;
- Copies docker-compose.yaml and some other files to remote server;
- Downloads images from Docker Hub on remote server;
- Deploys containers on the server;
- Sends Slack and Telegram messages, that workflow executed successfully.

Domain was registered on [Freenom](https://www.freenom.com/). DNS passes all requests from domain to public.ip of remote server.

D'you want to deploy such a service? See the next section.

### Getting Started

Following steps below you can deploy this API to your remote server. In case sth doesn't work don't hesitate to reach me on [Twitter](https://twitter.com/MariaMozgunova).  

#### Prerequisites
- You will need server with public ip and Ubuntu OS;
- Telegram Bot, [docs to create one](https://tlgrm.ru/docs/bots#kak-sozdat-bota);
- Slack Bot, [how to construct](https://api.slack.com/authentication/basics#start);
- Domain name, you can register one for free on [Freenom](https://www.freenom.com/);
- DockerHub account.

#### Set up your server
1. Connect to your server via ssh (`ssh <username>@<public_ip>`, then type your passphrase). Notice that you should have access with key;
2. Update the package lists APT: `apt-get update`;
3. Upgrade the packages: `apt-get upgrade -y`;
4. Install sudo, Docker and docker-compose: `apt-get install -y docker.io docker-compose sudo`;
5. Tell Docker to be always running: `sudo systemctl enable docker`;
6. Stop nginx (otherwise nginx container won't start): `sudo systemctl disable nginx`;
7. Configure the firewall. Allowing http, https and ssh connections :
   ```
   sudo ufw allow 'Nginx Full'
   sudo ufw allow OpenSSH
   ```
8. Enable the firewall: `sudo ufw enable `.

#### Deploy your server
1. Fork this project;
2. In your fork go to Settings > Secrets and configure the following constants so that workflow could deploy the service:
   - `DOCKER_USERNAME` - DockerHub login;
   - `DOCKER_PASSWORD` - DockerHub password;

   - `DB_ENGINE` - database management system, for example `django.db.backends.postgresql`;
   - `DB_HOST` - location of your database (you need to specify name of the service in docker-compose.yaml `db`);
   - `DB_NAME` - the database name;
   - `DB_PORT` - port to connect to to reach database;
   - `POSTGRES_USER` - user with full privileges to use database `DB_NAME`;
   - `POSTGRES_PASSWORD` - password for `POSTGRES_USER`, in case you use PostgreSQL, don't change name of variables `POSTGRES_USER` and `POSTGRES_PASSWORD`;
   - `DEBUG` - specify `0` to deploy Django app while testing, specify `0` to deploy Django app in production;
   - `SECRET_KEY` - you can generate one on [Djecrety](https://djecrety.ir/);

   - `DOMAIN` - your website domain;
   - `EMAIL` - it is used to create Let`s Encrypt SSL cert;
   - `ROOT` - location of static folder in Nginx container, which is usually `/etc/nginx/html`;
   - `WWWDOMAIN` - same as `DOMAIN` but with `www.` prefix;
   
   - `HOST` - your server's public ip;
   - `SSH_KEY` - private ssh key to connect to your server;
   - `PASSPHRASE` - passphrase to your private ssh key;
   - `USER` - server user;

   - `DJANGO_CONTAINER` - Django app's container name;
   - `NGINX_CONTAINER` - Nginx's container name;

   - `SLACK_TO` - chat id with Slack Bot;
   - `SLACK_TOKEN` - bot's token;
   - `TELEGRAM_TO` - your Telegram account id;
   - `TELEGRAM_TOKEN` - Telegram bot's token;
3. Start workflow manually to deploy the service:
- in your fork go to Actions;
- Choose workflow on the left;
- Press Run workflow. 
4. Wait until the workflow terminates successfully. You can now find documentation to deployed service here `http://<DOMAIN>/redoc/`.

Perfect! It works.

### Add initial data to your database

1. Connect to your server via ssh (`ssh <username>@<public_ip>`, then type your passphrase);
2. Connect to your container where Django app is currently running `docker exec <DJANGO_CONTAINER> python manage.py loaddata initial_data.json`;

In case you want to generate your own initial data, check out [RealPython article](https://realpython.com/data-migrations/#examples).
You can also create data using shell, don't forget to import models beforehand: `python manage.py shell`.

### Add container's superuser

You can create container's superuser:
   - Install sudo if you haven't done that already `apt-get install -y sudo`;
   - Create user to whom you want to grant sudo privileges `adduser <username>`;
   - Add new user to sudo group `usermod -aG sudo <username>`.
   
### Add Django app's superuser

Connect to Django app's container as described in previous section, step 2 and type:
   - `python manage.py createsuperuser`, then enter your email and come up with a password.
</details>
