FROM python:3.8.5

WORKDIR /code

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

COPY redoc.yaml /static

RUN python manage.py collectstatic --noinput && \
    python manage.py makemigrations && \
    python manage.py migrate

CMD gunicorn api_yamdb.wsgi:application --bind 0.0.0.0:8000