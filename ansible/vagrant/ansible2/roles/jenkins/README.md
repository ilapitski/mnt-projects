Tree
----
```
roles/jenkins/
├── defaults
│   └── main.yml                ---   no
├── files
│   ├── config.xml              ---     jenkins conf file
│   ├── hudson.tasks.Maven.xml  ---     set maven location to jenkins
│   ├── jenkinsbashrc           ---     bashrc for maven to set java_home
│   ├── jenkins.model.JenkinsLocationConfiguration.xml      ---     set url (location configuration) for jenkins
│   ├── jobs
│   │   ├── build
│   │   │   └── config.xml      ---     build job
│   │   └── deploy
│   │       └── config.xml      ---     deploy job
│   └── sudojenkinscp
├── handlers
│   └── main.yml                ---     restart jenkins when config changed
├── meta
│   └── main.yml                ---     dependancies
├── README.md
├── tasks
│   └── main.yml                ---     main tasks
├── templates
│   └── jenkinssys              ---     jenkins sysconfig template
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml                ---     main variables file

```

Role Name
=========

Role to install jenkins, can be standalone

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
         - { role: jenkins, nginx_http_port: 8080, jenkins_http_port: 8081, jenkins_ajp_port: 8010 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
