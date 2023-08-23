#!/bin/bash

CUR_DIR="$(pwd)"
SHELL_DIR="$(cd "$(dirname "$0")" && pwd)"
#echo "CD to ${SHELL_DIR} dir to execute scripts"
cd "${SHELL_DIR}" || exit

export ansible_ver=2.9.27

ansible_installed="$(rpm -qa | grep ansible-${ansible_ver})"
if [ "${ansible_installed}" = "" ]; then
  echo "Install ansible ${ansible_ver} ..."
  mkdir -p files/ansible-${ansible_ver}
  cd ${SHELL_DIR}/files/ansible-${ansible_ver}
  ansible_rpm_count="$(find -name '*.rpm' | wc -l)"
  if [ "${ansible_rpm_count}" -eq "0" ]; then
    yum install --downloadonly --downloaddir=. ansible-${ansible_ver}
  fi
  rpm -ivh *.rpm --nodeps --force
  sed -i "s/#host_key_checking = False/host_key_checking = False/g" /etc/ansible/ansible.cfg
  sed -i "s/#timeout = 10/timeout = 60/g" /etc/ansible/ansible.cfg
fi
ansible --version

if [ ! -f ~/.ansible/collections/ansible_collections/community/general/README.md ]; then
  cd ${SHELL_DIR}/files/ansible_collections
  echo 'ansible-galaxy collection install --no-deps community.general ...'
  if [ -f ./community-general.tar.gz ]; then
    mkdir -p ~/.ansible/collections/ansible_collections/community
    tar -xzvf community-general.tar.gz
    mv community/general ~/.ansible/collections/ansible_collections/community/.
    rm -fr community
  else
    ansible-galaxy collection install --no-deps community.general
  fi
fi
ls -lh ~/.ansible/collections/ansible_collections/community/general/README.md

if [ ! -f ~/.ansible/collections/ansible_collections/community/mysql/README.md ]; then
  cd ${SHELL_DIR}/files/ansible_collections
  echo 'ansible-galaxy collection install --no-deps community.mysql ...'
  if [ -f ./community-mysql.tar.gz ]; then
    mkdir -p ~/.ansible/collections/ansible_collections/community
    tar -xzvf community-mysql.tar.gz
    mv community/mysql ~/.ansible/collections/ansible_collections/community/.
    rm -fr community
  else
    ansible-galaxy collection install --no-deps community.mysql
  fi
fi
ls -lh ~/.ansible/collections/ansible_collections/community/mysql/README.md

#echo "CD back to ${CUR_DIR} dir"
cd "${CUR_DIR}" || exit
