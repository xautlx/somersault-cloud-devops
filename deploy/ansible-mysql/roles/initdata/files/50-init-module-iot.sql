/*
 * 业务模块数据库初始化
 */
USE somersault_cloud_iot;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for iot_mqtt_server
-- ----------------------------
CREATE TABLE `iot_mqtt_server` (
   `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
   `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类型',
   `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '唯一标识',
   `endpoint` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '地址',
   `port` int DEFAULT NULL COMMENT '端口',
   `protocol` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '协议',
   `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
   `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
   `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
   `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
   `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
   `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
   `app_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'APPID',
   `app_client_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'AppClientID',
   `app_client_secret` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'AppClientSecret',
   `app_username` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '访问账号',
   `app_password` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '访问密码',
   `status` tinyint DEFAULT NULL COMMENT '状态（0正常 1停用）',
   PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MQTT服务节点配置信息';

-- ----------------------------
-- Records of iot_mqtt_server
-- ----------------------------
BEGIN;
-- 注意MQTT配置账号为免费演示接入账号信息，如果需要开发调试请自行申请免费试用接入账号
INSERT INTO `iot_mqtt_server` (`id`,`type`, `code`, `endpoint`, `port`, `protocol`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`, `app_id`, `app_client_id`, `app_client_secret`, `app_username`, `app_password`, `status`)
VALUES (1, 'easemob', 'e8y5b0', 'e8y5b0.cn1.mqtt.chat', 1883, 'tcp', '1', '2023-06-01 16:22:19', '1', '2023-06-01 16:24:35', b'0', 1, 'e8y5b0', 'YXA63OKS6p_VSkyXNXf50KgV6w', 'YXA6j5MVwTkp4aakvBdrH5OL02F51L0', 'raspi', 'YWMtwQQ2ktaSEe24DH8IDBTW1dzikuqf1UpMlzV3-dCoFeu5DZ6ww8MR7auVuai8mnacAwMAAAGHZF6NzDeeSACBNIfuGQBej9O9MHjM54e9Te3Mki63KMKe4KZTzQxr9A', 0);
COMMIT;

-- ----------------------------
-- Table structure for iot_device_info
-- ----------------------------
CREATE TABLE `iot_device_info` (
   `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
   `uni_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '设备唯一编号',
   `name` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '设备名称',
   `conn_token` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '连接Token',
   `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
   `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
   `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
   `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
   `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
   `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
   `mqtt_server_id` bigint DEFAULT NULL COMMENT '连接配置ID',
   `status` tinyint DEFAULT NULL COMMENT '状态（0正常 1停用）',
   PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备信息';

-- ----------------------------
-- Records of iot_device_info
-- ----------------------------
BEGIN;
INSERT INTO `iot_device_info` (`id`, `uni_code`, `name`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`, `mqtt_server_id`, `status`)
VALUES (1, 'WUGUI01', '树莓派乌龟投喂', '1', '2023-06-01 15:07:23', '1', '2023-06-01 16:25:28', b'0', 1, 1, 0);
COMMIT;


-- ----------------------------
-- Table structure for iot_operator
-- ----------------------------
CREATE TABLE `iot_operator` (
   `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
   `phone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
   `name` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓名/名称',
   `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
   `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
   `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
   `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
   `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
   `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
   `status` tinyint DEFAULT NULL COMMENT '状态（0正常 1停用）',
   PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备运营方';

-- ----------------------------
-- Records of iot_operator
-- ----------------------------
BEGIN;
INSERT INTO `iot_operator` (`id`, `phone`, `name`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`, `status`)
VALUES (1, '18612345678', '1号运营商', '1', '2023-06-01 15:07:23', '1', '2023-06-01 16:25:28', b'0', 1, 0);
COMMIT;


-- ----------------------------
-- Table structure for iot_operator_user
-- ----------------------------
CREATE TABLE `iot_operator_user` (
   `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
   `operator_id` bigint NOT NULL COMMENT '运营商ID',
   `user_id` bigint NOT NULL COMMENT '用户ID',
   `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
   `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
   `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
   `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
   `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
   `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
   PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备运营方';

-- ----------------------------
-- Records of iot_operator_user
-- ----------------------------
BEGIN;
INSERT INTO `iot_operator_user` (`id`, `operator_id`, `user_id`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`)
VALUES (1, 1, 1, '1', '2023-06-01 15:07:23', '1', '2023-06-01 16:25:28', b'0', 1);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;


