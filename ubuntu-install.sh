# install wireguard
apt install software-properties-common -y
apt-get install curl -y
add-apt-repository ppa:wireguard/wireguard 
apt-get update -y
apt-get install wireguard -y
wget -O /etc/wireguard/wg0.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wg0.conf
chmod 600 /etc/wireguard/wg0.conf
#systemctl start wg-quick@wg0
systemctl enable wg-quick@wg0

# ip forward bbr
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf 
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
#echo "ip link set eth0 txqueuelen 5000" >> /etc/rc.local
##echo "ip link set wg0 txqueuelen 5000" >> /etc/rc.local
#sysctl -p 

#install v2ray h2,ws,tcp,quic
#bash <(curl -L -s https://install.direct/go.sh)
#wget -O /etc/v2ray/config.json  https://raw.githubusercontent.com/wangyi2005/ocserv/master/v2ray_server.json
#wget -O /etc/v2ray/wy_cer.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wy_cer.pem 
#wget -O /etc/v2ray/wy_key.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wy_key.pem 
#systemctl enable v2ray
#systemctl start v2ray

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
#systemctl restart dnsmasq

#set ip rules
iptables -t nat -A POSTROUTING -j MASQUERADE
#iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
#iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
apt-get install iptables-persistent -y
iptables-save > /etc/iptables/rules.v4

# install ocserv 0.12.4
#apt-get install ocserv -y
#apt autoremove
#wget -O /etc/ocserv/ocserv.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/ocserv.conf
#wget -O /etc/ocserv/ca-cert.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/ca-cert.pem
#wget -O /etc/ocserv/server-cert.pem  https://raw.githubusercontent.com/wangyi2005/ocserv/master/server-cert.pem
#wget -O /etc/ocserv/server-key.pem  https://raw.githubusercontent.com/wangyi2005/ocserv/master/server-key.pem
#wget -O /etc/systemd/system/ocserv.service  https://raw.githubusercontent.com/wangyi2005/ocserv/master/ocserv.service
#cat /lib/systemd/system/ocserv.service（uncommet require 和 also）

