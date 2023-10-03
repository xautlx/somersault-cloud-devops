#!/bin/bash

shopt -s expand_aliases
source /etc/profile.d/ansbile-alias.sh
CUR_DIR="$(pwd)"
SHELL_DIR="$(cd "$(dirname "$0")" && pwd)"
#echo "CD to ${SHELL_DIR} dir to execute scripts"
cd "${SHELL_DIR}" || exit

params=$*
hosts=""

while getopts i: opt
do
  case $opt in
    i)
      hosts="$OPTARG"
    ;;
  esac
done
shift $((OPTIND-1))

if [ "${hosts}0" = "0" ]; then
   echo "Usage: $0 -i [hosts_file]"
   exit 1
fi

timer_start=`date "+%Y-%m-%d %H:%M:%S"`

#echo 3 > /proc/sys/vm/drop_caches
ansible-playbook  all-in-one.yml ${params}

timer_end=`date "+%Y-%m-%d %H:%M:%S"`

start_seconds=$(date --date="$timer_start" +%s)
end_seconds=$(date --date="$timer_end" +%s)

echo "----------------------------------------------------------------------------------"
echo "start at: $timer_start , end at: $timer_end, total: $((end_seconds-start_seconds)) seconds"
echo "----------------------------------------------------------------------------------"

#echo "CD back to ${CUR_DIR} dir"
cd "${CUR_DIR}" || exit
