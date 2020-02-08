Role Name
=========

This Ansible role configure http CentOS OTUS repository.

Requirements
------------

None.

Role Variables
--------------

	nginx_port: '8080

Nginx listening port.

Dependencies
------------

None.

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: otus_repo }

License
-------

None.

Author Information
------------------

This role was created in 2019 by Max Kudriavtsev.
