#!/bin/bash

CUR_DIR="$(pwd)"
SHELL_DIR="$(cd "$(dirname "$0")" && pwd)"
#echo "CD to ${SHELL_DIR} dir to execute scripts"

hosts=""
services=""

while getopts i:s: opt
do
  case $opt in
    i)
      hosts="$OPTARG"
    ;;
  esac
done
shift $((OPTIND-1))

services=$*

if [ "${hosts}0" = "0" ]; then
   echo "Usage: $0 -i [hosts_file] [update services list (blank split)]"
   echo "Options:"
   echo "      -i ansible hosts file"
   echo "Example:"
   echo "      $0 -i ../hosts-multiple somersault-cloud-system somersault-cloud-infra"
   exit 1
fi

echo "========================================="
echo "Updating host list："
#ansible-playbook -i hosts --list-hosts all-in-one.yml
cat ${hosts} | grep ansible_ssh_host
echo "========================================="

#echo 3 > /proc/sys/vm/drop_caches
ansible-playbook  ${SHELL_DIR}/microservice.yml -i ${hosts} -e "updating_services=\"${services}\""
