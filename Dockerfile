FROM python:3.12-alpine

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    TZ=UTC

WORKDIR /usr/workspace

# Системные зависимости:
# - chromium / chromium-chromedriver для Selenium
# - openjdk11-jre для Allure
# - curl, wget, tar для скачивания и распаковки
# - bash часто удобен для entrypoint-скрипта
RUN apk add --no-cache \
    chromium \
    chromium-chromedriver \
    openjdk11-jre \
    curl \
    wget \
    tar \
    tzdata \
    bash

# Установка Allure
ARG ALLURE_VERSION=2.13.8
RUN curl -L -o /tmp/allure.tgz \
    https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/${ALLURE_VERSION}/allure-commandline-${ALLURE_VERSION}.tgz \
    && tar -xzf /tmp/allure.tgz -C /opt \
    && ln -s /opt/allure-${ALLURE_VERSION}/bin/allure /usr/bin/allure \
    && rm -f /tmp/allure.tgz

# Сначала копируем только зависимости, чтобы лучше работал docker layer cache
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Потом копируем весь проект
COPY . .

# Entry point
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["pytest", "-v"]