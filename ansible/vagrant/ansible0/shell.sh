yum -y update

mkdir -p /tmp/install/
cd /tmp/install/

#NGINX
touch /etc/yum.repos.d/NGINX.repo
cat <<"NGINXREPO" > /etc/yum.repos.d/NGINX.repo
[NGINX]
name=NGINX repo
baseurl=http://NGINX.org/packages/centos/6/$basearch/
gpgcheck=0
enabled=1
NGINXREPO

yum install -y nginx

cat <<"NGINXCONF" > /etc/nginx/conf.d/virtual.conf
server {

    listen 8080;
    server_name localhost;
    location /jenkins {
      proxy_set_header        Host $host:$server_port;
      proxy_set_header        X-Real-IP $remote_addr;
      proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header        X-Forwarded-Proto $scheme;

      proxy_pass          http://127.0.0.1:8081;
      proxy_read_timeout  90;

      proxy_redirect      http://127.0.0.1:8081 scheme://localhost:8080;
    }

    location /mnt-lab {

      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;

      proxy_pass http://127.0.0.1:8082;
      proxy_read_timeout 90;

      proxy_redirect default;
    }
}

NGINXCONF

#mv /etc/nginx/conf.d/default.conf /root/
sed -i 's/*.conf/virtual.conf/' /etc/nginx/nginx.conf
sleep 1
/etc/init.d/nginx start
chkconfig nginx on


#install GIT
yum install -y git-all

#install JAVAFORJENKINS
yum install -y java-1.7.0-openjdk

#JENKINS
adduser jenkins
echo jenkins | passwd jenkins --stdin

touch /etc/sudoers.d/jenkins
cat <<"SUDOERS" >> /etc/sudoers.d/jenkins
Defaults:jenkins !requiretty
jenkins  ALL=NOPASSWD: ALL
SUDOERS

cat <<"JENKINS" >> /home/jenkins/.bashrc
#export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.99.x86_64/
#export JRE_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.99.x86_64/jre/
#export PATH=$PATH:$HOME/bin:JAVA_HOME:JRE_HOME
export JAVA_HOME=/opt/jdk1.7.0_79/
export M2_HOME=/opt/apache-maven-3.3.9
export M2=$M2_HOME/bin
export MAVEN_OPTS="-Xms256m -Xmx512m"
export PATH=$M2:$PATH
JENKINS

wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
yum install -y jenkins
sleep 1
sed -i 's/JENKINS_PORT="8080"/JENKINS_PORT="8081"/' /etc/sysconfig/jenkins
sed -i 's/JENKINS_LISTEN_ADDRESS=""/JENKINS_LISTEN_ADDRESS="127.0.0.1"/' /etc/sysconfig/jenkins
sed -i 's/JENKINS_AJP_PORT="8009"/JENKINS_AJP_PORT="8010"/' /etc/sysconfig/jenkins
sed -i 's/JENKINS_ARGS=""/JENKINS_ARGS="--prefix=\/jenkins"/' /etc/sysconfig/jenkins

#install MAVEN


wget -nv http://ftp.byfly.by/pub/apache.org/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
#cp /vagrant/apache-maven-3.3.9-bin.tar.gz /tmp/install
tar -xzf apache-maven-3.3.9-bin.tar.gz -C /opt/
chown -R jenkins:jenkins /opt/apache-maven-3.3.9/


#install JAVAFORTOMCAT

wget -nv --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz
#cp /vagrant/jdk-7u79-linux-x64.tar.gz /tmp/install/
tar -xzf jdk-7u79-linux-x64.tar.gz -C /opt/

/etc/init.d/jenkins start
sleep 5
chkconfig jenkins on


#TOMCAT
adduser tomcat
echo tomcat | passwd tomcat --stdin

cat <<"JAVA" >> /home/tomcat/.bashrc
export JAVA_HOME=/opt/jdk1.7.0_79/
export JRE_HOME=/opt/jdk1.7.0_79/jre/
export PATH=$PATH:$HOME/bin:JAVA_HOME:JRE_HOME
JAVA


wget -nv http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz
#cp /vagrant/apache-tomcat-7.0.68.tar.gz /tmp/install/
tar -xzf apache-tomcat-7.0.68.tar.gz
mkdir -p /opt/apache/tomcat/7.0.68/
cp -r apache-tomcat-7.0.68/* /opt/apache/tomcat/7.0.68/

chown -R tomcat:tomcat /opt/apache/tomcat/
chmod +x /opt/apache/tomcat/7.0.68/bin/*.sh

sed -i 's/Connector port="8080"/Connector port="8082"/' /opt/apache/tomcat/7.0.68/conf/server.xml

touch /etc/init.d/tomcat
cat <<"TOMCAT" >> /etc/init.d/tomcat
#!/bin/sh

# chkconfig: 345 99 10
# description: apache tomcat auto start-stop script.

. /etc/init.d/functions

RETVAL=0

start()
{
  echo -n "Starting tomcat"
  su - tomcat -c "sh /opt/apache/tomcat/7.0.68/bin/startup.sh"
  success
  echo
}

stop()
{
  echo -n "Stopping tomcat"
  su - tomcat -c "sh /opt/apache/tomcat/7.0.68/bin/shutdown.sh"
  success
  echo
}

status()
{
  echo "tomcat is running"
}

case "$1" in
start)
        start
        ;;
stop)
        stop
        ;;
status)
        status
        ;;
restart)
        stop
        start
        ;;
*)
        echo $"Usage: $0 {start|stop|status|restart}"
        exit 1
esac
TOMCAT
# end of EOF for /etc/init.d/tomcat file

chmod 755 /etc/init.d/tomcat
chkconfig tomcat on

/etc/init.d/tomcat start
sleep 10
/etc/init.d/jenkins stop
sleep 10

cp -r /vagrant/jenkins/jobs /var/lib/jenkins/
cp -r /vagrant/jenkins/plugins /var/lib/jenkins/
cp /vagrant/jenkins/config.xml /var/lib/jenkins/config.xml
cp /vagrant/jenkins/jenkins.model.JenkinsLocationConfiguration.xml /var/lib/jenkins/jenkins.model.JenkinsLocationConfiguration.xml
cp /vagrant/jenkins/hudson.tasks.Maven.xml /var/lib/jenkins/hudson.tasks.Maven.xml
chown -R jenkins:jenkins /var/lib/jenkins/
sleep 5

/etc/init.d/jenkins start
