Role Name
=========

Ez a role egy fajlt kreal

Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

file_author: "Default Joe" - ebbbol lesz az alairas
file_content: |                      - ez lesz a default tartalom
  This is the default content

  Authored by: {{ file_author }}
file_path: /tmp/default_file         - ide jon letra a file
file_mode: 0644
file_owner: root
file_group: root


Dependencies
------------

none

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: writeafile, file_path: /tmp/examplefile, file_author: "Johannes Exampleman" }

License
-------

BSD

Author Information
------------------

Trifo
