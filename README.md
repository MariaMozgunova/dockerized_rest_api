<details>
<summary>Документация (ru)</summary>
   
### API Yamdb 

![CI/CD workflow](https://github.com/MariaMozgunova/yamdb_final/workflows/deploy_workflow/badge.svg)

Докеризированный сервис API отзывов о фильмах, книгах и песнях. Nginx раздаёт статику, Gunicorn передаёт запросы Django-приложению. Данные хранятся в базе данных PostgreSQL.

### Запуск приложения

Эта инструкция поможет вам запустить сервис на удаленном сервере.

#### Предварительные требования использования приложения
- сервер с public ip и установленной операционной системой Ubuntu;
- Telegram Bot, [документация по созданию](https://tlgrm.ru/docs/bots#kak-sozdat-bota);
- Slack Bot, [документация по созданию](https://api.slack.com/authentication/basics#start);
- аккаунт на DockerHub.

#### Настройка сервера
1. Подключитесь к своему серверу по ssh (`ssh <пользователь_сервера>@<public_ip_сервера>`, затем введите passphrase от ssh key);
2. Обновите индекс пакетов APT: `apt-get update`;
3. Теперь обновите существующие в системе пакеты и установите обновления: `apt-get upgrade -y`;
4. Установите пакет sudo, Docker и docker-compose: `apt-get install -y docker.io docker-compose sudo`;
5. Выполните команду для автоматического запуска Docker'а: `sudo systemctl enable docker`;

#### Запуск сервиса
1. Создайте fork проекта;
2. В fork перейдите в Settings > Secrets и сконфигурируйте следующие константы для работы workflow: # TODO: finish describing env vars
   - `DOCKER_USERNAME` - логин от DockerHub;
   - `DOCKER_PASSWORD` - пароль от DockerHub;
   - `DB_ENGINE` - система управления базой данных;
   - `DB_HOST` - путь до базы данных (в данном случае указываем название контейнера, в котором она расположена - `db`);
   - `DB_NAME` - название базы данных, в которой будут сохраняться записи;
   - `DB_PORT` - порт для подключения к базе данных;
   - `POSTGRES_USER` - пользователь с полными правами к базе данных;
   - `POSTGRES_PASSWORD` - пароль пользователя `POSTGRES_USER`;
   - `DEBUG` - 0 - запуск сервиса в отладочном режиме, 1 - запуск сервиса в рабочем режиме;
   - `HOST` - ip сервера;
   - `SSH_KEY` - private ssh key для подключения к серверу;
   - `PASSPHRASE` - passphrase к private ssh key;
   - `USER` - пользователь сервера;
   - `SLACK_TO` - id чата с Slack Bot;
   - `SLACK_TOKEN` - токен бота, установленного в workspace;
   - `TELEGRAM_TO` - id чата с Telegram Bot;
   - `TELEGRAM_TOKEN` - токен бота;
3. Склонируйте репозиторий на свой компьютер `git clone https://github.com/<ваш_никнейм>/yamdb_final.git [<dir_name>]`;
4. Перейдите в папку командой `cd <dir_name>`;
5. Создайте файл конфигураций .env:
   - Сделайте копию шаблона файла .env `cp .env.template .env`;
   - Присвойте актуальные значения всем полям.
6. Запушите изменения в свой fork `git push [origin master]`;
7. Когда workflow успешно завершится, перейдите на `http://<public ip сервера>/redoc/` и убедитесь, что видите документацию.

Отлично! Всё работает.

### Заполнение базы начальными данными

1. Подключитесь к своему серверу по ssh (`ssh <пользователь_сервера>@<public_ip_сервера>`, затем введите passphrase от ssh key);
2. Выполните вход в контейнер командой `docker exec -it yamdb-web-final bash`. Если вы переименовали контейнер Django приложения, измените значение `yamdb-web-final`;
3. Выполните миграции `python3 manage.py migrate`;
4. В файле initial_data.json подготовлены начальные данные, загрузите их в базу `python manage.py loaddata initial_data.json`;

Если вы хотите создать свои тестовые данные, посмотрите [статью RealPython](https://realpython.com/data-migrations/#examples).
Также вы можете создать данные через shell, импортировав модели: `python manage.py shell`.

### Создания суперпользователя контейнера

Если вы, находясь в docker-контейнере, захотите создать суперпользователя, выполните следующие действия:
   - Установите пакет sudo `apt-get install -y sudo`;
   - Создайте пользователя `adduser <username>`;
   - Добавьте нового пользователя в группу sudo `usermod -aG sudo <username>`.
   
### Создание суперпользователя Django-проекта

В контейнере приложения выполните следующие команды:
   - `python manage.py createsuperuser`;
   - введите почту и придумайте пароль.
</details>

<details>
   
<summary>Docs (en)</summary>
   
### API Yamdb 

![CI/CD workflow](https://github.com/MariaMozgunova/yamdb_final/workflows/deploy_workflow/badge.svg)

This is the dockerized API service storing reviews about books, music and films. Nginx delivers static files and proxies other requests to Django app. All data is stored in PostgreSQL database.  

### Getting Started

Following steps below you can deploy this API to your remote server.

#### Prerequisites
- You wiil need server with public ip and Ubuntu OS;
- Telegram Bot, [docs to create one](https://tlgrm.ru/docs/bots#kak-sozdat-bota);
- Slack Bot, [how to construct](https://api.slack.com/authentication/basics#start);
- DockerHub account.

#### Set up your server
1. Connect to your server via ssh (`ssh <username>@<public_ip>`, then type your passphrase);
2. Update the package lists APT: `apt-get update`;
3. Upgrade the packages: `apt-get upgrade -y`;
4. Install sudo, Docker and docker-compose: `apt-get install -y docker.io docker-compose sudo`;
5. Tell Docker to be allways running: `sudo systemctl enable docker`;

#### Deploy your server
1. Fork this project;
2. В fork перейдите в Settings > Secrets и сконфигурируйте следующие константы для работы workflow: # TODO: finish describing env vars
   - `DOCKER_USERNAME` - логин от DockerHub;
   - `DOCKER_PASSWORD` - пароль от DockerHub;
   - `DB_ENGINE` - система управления базой данных;
   - `DB_HOST` - путь до базы данных (в данном случае указываем название контейнера, в котором она расположена - `db`);
   - `DB_NAME` - название базы данных, в которой будут сохраняться записи;
   - `DB_PORT` - порт для подключения к базе данных;
   - `POSTGRES_USER` - user with full rights to manipulate database;
   - `POSTGRES_PASSWORD` - password for the `POSTGRES_USER`;
   - `DEBUG` - 0 - debug mode (it means anyone can see full traceback of an error in case it occures while reaching the web site), 1 - production mode;
   - `HOST` - server's public ip;
   - `USER` - пользователь сервера;
   - `SSH_KEY` - private ssh key to connect to server;
   - `PASSPHRASE` - passphrase for private ssh key;
   - `SLACK_TO` - Slack Bot's chat id;
   - `SLACK_TOKEN` - token of Slack Bot installed in your workspace;
   - `TELEGRAM_TO` - Telegram Bot's chat id;
   - `TELEGRAM_TOKEN` - token of your Telegram Bot;
3. Clone repo from your branch to your computer `git clone https://github.com/<your_github_username>/yamdb_final.git [<dir_name>]`;
4. Change you working dir to the folder you just cloned `cd <dir_name>`;
5. Create configuration file .env:
   - Create .env file using .env.template as a template `cp .env.template .env`;
   - Give current values to variebles listed in .env file.
6. Push changes to your fork `git push [origin master]` and workflow will start automatically and deploy servise to your server;
7. Wait till workflow will terminate successfully. You can now find documentation here `http://<public ip сервера>/redoc/`.

Perfect! It works.

### Add initial data to your database

1. Connect to your server via ssh (`ssh <username>@<public_ip>`, then type your passphrase);
2. Connect to your container where Django app is currently running `docker exec -it yamdb-web-final bash`;
3. Apply migrations `python3 manage.py migrate`;
4. Load initial data from initial_data.json `python manage.py loaddata initial_data.json`;

In case you want to generate your own initial data, check out [RealPython article](https://realpython.com/data-migrations/#examples).
You can also create data using shell, don't forget to import models firstly: `python manage.py shell`.

### Add container's superuser

You can create container's superuser:
   - Install sudo if you hanen't done that already `apt-get install -y sudo`;
   - Create user to whom you want to grant sudo privilegies `adduser <username>`;
   - Add new user to sudo group `usermod -aG sudo <username>`.
   
### Add Django app's superuser

Connect to Django app's container as described in previous section, step 2:
   - `python manage.py createsuperuser`;
   - enter your email and think up password.
</details>
