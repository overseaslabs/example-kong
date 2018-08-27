#!/bin/sh
set -e

echo "*:*:*:${POLLING_USER}:${POLLING_PASS}" > /root/.pgpass && chmod 600 /root/.pgpass

#waiting for postgres
until psql --host=$DATABASE_HOST --username=$POLLING_USER $POLLING_DB -w &>/dev/null
do
  echo "Waiting for PostgreSQL..."
  sleep 1
done

echo "Postgres is ready"

echo "Running migrations..."

kong migrations up

export KONG_NGINX_DAEMON=off

if [[ "$1" == "kong" ]]; then
  PREFIX=${KONG_PREFIX:=/usr/local/kong}
  mkdir -p $PREFIX

  if [[ "$2" == "docker-start" ]]; then

  echo "Preparing kong..."

    kong prepare -p $PREFIX

    echo "Starting nginx $PREFIX..."

    exec /usr/local/openresty/nginx/sbin/nginx \
      -p $PREFIX \
      -c nginx.conf
  fi
fi

echo "Starting kong..."

exec "$@"