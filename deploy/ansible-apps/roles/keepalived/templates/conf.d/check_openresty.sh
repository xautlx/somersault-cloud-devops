#!/bin/bash

# 创建 /etc/keepalived/down 标识文件则直接降级当前keepalived实例
# 流量调试完毕后建议把 /etc/keepalived/down 移除
if [ -f /etc/keepalived/down ]; then
  #echo "$d DOWN as /etc/keepalived/down exist" >> /var/log/keepalived_openresty.log
  exit 1
fi

# 计算openresty/nginx进程数量，如果未检测到目标进程则降级当前keepalived实例
n=$(docker ps -a | grep somersault-cloud-openresty | grep Up | wc -l)
d=$(date --date today '+%Y-%m-%d %H:%M:%S')
if [ $n -eq 0 ]; then
  #echo "$d DOWN as openresty down" >> /var/log/keepalived_openresty.log
  exit 1
else
  #echo "$d UP" >> /var/log/keepalived_openresty.log
  exit 0
fi
