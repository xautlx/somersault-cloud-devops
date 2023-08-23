#!/bin/bash

echo "$(date --date today '+%Y-%m-%d %H:%M:%S') notify_offline_mysql: waiting MySQL replica finish" >> /var/log/keepalived_mysql.log

M_File1=$(mysql -u{{mysql_replication_name}} -p{{mysql_replication_passwd}} -e "show master status\G" | awk -F': ' '/File/{print $2}')
M_Position1=$(mysql -u{{mysql_replication_name}} -p{{mysql_replication_passwd}} -e "show master status\G" | awk -F': ' '/Position/{print $2}')
sleep 1
M_File2=$(mysql -u{{mysql_replication_name}} -p{{mysql_replication_passwd}} -e "show master status\G" | awk -F': ' '/File/{print $2}')
M_Position2=$(mysql -u{{mysql_replication_name}} -p{{mysql_replication_passwd}} -e "show master status\G" | awk -F': ' '/Position/{print $2}')

i=1

while true; do
  if [ $M_File1 = $M_File1 ] && [ $M_Position1 -eq $M_Position2 ]; then
    echo "$(date --date today '+%Y-%m-%d %H:%M:%S') notify_offline_mysql: MySQL replica finish DONE" >> /var/log/keepalived_mysql.log
    break
  else
    sleep 1

    if [ $i -gt 60 ]; then
      break
    fi
    continue
    let i++
  fi
done
