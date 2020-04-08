#ubuntu 18 to 19
#apt update && apt upgrade && apt dist-upgrade && apt autoremove
#apt-get install update-manager-core
#nano /etc/update-manager/release-upgrades (Prompt=normal)
#do-release-upgrade

# install wireguard
apt install software-properties-common -y
#apt-get install curl -y
#19.10 still 
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

# Disable IPv6
#echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
#echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf

#apt-get install tuned -y
#tuned-adm list
#tuned-adm profile network-throughput
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

# install sniproxy 0.6.0 require 19.10
apt-get install sniproxy -y
wget -O /etc/sniproxy.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/sniproxy.conf
wget -O /etc/systemd/system/sniproxy.service   https://raw.githubusercontent.com/wangyi2005/ocserv/master/sniproxy.service
systemctl enable sniproxy

# update kernel  https://kernel.ubuntu.com/~kernel-ppa/mainline/
#cd ~ && mkdir newkernel && cd newkernel
#wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.6.2/linux-headers-5.6.2-050602_5.6.2-050602.202004020822_all.deb
#wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.6.2/linux-headers-5.6.2-050602-generic_5.6.2-050602.202004020822_amd64.deb
#wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.6.2/linux-image-unsigned-5.6.2-050602-generic_5.6.2-050602.202004020822_amd64.deb
#wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.6.2/linux-modules-5.6.2-050602-generic_5.6.2-050602.202004020822_amd64.deb
#dpkg -i *.deb

reboot
