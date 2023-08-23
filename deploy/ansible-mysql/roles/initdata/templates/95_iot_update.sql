USE somersault_cloud_iot;

BEGIN;
{% for i in range(2,100) %}
INSERT INTO `iot_device_info` (`id`, `uni_code`, `name`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`, `mqtt_server_id`, `status`)
VALUES ({{i}}, 'TEST{{i}}', '测试设备{{i}}', '1', '2023-06-01 15:07:23', '1', '2023-06-01 16:25:28', b'0', 1, 1, 0);
{% endfor %}
COMMIT;