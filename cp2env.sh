#!/bin/bash

source ./.env

read -p "Have you deleted the heroku app? (y/n): " yn
if [ $yn!="y" ]; then
    heroku apps:destroy --app $APP_NAME --confirm $APP_NAME
fi

if [ -d $REMOVE_DIR ]; then
    rm -rf $REMOVE_DIR
else 
    echo "dir is not exist."
fi

cp -r g2l-server $PRODUCTION_DIR
cd $PRODUCTION_DIR

heroku login
heroku create $APP_NAME
heroku config:set CHANNEL_ACCESS_TOKEN=$CHANNEL_ACCESS_TOKEN --app $APP_NAME
heroku config:set CHANNEL_SECRET=$CHANNEL_SECRET --app $APP_NAME
heroku config:set TEST_USER_ID=$TEST_USER_ID --app $APP_NAME

repos_dir="https://git.heroku.com/${APP_NAME}.git"
today=`date`
commit_message="auto deploy ${today}"

git init
git remote add heroku $repos_dir
git add .
git commit -m $commit_message
git push heroku master

heroku open



