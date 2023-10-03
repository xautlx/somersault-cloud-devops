#!/bin/bash

shopt -s expand_aliases
source /etc/profile.d/ansbile-alias.sh
CUR_DIR="$(pwd)"
SHELL_DIR="$(cd "$(dirname "$0")" && pwd)"
#echo "CD to ${SHELL_DIR} dir to execute scripts"
cd "${SHELL_DIR}" || exit

ansible-playbook  ansible-files/files-download-package.yml ansible-files/files-download-image.yml

#echo "CD back to ${CUR_DIR} dir"
cd "${CUR_DIR}" || exit
