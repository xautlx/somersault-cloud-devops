-- root账户登录执行如下语句创建应用访问user账密以及相关的database和授权

{% for db in db_names %}
create database if not exists {{db}} default character set utf8mb4 collate utf8mb4_unicode_ci;
{% endfor %}

{% if hostvars[inventory_hostname]['mysql_root_password'] | default('') != '' %}
{% for host in db_user_hosts %}
create user if not exists '{{mysql_user}}'@'{{host}}' identified with mysql_native_password by '{{mysql_passwd}}';
{% endfor %}
{% endif %}

{% for db in db_names %}
{% for host in db_user_hosts %}
grant all privileges on {{db}}.* to '{{mysql_user}}'@'{{host}}';
{% endfor %}
{% endfor %}

flush privileges;