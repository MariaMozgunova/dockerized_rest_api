### API Yamdb 

В этом проекты вы найдёте Dockerfile и docker-compose.yaml. Последний указанный файл запускает два контейнера: API отзывов о фильмах, книгах и песнях - yamdb, и базу данных PostgreSQL.

### Статус

![CI/CD workflow](https://github.com/MariaMozgunova/yamdb_final/workflows/deploy_workflow/badge.svg)


### Запуск приложения

Эта инструкция поможет запустить сервис на удаленном сервере.

#### Предварительные требования использования приложения
- сервер с public ip и установленной операционной системой Ubuntu;
- Telegram Bot, [документация по созданию](https://tlgrm.ru/docs/bots#kak-sozdat-bota);
- Slack Bot, [документация по созданию](https://api.slack.com/authentication/basics#start);
- аккаунт на DockerHub.

#### Настройка сервера
1. Подключитесь к своему серверу по ssh (`ssh <пользователь_сервера>@<public_ip_сервера>`, затем введите passphrase от ssh key);
2. обновите индекс пакетов APT: `sudo apt update`;
3. Теперь обновите существующие в системе пакеты и установите обновления: `sudo apt upgrade -y`;
4. Установите Docker: `sudo apt install -y docker.io`;
5. выполните команду для автоматического запуска Docker'а: `sudo systemctl enable docker`;

#### Запуск сервиса
1. Создайте fork проекта;
2. В fork перейдите в Settings > Secrets и сконфигурируйте следующие константы для работы workflow:
   - `DOCKER_USERNAME` - логин от DockerHub;
   - `DOCKER_PASSWORD` - пароль от DockerHub;
   - `HOST` - ip сервера;
   - `SSH_KEY` - private ssh key для подключения к серверу;
   - `USER` - пользователь сервера;
   - `SLACK_TO` - id чата с Slack Bot;
   - `SLACK_TOKEN` - токен бота, установленного в workspace;
   - `TELEGRAM_TO` - id чата с Tekegram Bot;
   - `TELEGRAM_TOKEN` - токен бота;
3. Склонируйте репозиторий на свой компьютер `git clone https://github.com/<ваш_никнейм>/yamdb_final.git [<dir_name>]`;
4. Перейдите в папку командой `cd <dir_name>`;
5. Создайте файл конфигураций .env:
   - сделайте копию шаблона файла .env `cp .env.template .env`;
   - присвойте актуальные значения всем полям.
6. Запушите изменения в свой fork `git push [origin master]`;
7. Когда workflow успешно завершится, перейдите на `http://<public ip сервера>/redoc/` и убедитесь, что видите документацию.

Отлично! Всё работает.

### Заполнение базы начальными данными

1. Подключитесь к своему серверу по ssh (`ssh <пользователь_сервера>@<public_ip_сервера>`, затем введите passphrase от ssh key);
2. Выполните команду `docker container ls`, чтобы увидеть CONTAINER ID контейнера с полем IMAGE = yamdb_final_web;
3. Выполните вход в контейнер командой `docker exec -it <CONTAINER ID> bash`;
4. Выполните миграции `python3 manage.py migrate`;
5. В файле initial_data.json подготовлены начальные данные, загрузите их в базу `python manage.py loaddata initial_data.json`;

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