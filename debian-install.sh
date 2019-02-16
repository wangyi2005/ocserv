#bebian 9 to 10 
apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
sed -i 's/stretch/buster/g' /etc/apt/sources.list
cat etc/apt/sources.list
apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
cat /etc/os-release

# ip forward
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf 
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p 
smod | grep bbr


# install dnsmasq
apt-get install dnsmasq -y
wget -O /etc/dnsmasq.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dnsmasq.conf
wget -O /etc/resolv.dnsmasq.conf  https://raw.githubusercontent.com/wangyi2005/ocserv/master/resolv.dnsmasq.conf
wget -O /etc/dnsmasq.d/china-domains.conf  https://raw.githubusercontent.com/wangyi2005/ocserv/master/china-domains.conf
cat /etc/dnsmasq.conf
cat /etc/resolv.dnsmasq.conf
systemctl enable dnsmasq
systemctl start dnsmasq

#set ip rules
iptables -t nat -A POSTROUTING -s 192.168.18.0/24 -o eth0 -j MASQUERADE
iptables -A FORWARD -i vpns+ -j ACCEPT 
iptables -A FORWARD -o vpns+ -j ACCEPT
iptables -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
apt-get install iptables-persistent
cat /etc/iptables/rules.v4

# install ocserv 0.12.1
apt-get install ocserv -y
apt autoremove
wget -O /etc/ocserv/ocserv.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/ocserv.conf
wget -O /etc/ocserv/ca-cert.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/ca-cert.pem
wget -O /etc/ocserv/server-cert.pem  https://raw.githubusercontent.com/wangyi2005/ocserv/master/server-cert.pem
wget -O /etc/ocserv/server-key.pem  https://raw.githubusercontent.com/wangyi2005/ocserv/master/server-key.pem
#cat /lib/systemd/system/ocserv.service（uncommet require 和 also）

systemctl enable ocserv
systemctl start ocserv
systemctl status ocserv
