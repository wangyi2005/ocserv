#bebian 9 to 10 
apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
sed -i 's/stretch/buster/g' /etc/apt/sources.list
#cat etc/apt/sources.list
apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
#cat /etc/os-release

#ubuntu 18 to 19
#apt update && apt upgrade && apt dist-upgrade && apt autoremove
#apt-get install update-manager-core
#nano /etc/update-manager/release-upgrades (Prompt=normal)
#do-release-upgrade -d

# ip forward bbr
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf 
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
# echo "net.core.rmem_max = 67108864" >> /etc/sysctl.conf
# echo "net.core.wmem_max = 67108864" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_rmem = 4096 87380 33554432" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_wmem = 4096 65536 33554432" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_mtu_probing=1" >> /etc/sysctl.conf
# echo "net.core.netdev_max_backlog = 5000" >> /etc/sysctl.conf
sysctl -p 
#lsmod | grep bbr

#v2ray h2,ws,tcp,quic
apt-get install curl -y
bash <(curl -L -s https://install.direct/go.sh)
wget -O /etc/v2ray/config.json  https://raw.githubusercontent.com/wangyi2005/ocserv/master/v2ray_server.json
wget -O /etc/v2ray/wy_cer.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wy_cer.pem 
wget -O /etc/v2ray/wy_key.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wy_key.pem 
#cat /etc/v2ray/config.json
#cat /etc/v2ray/wy_cer.pem 
#cat /etc/v2ray/wy_key.pem 
#systemctl start v2ray
#systemctl status v2ray

# install dnsmasq
apt-get install dnsmasq -y
wget -O /etc/dnsmasq.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dnsmasq.conf
wget -O /etc/resolv.dnsmasq.conf  https://raw.githubusercontent.com/wangyi2005/ocserv/master/resolv.dnsmasq.conf
wget -O /etc/dnsmasq.d/china-domains.conf  https://raw.githubusercontent.com/wangyi2005/ocserv/master/china-domains.conf
#wget -O /etc/dnsmasq.d/china-domains.conf  https://raw.githubusercontent.com/wangyi2005/ocserv/master/china-domains-dingo.conf
#cat /etc/dnsmasq.conf
#cat /etc/resolv.dnsmasq.conf
systemctl enable dnsmasq
#systemctl start dnsmasq

# install dingo port 5353 CDN-china-domains
wget -O /usr/bin/dingo  https://raw.githubusercontent.com/wangyi2005/ocserv/master/dingo-linux-amd64
#wget -O /usr/bin/dingo  https://github.com/pforemski/dingo/releases/download/0.13/dingo-linux-amd64
chmod +x /usr/bin/dingo
wget -O /etc/systemd/system/dingo.service   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dingo.service
systemctl enable dingo

#set ip rules
iptables -t nat -A POSTROUTING -s 192.168.18.0dingo.service/24 -o eth0 -j MASQUERADE
#iptables -A FORWARD -i vpns+ -j ACCEPT 
#iptables -A FORWARD -o vpns+ -j ACCEPT
iptables -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
apt-get install iptables-persistent -y
#cat /etc/iptables/rules.v4

# install ocserv 0.12.2
apt-get install ocserv -y
#apt autoremove
wget -O /etc/ocserv/ocserv.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/ocserv.conf
wget -O /etc/ocserv/ca-cert.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/ca-cert.pem
wget -O /etc/ocserv/server-cert.pem  https://raw.githubusercontent.com/wangyi2005/ocserv/master/server-cert.pem
wget -O /etc/ocserv/server-key.pem  https://raw.githubusercontent.com/wangyi2005/ocserv/master/server-key.pem
#wget -O /etc/systemd/system/ocserv.service  https://raw.githubusercontent.com/wangyi2005/ocserv/master/ocserv.service
#cat /lib/systemd/system/ocserv.service（uncommet require 和 also）

systemctl enable ocserv
#systemctl start ocserv
#systemctl status ocserv
#systemctl stop ocserv.socket
#systemctl disable ocserv.socket
#systemctl start ocserv.service
reboot
