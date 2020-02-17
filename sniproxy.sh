yum -y groupinstall "Development Tools"
yum -y install libev-devel pcre-devel udns-devel rpm-build
git clone https://github.com/dlundquist/sniproxy.git
cd sniproxy
./autogen.sh && ./configure && make dist
rpmbuild --define "_sourcedir `pwd`" -ba redhat/sniproxy.spec
cd /root/rpmbuild/RPMS/x86_64
yum -y install sniproxy-0.6.0+git.8.g3fa47ea-1.el7.x86_64.rpm
