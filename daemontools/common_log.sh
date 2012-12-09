#!/bin/bash
source ./common.sh

mkdir -p "./log/${log_directory_name}"
chown "${diaspora_user}" "./log/${log_directory_name}"

exec setuidgid "${diaspora_user}" multilog t "./log/${log_directory_name}"
