USE somersault_cloud_infra;

-- ----------------------------
-- Records of infra_data_source_config
-- ----------------------------
BEGIN;
-- TODO 当前为固定密码，待优化密码为从明文密码参数动态加密方式
{% for db in db_names %}
INSERT INTO `infra_data_source_config` (
	`id`,
	`name`,
	`url`,
	`username`,
	`password`,
	`creator`,
	`create_time`,
	`updater`,
	`update_time`,
	`deleted`
)
VALUES
	(
		{{loop.index}},
		'{{db}}',
		'jdbc:mysql://{{mysql_master_vip}}:3306/{{db}}?useSSL=false&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=UTF-8&serverTimezone=GMT%2b8&nullCatalogMeansCurrent=true',
		'{{mysql_user}}',
		'sPuqlc7LEdXvy56eicBPVtNlmhKufiipbNSwSBfKKCM=',
		'1',
		'2023-05-31 11:33:09',
		'1',
		'2023-05-31 11:33:09',
	    b'0'
	);
{% endfor %}
COMMIT;