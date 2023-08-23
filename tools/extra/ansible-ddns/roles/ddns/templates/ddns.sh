#!/bin/bash

#echo "$(date --date today '+%Y-%m-%d %H:%M:%S') Release IPV6 address: /usr/sbin/dhclient -r -6 {{ddns_network_interface}}"
#/usr/bin/timeout 10 /usr/sbin/dhclient -r -6 {{ddns_network_interface}}
#echo "$(date --date today '+%Y-%m-%d %H:%M:%S') Update IPV6 address: /usr/sbin/dhclient -6 {{ddns_network_interface}}"
#/usr/bin/timeout 10 /usr/sbin/dhclient -6 {{ddns_network_interface}}

cur_ip="$( /usr/sbin/ip a | /usr/bin/grep inet6 | /usr/bin/grep '/64' | /usr/bin/grep {{ddns_ipv6_prefix}} )"
if [  0"${cur_ip}" = "0" ]; then
  sysctl -w net.ipv6.conf.{{ddns_network_interface}}.accept_dad=0
  systemctl restart network
  cur_ip="$( /usr/sbin/ip a | /usr/bin/grep inet6 | /usr/bin/grep '/64' | /usr/bin/grep {{ddns_ipv6_prefix}} )"
fi

if [  0"${cur_ip}" = "0" ]; then
  echo "$(date --date today '+%Y-%m-%d %H:%M:%S') Get IPV6 Failure！！！"
  exit 1
fi

cur_ip="${cur_ip%/64*}"
cur_ip="${cur_ip#*inet6 }"
echo "$(date --date today '+%Y-%m-%d %H:%M:%S') Print Current IPV6 address: ${cur_ip}"

last_ip=""
if [ -f "{{ddns_path}}/ip_last.txt" ]; then
  last_ip="$(cat {{ddns_path}}/ip_last.txt)"
fi
echo "$(date --date today '+%Y-%m-%d %H:%M:%S') Print Last IPV6 address: ${last_ip}"

if [ ! "${last_ip}" = "${cur_ip}" ]; then

  ddns_domains="{{ddns_domains}}"
  if [ -f "{{ddns_path}}/ddns.txt" ]; then
    ddns_domains="${ddns_domains},$(cat {{ddns_path}}/ddns.txt)"
  fi

  echo "$(date --date today '+%Y-%m-%d %H:%M:%S') Update DDNS: ${ddns_domains}.{{ddns_domain_name}} to ${cur_ip}"
  /usr/bin/java  -Dddns_cur_ip=${cur_ip} \
                 -Dddns_domain_name={{ddns_domain_name}} \
                 -Dddns_domains=${ddns_domains} \
                 -Dddns_client_regionId={{ddns_client_regionId}} \
                 -Dddns_client_accessKeyId={{ddns_client_accessKeyId}} \
                 -Dddns_client_secret={{ddns_client_secret}} \
                 -jar {{ddns_path}}/somersault-cloud-ddns.jar

  echo "$(date --date today '+%Y-%m-%d %H:%M:%S') Save ${cur_ip} to {{ddns_path}}/ip_last.txt"
  echo "$(date --date today '+%Y-%m-%d %H:%M:%S') ${cur_ip}" >> {{ddns_path}}/ip_list.log
  echo "${cur_ip}" > {{ddns_path}}/ip_last.txt
fi