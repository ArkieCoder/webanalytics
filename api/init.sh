#!/bin/sh

export RACK_ENV="development"
export MAIN_APP_FILE="app.rb"

bundle update

if [ ! -r "/flags/DB_INITIALIZED" ]
then
  rake db:create && rake db:migrate && touch /flags/DB_INITIALIZED
fi

bash /startup.sh

