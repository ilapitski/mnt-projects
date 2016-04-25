require 'serverspec'
set :backend, :exec

describe 'packages are installed' do
  it 'nginx, java, git and jenkins are installed' do
    expect(package('nginx')).to be_installed
    expect(package('jenkins')).to be_installed
  end
end

describe 'services are running' do
  it 'nginx,tomcat and jenkins services' do
    expect(service('nginx')).to be_enabled
    expect(service('jenkins')).to be_enabled
    expect(service('tomcat')).to be_running
    expect(service('jenkins')).to be_running
  end
end

describe 'ports are listened' do
  it 'nginx, jenkins and tomcat ports' do
    expect(port(8080)).to be_listening
    expect(port(8081)).to be_listening
    expect(port(8082)).to be_listening
  end
end

describe command('ls /opt/apache-tomcat-7.0.69') do
  its(:stdout) { should match /conf/ }
  its(:stdout) { should match /bin/ }
  its(:stdout) { should match /webapps/ }
end

describe file('/opt/apache-tomcat-7.0.69') do
  it { should be_directory }
  it { should be_owned_by 'tomcat' }
  it { should be_writable }
end

describe command('ls /var/lib/jenkins/jobs') do
  its(:stdout) { should match /deploy/ }
  its(:stdout) { should match /build/ }
end

describe file('/etc/init.d/tomcat') do
  it { should exist }
end

describe file('/etc/init.d/jenkins') do
  it { should exist }
end

describe file('/etc/sysconfig/jenkins') do
  it { should exist }
end

describe file('/var/lib/jenkins') do
  it { should be_directory }
  it { should be_owned_by 'jenkins' }
  it { should be_writable }
end
