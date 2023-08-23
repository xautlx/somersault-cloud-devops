ansible-role-frp
================

[![Ansible Role: bit_kitchen.frpc](https://img.shields.io/badge/role-kitos9112.frp-blue)](https://galaxy.ansible.com/kitos9112/ansible_role_frp)
[![Build Status: bit-kitchen/frpc](https://travis-ci.org/bit-kitchen/frpc.svg?branch=master)](https://travis-ci.org/bit-kitchen/frpc)

Install and configure [frp](https://github.com/fatedier/frp) client or server on Linux.

    ansible-galaxy install msoutullo.frp

Requirements
------------

None.

Role Variables
--------------

### frpc

Variable         | Required/Optional | Default     | Comment
--------         | ----------------- | -------     | -------
frpc_version     | Optional          | (undefined) | frp [release](https://github.com/fatedier/frp/releases) version. <br> Defaults to the latest version.
frpc_config_name | Optional          | (undefined) | Used for frpc config file name and frpc service name.
||
frpc_config_file | Optional          | (undefined) | Local config file to be copied to remote. <br> If this is specified, the following options are not considered for frpc config.
||
frpc_server_addr | Optional          | `127.0.0.1` | Server address for frpc.
frpc_server_port | Optional          | `7000`      | Server port for frpc.
frpc_token       | Optional          | (undefined) | frp token used for authentication if specified on server.
frpc_http_proxy  | Optional          | (undefined) | The proxy to use for connections to frp server. <br> This option is also used as proxy for other network related operations.


### frps

Variable         | Required/Optional | Default     | Comment
--------         | ----------------- | -------     | -------
frps_version     | Optional          | (undefined) | frp [release](https://github.com/fatedier/frp/releases) version. <br> Defaults to the latest version.
frps_config_name | Optional          | (undefined) | Used for frps config file name and frps service name.
||
frps_config_file | Optional          | (undefined) | Local config file to be copied to remote. <br> If this is specified, the following options are not considered for frps config.
||
frps_bind_addr   | Optional          | `0.0.0.0`   | Bind address for frps. Defaults to listen on all interfaces.
frps_bind_port   | Optional          | `7000`      | Bind port for frps.
frps_token       | Optional          | (undefined) | frp token used for authentication.



Example Playbook
----------------


# TODO: Add examples
License
-------

[MIT](LICENSE)
