#!/bin/bash

read -p "Have you deleted the heroku app? (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac

source ./.env

cp -r g2l-server ../../production/g2l-env
cd ../../production/g2l-env

heroku login
heroku create g2l
heroku config:set CHANNEL_ACCESS_TOKEN=$CHANNEL_ACCESS_TOKEN --app g2l
heroku config:set CHANNEL_SECRET=$CHANNEL_SECRET --app g2l
heroku config:set TEST_USER_ID=$TEST_USER_ID --app 


