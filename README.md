# Django Channels Chat Starter

A real-time, room-based **websocket chat** built with
[Django Channels](https://channels.readthedocs.io/) and a Redis channel layer.
A clean starting point for adding live chat / presence / notifications to a
Django project, including example AWS Elastic Beanstalk deployment config and
Terraform for the supporting Redis cluster.

## Features

- Async websocket consumer (`chat/consumers.py`) with group broadcast per room
- Room-based routing (`chat/routing.py`, `chatapp/routing.py`)
- Redis-backed channel layer for horizontal scaling
- Postgres via env-configured `DATABASES`
- Optional S3 static/media storage (`chatapp/aws/`)
- Sample Elastic Beanstalk (`.ebextensions/`) and Terraform (`terraform-code/`)

## Stack

Django 2.0 · Channels 2 · Daphne · channels-redis · Postgres · Redis

## Quick start

```bash
pip install -r requirements.txt
cp .env.example .env          # fill in values

# you need a local Redis running for the channel layer:
docker run -p 6379:6379 -d redis:5

python manage.py migrate
python manage.py runserver    # dev (Channels serves websockets via runserver)
```

Open two browser tabs at the chat room URL and watch messages broadcast live.

For production, run under Daphne/ASGI:

```bash
daphne -b 0.0.0.0 -p 8000 chatapp.asgi:application
```

## Configuration

All secrets and hosts come from environment variables — see `.env.example`,
`chatapp/settings.py`, and `chatapp/aws/conf.py`. The Terraform and
`.ebextensions` files contain placeholder hosts/buckets; replace them with your
own. Never commit real credentials.

## License

MIT — see [LICENSE](LICENSE).
