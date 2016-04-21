Tree
----
```
.
├── defaults
│   └── main.yml
├── files
│   └── NGINX.repo    --- repo file nginx latest
├── handlers
│   └── main.yml      ---  restart nginx
├── meta
│   └── main.yml      ---  no
├── README.md
├── tasks
│   └── main.yml      ---  main tasks
├── templates
│   └── virtual.conf  ---  nginx virtual conf
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml      ---  role default vars
```


Role Name
=========

Common role to install nginx and template its virtual conf file

Requirements
------------

no

Role Variables
--------------

defaul vars in [vars/main.yml](vars/main.yml), and any variables that can/should be set via parameters to the role

Dependencies
------------

no

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: common, nginx_http_port: 8080 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).

