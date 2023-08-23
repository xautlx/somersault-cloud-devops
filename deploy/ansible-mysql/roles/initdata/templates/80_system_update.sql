USE somersault_cloud_system;

BEGIN;
{% if groups['skywalking'] | length >= 1 %}
update `system_menu` set path='http://{{skywalking_dashboard_addr | default("")}}' where component='infra/skywalking/index';
{% else %}
update `system_menu` set status = 1 where component='infra/skywalking/index';
{% endif %}

{% if groups['prometheus'] | length >= 1 %}
update `system_menu` set path='http://{{prometheus_dashboard_addr | default("")}}' where component='infra/prometheus/index';
{% else %}
update `system_menu` set status = 1 where component='infra/prometheus/index';
{% endif %}

{% if groups['alertmanager'] | length >= 1 %}
update `system_menu` set path='http://{{alertmanager_dashboard_addr | default("")}}' where component='infra/alertmanager/index';
{% else %}
update `system_menu` set status = 1 where component='infra/alertmanager/index';
{% endif %}

{% if groups['grafana'] | length >= 1 %}
update `system_menu` set path='http://{{grafana_dashboard_addr | default("")}}' where component='infra/grafana/index';
{% else %}
update `system_menu` set status = 1 where component='infra/grafana/index';
{% endif %}

{% if hostvars[groups['apps_microservice'][0]]['springdoc_swagger_enabled'] | bool == True %}
update `system_menu` set path='http://{{openresty_vip_addr}}/doc.html' where component='infra/swagger/index';
{% else %}
update `system_menu` set status = 1 where component='infra/swagger/index';
{% endif %}

update `system_menu` set path='http://{{rokcetmq_dashboard_addr | default("")}}' where component='infra/rocketmq/index';
update `system_menu` set path='http://{{xxl_job_dashboard_addr}}/xxl-job-admin/' where component='infra/xxl-job/index';
update `system_menu` set path='http://{{nacos_dashboard_addr}}/nacos/' where component='infra/nacos/index';
update `system_menu` set path='http://{{monitor_dashboard_addr | default("")}}/druid/index.html' where component='infra/druid/index';
update `system_menu` set path='http://{{monitor_dashboard_addr | default("")}}/admin-boot/wallboard' where component='infra/server/index';

-- 停用大屏设计菜单
update `system_menu` set status = 1 where component='report/goview/index';

COMMIT;