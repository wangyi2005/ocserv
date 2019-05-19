#centos 7 (18.10)
cat /etc/redhat-release
yum update -y
yum install wget -y
yum -y install net-tools
#rpm -qa | grep epel
rpm -e epel-release-7-11.noarch
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
curl -Lo /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
yum repolist
yum install epel-release -y

#v2ray tcp h2 8443 quic 4443
bash <(curl -L -s https://install.direct/go.sh)
wget -O /etc/v2ray/config.json  https://raw.githubusercontent.com/wangyi2005/ocserv/master/v2ray_server.json
wget -O /etc/v2ray/wy_cer.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wy_cer.pem 
wget -O /etc/v2ray/wy_key.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wy_key.pem 
systemctl enable v2ray
#systemctl status v2ray

# install dingo port 5353 CDN-china-domains
#wget -O /usr/bin/dingo  https://raw.githubusercontent.com/wangyi2005/ocserv/master/dingo-linux-amd64
wget -O /usr/bin/dingo  https://github.com/pforemski/dingo/releases/download/0.13/dingo-linux-amd64
chmod +x /usr/bin/dingo
wget -O /etc/systemd/system/dingo.service   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dingo.service
systemctl enable dingo

# install dnsmasq port 53
yum -y install dnsmasq
wget -O /etc/dnsmasq.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dnsmasq.conf
systemctl enable dnsmasq

# install iptables
systemctl stop firewalld.service
systemctl mask firewalld.service

yum install iptables-services  -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
#iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD -s 192.168.88.0/255.255.255.0 -i eth0 -o eth1 -m conntrack --ctstate NEW -j ACCEPT
#iptables -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
#iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1380 
iptables-save > /etc/sysconfig/iptables
iptables-restore < /etc/sysconfig/iptables
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf 
tuned-adm list
tuned-adm profile network-throughput
tuned-adm active
#echo "net.core.rmem_max = 67108864" >> /etc/sysctl.conf
#echo "net.core.rmem_default = 12582912" >> /etc/sysctl.conf
#echo "net.core.wmem_max = 67108864" >> /etc/sysctl.conf
#echo "net.core.wmem_default = 12582912" >> /etc/sysctl.conf
#echo "net.ipv4.tcp_rmem = 4096 87380 33554432" >> /etc/sysctl.conf
#echo "net.ipv4.tcp_wmem = 4096 65536 33554432" >> /etc/sysctl.conf
#echo "net.ipv4.tcp_mtu_probing=1" >> /etc/sysctl.conf
#echo "net.core.netdev_max_backlog = 5000" >> /etc/sysctl.conf
#echo 'net.ipv4.tcp_window_scaling = 1' >> /etc/sysctl.conf
echo "net.ipv4.conf.all.forwarding=1">> /etc/sysctl.conf
echo "net.ipv4.conf.default.forwarding=1">> /etc/sysctl.conf

#echo "ip link set eth0 txqueuelen 5000" >> /etc/sysconfig/network-scripts/ifcfg-eth0
#service network restart
#ip link set eth0 txqueuelen 5000
#ip link set wg0 txqueuelen 5000
#sysctl -p

# ocserv 0.12.3 tcp 443 udp 443
yum install ocserv -y 
#yum --enablerepo=epel-testing install ocserv -y 
#yum install https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/o/ocserv-0.12.3-1.el7.x86_64.rpm -y
#ocserv -v
wget -O /etc/ocserv/ocserv.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/ocserv.conf
wget -O /etc/ocserv/ca-cert.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/ca-cert.pem
wget -O /etc/ocserv/server-cert.pem  https://raw.githubusercontent.com/wangyi2005/ocserv/master/server-cert.pem
wget -O /etc/ocserv/server-key.pem  https://raw.githubusercontent.com/wangyi2005/ocserv/master/server-key.pem
systemctl enable ocserv

# wireguard 
mkdir /etc/wireguard 
yum --enablerepo=elrepo-kernel install kernel-ml kernel-ml-headers kernel-ml-devel -y
yum install wireguard-dkms wireguard-tools -y
wget -O /etc/wireguard/wg0.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wg0.conf
chmod 600 /etc/wireguard/wg0.conf
wg-quick up wg0
#wg-quick down wg0
systemctl start wg-quick@wg0
systemctl enable wg-quick@wg0

#systemctl start firewalld
#systemctl enable firewalld
#firewall-cmd --zone=public --add-port=443/tcp --permanent
#firewall-cmd --zone=public --add-port=443/udp --permanent
#firewall-cmd --zone=public --add-port=2443/udp --permanent
#firewall-cmd --zone=public --add-port=4443/tcp --permanent
#firewall-cmd --zone=public --add-port=6443/tcp --permanent
#firewall-cmd --zone=public --add-port=8443/tcp --permanent
#firewall-cmd --zone=public --add-port=26060/tcp --permanent
#firewall-cmd --zone=public --add-port=44210/udp --permanent
#firewall-cmd --zone=trusted --add-interface=wg0 --permanent
#firewall-cmd --zone=public --add-masquerade --permanent
#firewall-cmd --reload

#ip link set eth0 txqueuelen 5000
#ip link set wg0 txqueuelen 5000
#ip link set vpns0 txqueuelen 5000

reboot
