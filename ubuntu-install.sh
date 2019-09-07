# install wireguard
apt install software-properties-common -y
apt-get install curl -y
add-apt-repository ppa:wireguard/wireguard 
apt-get update -y
apt-get install wireguard -y
wget -O /etc/wireguard/wg0.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wg0.conf
chmod 600 /etc/wireguard/wg0.conf
systemctl enable wg-quick@wg0

# ip forward bbr
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf 
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf

apt-get install tuned -y
tuned-adm list
tuned-adm profile network-throughput
#tuned-adm profile network-latency
#tuned-adm profile latency-performance
#tuned-adm profile throughput-performance
#tuned-adm active

# install dingo port 5353 CDN-china-domains
#wget -O /usr/bin/dingo  https://raw.githubusercontent.com/wangyi2005/ocserv/master/dingo-linux-amd64
wget -O /usr/bin/dingo  https://github.com/pforemski/dingo/releases/download/0.13/dingo-linux-amd64
chmod +x /usr/bin/dingo
wget -O /etc/systemd/system/dingo-ecs-us.service   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dingo-ecs-us.service
wget -O /etc/systemd/system/dingo-ecs-cn.service   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dingo-ecs-cn.service
systemctl enable dingo-ecs-us
systemctl enable dingo-ecs-cn

# install dnsmasq
apt-get install dnsmasq -y
wget -O /etc/dnsmasq.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dnsmasq.conf
systemctl enable dnsmasq

#set ip rules
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
apt-get install iptables-persistent -y
iptables-save > /etc/iptables/rules.v4

reboot
