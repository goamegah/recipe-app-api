FROM python:3.9-alpine3.13
LABEL maintainer="goamegah:komlan.godwin.amegah@gmail.com"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
# create virtual environment in container
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    # in order to help psycopg2 to be able to connect to the database
    apk add --update --no-cache postgresql-client && \
    # in order docker can install pyscopg2 correctly but don't need them after installation \
    # installed packages will be store virtually on .tmp-build-deps folder
    apk add --update --no-cache --virtual .tmp-build-deps build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    # specify DEV arg as boolean when call docker compose in cmd line to install test packages
    if [ $DEV="true" ]; \
      then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser --disabled-password --no-create-home django-user

ENV PATH="/py/bin:$PATH"

USER django-user
