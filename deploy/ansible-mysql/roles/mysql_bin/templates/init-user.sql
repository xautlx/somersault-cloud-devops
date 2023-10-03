
{% if ( mysql_root_host is defined and mysql_root_host != 'localhost' ) %}
-- create host root user as required
CREATE USER IF NOT EXISTS 'root' @'{{mysql_root_host}}' IDENTIFIED WITH mysql_native_password BY '{{mysql_root_password}}';
GRANT ALL PRIVILEGES ON *.* TO 'root' @'{{mysql_root_host}}' WITH GRANT OPTION;
{% endif %}

-- Ensure mysqld_exporter user exists
CREATE USER IF NOT EXISTS '{{mysql_prom_exporter_name}}' @'{{mysql_user_host}}' IDENTIFIED WITH mysql_native_password BY '{{mysql_prom_exporter_passwd}}';
GRANT USAGE,PROCESS,REPLICATION CLIENT ON *.* TO '{{mysql_prom_exporter_name}}' @'{{mysql_user_host}}' WITH GRANT OPTION;

-- Ensure mysql_replication user exists
CREATE USER IF NOT EXISTS '{{mysql_replication_name}}' @'{{mysql_user_host}}' IDENTIFIED WITH mysql_native_password BY '{{mysql_replication_passwd}}';
GRANT PROCESS,REPLICATION CLIENT,REPLICATION SLAVE,SELECT ON *.* TO '{{mysql_replication_name}}' @'{{mysql_user_host}}' WITH GRANT OPTION;

CREATE USER IF NOT EXISTS '{{mysql_replication_name}}' @'localhost' IDENTIFIED WITH mysql_native_password BY '{{mysql_replication_passwd}}';
GRANT PROCESS,REPLICATION CLIENT,REPLICATION SLAVE,SELECT ON *.* TO '{{mysql_replication_name}}' @'localhost' WITH GRANT OPTION;


FLUSH PRIVILEGES;