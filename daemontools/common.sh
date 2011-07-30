#!/bin/bash

exec 2>&1

DIASPORA_USER=$(stat -c "%U" $(readlink -e './common.sh'))
export HOME=$(getent passwd $DIASPORA_USER | cut -d: -f6)
export rvm_path=$HOME/.rvm

cd ..

if [ -e $rvm_path ]; then
  source $rvm_path/scripts/rvm
  rvm rvmrc load
fi

export RAILS_ENV=$(./script/get_config.rb server.rails_environment)
export DB=$(./script/get_config.rb server.database)
