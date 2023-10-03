stop slave;

CHANGE MASTER TO
    master_auto_position=0,
    Master_Host='{{mysql_replication_master}}',
    MASTER_USER='{{mysql_replication_name}}',
    MASTER_PASSWORD='{{mysql_replication_passwd}}';

start slave;