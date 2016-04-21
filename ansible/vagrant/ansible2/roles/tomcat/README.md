Tree
----
```

├── defaults
│   └── main.yml      -- no
├── files
│   ├── inittomcat    -- init tomcat file
│   └── tomcatbashrc  --  bashrc to set java for tomcat
├── handlers
│   └── main.yml      --  restart romcat when server.xml changed
├── meta
│   └── main.yml      -- depends on common and java roles
├── README.md
├── tasks
│   └── main.yml      --  main tasks
├── templates
│   └── server.xml    -- template for tomcat file
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml      --  main var file

```


Role Name
=========

Role to install tomcat

Requirements
------------

no

Role Variables
--------------

defaul vars in [vars/main.yml](vars/main.yml)

Dependencies
------------

java and common nginx role

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: tomcat, nginx_http_port: 8080, tomcat_http_port: 8082 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
