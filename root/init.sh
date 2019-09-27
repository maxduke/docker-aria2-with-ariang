#!/bin/sh
set -e

UID=`id -u`
GID=`id -g`

echo
echo "UID: $UID"
echo "GID: $GID"
echo

echo "Setting conf"

touch /aria2/conf/aria2.session

if [[ ! -e /aria2/conf/aria2.conf ]]
then
  cp /aria2.conf.default /aria2/conf/aria2.conf
fi

echo "[DONE]"

echo "Setting owner and permissions"

chown -R $UID:$GID /aria2/conf
find /aria2/conf -type d -exec chmod 755 {} +
find /aria2/conf -type f -exec chmod 644 {} +

echo "[DONE]"

echo "Starting darkhttpd with AriaNG"

darkhttpd /aria-ng --port 80 --daemon
darkhttpd /aria2/downloads --port 8080 --daemon

echo "Starting aria2c"

exec aria2c \
    --conf-path=/aria2/conf/aria2.conf \
  > /dev/stdout \
  2> /dev/stderr

echo 'Exiting aria2'
