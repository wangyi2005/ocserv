# install wireguard
apt install software-properties-common -y
apt-get install curl -y
add-apt-repository ppa:wireguard/wireguard 
apt-get update -y
apt-get install wireguard -y
wget -O /etc/wireguard/wg0.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wg0.conf
chmod 600 /etc/wireguard/wg0.conf
systemctl enable wg-quick@wg0

#v2ray tcp ws h2 quic 
#bash <(curl -L -s https://install.direct/go.sh)
#wget -O /etc/v2ray/config.json  https://raw.githubusercontent.com/wangyi2005/ocserv/master/v2ray_server.json
#wget -O /etc/v2ray/wy_cer.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wy_cer.pem 
#wget -O /etc/v2ray/wy_key.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wy_key.pem 
#systemctl enable v2ray
#systemctl start v2ray

# ip forward bbr
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf 
#echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
#echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf

# Disable IPv6
#echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
#echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf

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
#iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
#apt-get install iptables-persistent -y
#iptables-save > /etc/iptables/rules.v4

# update kernel  https://kernel.ubuntu.com/~kernel-ppa/mainline/
#cd ~ && mkdir newkernel && cd newkernel
#wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.6.2/linux-headers-5.6.2-050602_5.6.2-050602.202004020822_all.deb
#wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.6.2/linux-headers-5.6.2-050602-generic_5.6.2-050602.202004020822_amd64.deb
#wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.6.2/linux-image-unsigned-5.6.2-050602-generic_5.6.2-050602.202004020822_amd64.deb
#wgethttps://kernel.ubuntu.com/~kernel-ppa/mainline/v5.6.2/linux-modules-5.6.2-050602-generic_5.6.2-050602.202004020822_amd64.deb
#dpkg -i *.deb

reboot
