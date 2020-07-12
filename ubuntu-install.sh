#ubuntu 18 to 19
#apt update && apt upgrade && apt dist-upgrade && apt autoremove
#apt-get install update-manager-core
#nano /etc/update-manager/release-upgrades (Prompt=normal)
#do-release-upgrade

# update kernel  https://kernel.ubuntu.com/~kernel-ppa/mainline/
#cd /tmp
#wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.6.3/linux-headers-5.6.3-050603_5.6.3-050603.202004080837_all.deb
#wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.6.3/linux-headers-5.6.3-050603-generic_5.6.3-050603.202004080837_amd64.deb
#wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.6.3/linux-image-unsigned-5.6.3-050603-generic_5.6.3-050603.202004080837_amd64.deb
#wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.6.3/linux-modules-5.6.3-050603-generic_5.6.3-050603.202004080837_amd64.deb
#dpkg -i *.deb

apt-get update
apt-get upgrade
apt install software-properties-common -y
# install wireguard
#apt-get install curl -y
#19.10 still 
add-apt-repository ppa:wireguard/wireguard 
apt-get update -y
#kernal 5.6 only install wireguard-tools
apt-get install wireguard 
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

# install sniproxy 0.5.0 first
#apt-get install sniproxy -y
#https://packages.ubuntu.com/disco/amd64/sniproxy/download
#wget -O /usr/bin/sniproxy.deb https://raw.githubusercontent.com/wangyi2005/ocserv/master/sniproxy_0.6.0-1_amd64.deb
#dpkg -i /usr/bin/sniproxy.deb
#wget -O /etc/sniproxy.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/sniproxy.conf
#wget -O /etc/systemd/system/sniproxy.service   https://raw.githubusercontent.com/wangyi2005/ocserv/master/sniproxy.service
#systemctl enable sniproxy

reboot
