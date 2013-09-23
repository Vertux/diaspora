#!/bin/bash

exec 2>&1

diaspora_user="$(stat -c "%U" $(readlink -e './common.sh'))"
export HOME="$(getent passwd "${diaspora_user}" | cut -d: -f6)"
source "$HOME/.bashrc"

cd ..
echo "Switched to app root: $(pwd)"

run_directory="/var/run/diaspora"
mkdir -p "${run_directory}"
chown "${diaspora_user}" "${run_directory}"
echo "Created ${run_directory}"

export RAILS_ENV="$(ruby ./script/get_config.rb server.rails_environment)"

eval $(ruby ./script/get_config.rb \
  port=server.port \
  db=server.database \
  workers=server.sidekiq_workers \
  single_process_mode=environment.single_process_mode? \
  embed_sidekiq_worker=server.embed_sidekiq_worker?
)

if [ -z "${DB}" ]; then
  export DB="${db}"
fi


if [ "${single_process_mode}" = "true" -o "${embed_sidekiq_worker}" =  "true" ]; then
  workers=0
fi

