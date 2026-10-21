FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app
COPY requirements.txt .
RUN apt-get update && apt-get install -y --no-install-recommends libgomp1 \
    && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir -r requirements.txt

RUN adduser --disabled-password --gecos "" --uid 1000 app \
    && mkdir -p /app/instance \
    && chown app:app /app/instance
COPY --chown=app:app app.py index.html ./
COPY --chown=app:app assets ./assets
USER app

ENV HOME=/home/app
EXPOSE 7860
CMD ["sh", "-c", "flask --app app init-db && exec gunicorn --workers 1 --threads 4 --bind 0.0.0.0:${PORT:-7860} --timeout 180 app:app"]
