#ubuntu 20.04 oraclecloud

apt-get update
apt-get upgrade

apt-get install -y libgnutls28-dev libev-dev

apt-get install -y libpam0g-dev liblz4-dev libseccomp-dev \
	libreadline-dev libnl-route-3-dev libkrb5-dev libradcli-dev \
	libcurl4-gnutls-dev libcjose-dev libjansson-dev libprotobuf-c-dev \
	libtalloc-dev libhttp-parser-dev protobuf-c-compiler gperf \
	nuttcp lcov libuid-wrapper libpam-wrapper libnss-wrapper \
	libsocket-wrapper gss-ntlmssp haproxy iputils-ping freeradius \
	gawk gnutls-bin iproute2 yajl-tools tcpdump

wget https://www.infradead.org/ocserv/download/ocserv-1.1.6.tar.xz
tar Jxf ocserv-1.1.6.tar.xz
cd ocserv-1.1.6
./configure --prefix=/usr/local/ocserv
make&&make install

cp doc/profile.xml /usr/local/ocserv
mkdir -p /etc/ocserv
wget -O /etc/iptables/rules.v4   https://raw.githubusercontent.com/wangyi2005/ocserv/master/rules.v4
wget -O /etc/ocserv/ocserv.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/ocserv.conf
wget -O /etc/ocserv/ca-cert.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/ca-cert.pem
wget -O /etc/ocserv/server-cert.pem  https://raw.githubusercontent.com/wangyi2005/ocserv/master/server-cert.pem
wget -O /etc/ocserv/server-key.pem  https://raw.githubusercontent.com/wangyi2005/ocserv/master/server-key.pem
wget -O /lib/systemd/system/ocserv.service  https://raw.githubusercontent.com/wangyi2005/ocserv/master/ocserv.service

/usr/local/ocserv/bin/ocpasswd -c /etc/ocserv/ocpasswd  wangyi
systemctl daemon-reload
systemctl enable ocserv
systemctl start ocserv

iptables-restore < /etc/iptables/rules.v4
systemctl restart iptables

# ip forward bbr
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf 
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

# install dingo port 5353 CDN-china-domains
#wget -O /usr/bin/dingo  https://raw.githubusercontent.com/wangyi2005/ocserv/master/dingo-linux-amd64
wget -O /usr/bin/dingo  https://github.com/pforemski/dingo/releases/download/0.13/dingo-linux-amd64
chmod +x /usr/bin/dingo
wget -O /etc/systemd/system/dingo-ecs-us.service   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dingo-ecs-us.service
wget -O /etc/systemd/system/dingo-ecs-cn.service   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dingo-ecs-cn.service
systemctl enable dingo-ecs-us
systemctl enable dingo-ecs-cn

# install dnsmasq
systemctl stop systemd-resolved
systemctl disable systemd-resolved

apt-get install dnsmasq -y
wget -O /etc/dnsmasq.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dnsmasq.conf
systemctl enable dnsmasq

# install ocserv

reboot
