#!/bin/bash

read -p "Have you deleted the heroku app? (y/n): " yn
if [ $yn!="y" ]; then
    heroku apps:destroy --app g2l --confirm g2l
fi

source ./.env

if [ -d $REMOVE_DIR ]; then
    rm -rf $REMOVE_DIR
else 
    echo "dir is not exist."
fi

cp -r g2l-server ../../production/g2l-env
cd ../../production/g2l-env

heroku login
heroku create g2l
heroku config:set CHANNEL_ACCESS_TOKEN=$CHANNEL_ACCESS_TOKEN --app g2l
heroku config:set CHANNEL_SECRET=$CHANNEL_SECRET --app g2l
heroku config:set TEST_USER_ID=$TEST_USER_ID --app g2l

git remote add heroku https://git.heroku.com/g2l.git
git add .
git commit -m "auto deploy"
git push heroku master

heroku open



