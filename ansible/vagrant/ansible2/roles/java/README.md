Tree
----
```
.
├── defaults
│   └── main.yml 
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── README.md
├── tasks
│   └── main.yml -----``main file
├── templates
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml
```


Role Name
=========

Role to install java for jenkins and tomcat. Jenkins - openJDK, tomcat - Oracle JDK 7

Requirements
------------

no

Role Variables
--------------

no

Dependencies
------------

no

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: java }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).

