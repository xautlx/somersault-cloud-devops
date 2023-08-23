#!/bin/bash

CUR_DIR="$(pwd)"
SHELL_DIR="$(cd "$(dirname "$0")" && pwd)"
#echo "CD to ${SHELL_DIR} dir to execute scripts"

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

if [ ! -f ~/.ssh/id_rsa ]; then
  echo '免密初始化设置，输入信息生成秘钥: '
  ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
fi

echo "========================================="
echo "请输入root密码执行主机初始化配置："
cat ${hosts} | grep ansible_ssh_host
echo "========================================="

# -k 用于初始化免密操作，手工输入root密码，避免配置文件root密码留痕
ansible-playbook -k -i ${hosts} ${SHELL_DIR}/authorize.yml

