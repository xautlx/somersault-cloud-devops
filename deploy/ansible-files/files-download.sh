#!/bin/bash

CUR_DIR="$(pwd)"
SHELL_DIR="$(cd "$(dirname "$0")" && pwd)"
#echo "CD to ${SHELL_DIR} dir to execute scripts"
cd "${SHELL_DIR}" || exit

#echo 3 > /proc/sys/vm/drop_caches
ansible-playbook  ${SHELL_DIR}/files-download.yml

#echo "CD back to ${CUR_DIR} dir"
cd "${CUR_DIR}" || exit
