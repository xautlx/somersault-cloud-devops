#!/bin/bash

count=1
while true; do
  mysql -u{{mysql_replication_name}} -p{{mysql_replication_passwd}} -e "show status;" >/dev/null 2>&1
  i=$?
  ps aux | grep mysqld | grep -v grep >/dev/null 2>&1
  j=$?
  if [ $i = 0 ] && [ $j = 0 ]; then
    exit 0
  else
    if [ $i = 1 ] && [ $j = 0 ]; then
      exit 0
    else
      if [ $count -gt 5 ]; then
        break
      fi
      let count++
      continue
    fi
  fi
done

exit 1