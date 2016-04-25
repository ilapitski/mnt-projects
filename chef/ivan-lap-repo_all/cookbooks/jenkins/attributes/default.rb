default['jenkins']['jenkins_user'] = 'jenkins'
default['jenkins']['jenkins_group'] = 'jenkins'
default['jenkins']['jenkins_http_port'] = '8081'
default['jenkins']['jenkins_port']="8081"
default['jenkins']['jenkins_bind_address']="127.0.0.1"
default['jenkins']['jenkins_ajp_port']="8010"
default['jenkins']['jenkins_prefix']="--prefix=\/jenkins"

default['jenkins']['jenkins_maven']= "apache-maven-3.3.9"
default['jenkins']['jenkins_m2_home']="/opt/#{ node['jenkins']['jenkins_maven'] }"
default['jenkins']['jenkins_m2']="#{ node['jenkins']['jenkins_m2_home'] }/bin"
default['jenkins']['maven_opts']="-Xms256m -Xmx512m"

default['jenkins']['jenkins_path']="$M2:$PATH"
default['jenkins']['jenkins_key_url']="https://jenkins-ci.org/redhat/jenkins-ci.org.key"

