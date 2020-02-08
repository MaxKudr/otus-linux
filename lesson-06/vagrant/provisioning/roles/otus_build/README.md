Role Name
=========

This Ansible role build Typora rpm application.

Requirements
------------

None.

Role Variables
--------------

	typora_version: '0.9.75'

Typora version for building.

	typora_release: '1'

Typora RPM build release.


Dependencies
------------

None.

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: otus_build }

License
-------

None.

Author Information
------------------

This role was created in 2019 by Max Kudriavtsev.
