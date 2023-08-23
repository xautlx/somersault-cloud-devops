-- root账户登录执行如下语句创建应用访问user账密以及相关的Database和授权

{% for db in db_names %}
CREATE DATABASE IF NOT EXISTS {{db}} DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
{% endfor %}

{% if hostvars[inventory_hostname]['mysql_root_password'] | default('') != '' %}
{% for host in db_user_hosts %}
CREATE USER IF NOT EXISTS '{{mysql_user}}' @'{{host}}' IDENTIFIED WITH mysql_native_password BY '{{mysql_passwd}}';
{% endfor %}
{% endif %}

{% for db in db_names %}
{% for host in db_user_hosts %}
GRANT ALL PRIVILEGES ON {{db}}.* TO '{{mysql_user}}' @'{{host}}' WITH GRANT OPTION;
{% endfor %}
{% endfor %}

FLUSH PRIVILEGES;