#!/bin/bash

CUR_DIR="$(pwd)"
SHELL_DIR="$(cd "$(dirname "$0")" && pwd)"
#echo "CD to ${SHELL_DIR} dir to execute scripts"
cd "${SHELL_DIR}" || exit

echo "========================================="
echo "请输入root密码执行工具服务安装部署："
cat ${SHELL_DIR}/hosts | grep ansible_ssh_host
echo "========================================="

timer_start=`date "+%Y-%m-%d %H:%M:%S"`

ansible-playbook -k -i ${SHELL_DIR}/hosts  ${SHELL_DIR}/all-in-one.yml

timer_end=`date "+%Y-%m-%d %H:%M:%S"`

start_seconds=$(date --date="$timer_start" +%s)
end_seconds=$(date --date="$timer_end" +%s)

echo "----------------------------------------------------------------------------------"
echo "start at: $timer_start , end at: $timer_end, total: $((end_seconds-start_seconds)) seconds"
echo "----------------------------------------------------------------------------------"

#echo "CD back to ${CUR_DIR} dir"
cd "${CUR_DIR}" || exit
