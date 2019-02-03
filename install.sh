#centos 7 
yum install wget -y

# aliyun EPEL
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
#yum clean all 
#yum makecache
#yum install epel-release -y

#v2ray tcp h2 8443 quic 4443
bash <(curl -L -s https://install.direct/go.sh)
wget -O /etc/v2ray/config.json  https://raw.githubusercontent.com/wangyi2005/ocserv/master/v2ray_server.json
wget -O /etc/v2ray/wy_cer.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wy_cer.pem 
wget -O /etc/v2ray/wy_key.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wy_key.pem 
cat /etc/v2ray/config.json
cat /etc/v2ray/wy_cer.pem 
cat /etc/v2ray/wy_key.pem 
systemctl start v2ray
systemctl status v2ray

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf 
sysctl -p
systemctl stop firewalld.service
systemctl mask firewalld.service

yum -y install dnsmasq
wget -O /etc/dnsmasq.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dnsmasq.conf
wget -O /etc/resolv.dnsmasq.conf  https://raw.githubusercontent.com/wangyi2005/ocserv/master/resolv.dnsmasq.conf
wget -O /etc/dnsmasq.d/china-domains.conf  https://raw.githubusercontent.com/wangyi2005/ocserv/master/china-domains.conf
cat /etc/dnsmasq.conf
cat /etc/resolv.dnsmasq.conf
systemctl enable dnsmasq
systemctl start dnsmasq

yum install iptables-services  -y
systemctl start  iptables.service
iptables -t nat -A POSTROUTING -s 192.168.18.0/24 -o eth0 -j MASQUERADE
iptables -A FORWARD -i vpns+ -j ACCEPT 
iptables -A FORWARD -o vpns+ -j ACCEPT
iptables -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
iptables-save > /etc/sysconfig/iptables

#ocserv 0.12.1 tcp 443 udp 443
yum install ocserv -y 
systemctl enable ocserv
ocserv -v
wget -O /etc/ocserv/ocserv.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/ocserv.conf
wget -O /etc/ocserv/ca-cert.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/ca-cert.pem
wget -O /etc/ocserv/server-cert.pem  https://raw.githubusercontent.com/wangyi2005/ocserv/master/server-cert.pem
wget -O /etc/ocserv/server-key.pem  https://raw.githubusercontent.com/wangyi2005/ocserv/master/server-key.pem

cat /etc/ocserv/ocserv.conf
cat /etc/ocserv/ca-cert.pem
cat /etc/ocserv/server-cert.pem
cat /etc/ocserv/server-key.pem
#ocpasswd -c /etc/ocserv/ocpasswd  wangyi
systemctl start ocserv
systemctl status ocserv
