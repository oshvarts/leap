#!/bin/bash

WHOAMI=$(whoami)
USER=${USER_NAME:-default}

if [ -w /etc/passwd ]; then
    grep -v "^${USER}:" /etc/passwd > /tmp/passwd
    echo "${USER}:x:$(id -u):0:${USER} user:${HOME}:/sbin/nologin" >> /tmp/passwd
    cat /tmp/passwd > /etc/passwd
    rm /tmp/passwd
fi

exec "$@"
