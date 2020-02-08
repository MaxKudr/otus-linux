Role Name
=========

This Ansible role configure Nginx server for lesson 09.

Requirements
------------

None.

Role Variables
--------------

	nginx_port: '80'

Nginx listen port.

Dependencies
------------

None.

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: otus_nginx, nginx_port: '8080' }

License
-------

None.

Author Information
------------------

This role was created in 2019 by Max Kudriavtsev.
