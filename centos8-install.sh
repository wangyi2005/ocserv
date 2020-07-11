#uname -a
#cat /etc/redhat-release
yum install wget net-tools -y
yum update -y

#install wireguard
yum install elrepo-release epel-release
yum install kmod-wireguard wireguard-tools
#mkdir /etc/wireguard 
wget -O /etc/wireguard/wg0.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wg0.conf
chmod 600 /etc/wireguard/wg0.conf
#wg-quick up wg0
#wg-quick down wg0
systemctl enable wg-quick@wg0

# install dingo port 5353 5300
#wget -O /usr/bin/dingo  https://raw.githubusercontent.com/wangyi2005/ocserv/master/dingo-linux-amd64
wget -O /usr/bin/dingo  https://github.com/pforemski/dingo/releases/download/0.13/dingo-linux-amd64
chmod +x /usr/bin/dingo
wget -O /etc/systemd/system/dingo-ecs-us.service   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dingo-ecs-us.service
wget -O /etc/systemd/system/dingo-alidns-cn.service   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dingo-alidns-cn.service
systemctl enable dingo-ecs-us
systemctl enable dingo-alidns-cn

# install dnsmasq port 53
yum -y install dnsmasq
wget -O /etc/dnsmasq.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dnsmasq.conf
systemctl enable dnsmasq

# firewall setup
systemctl stop firewalld.service
systemctl mask firewalld.service
nft add table nat
nft add rule nat postrouting masquerade
nft list ruleset > /etc/nftables.conf

#https://shadowsocks.org/en/config/advanced.html
#https://klaver.it/linux/sysctl.conf
#https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt

#fs.file-max = 51200
#net.core.rmem_max = 67108864
#net.core.wmem_max = 67108864
#net.core.netdev_max_backlog = 250000
#net.core.somaxconn = 4096
#net.ipv4.tcp_syncookies = 1
#net.ipv4.tcp_tw_reuse = 1
#net.ipv4.tcp_tw_recycle = 0
#net.ipv4.tcp_fin_timeout = 30
#net.ipv4.tcp_keepalive_time = 1200
#net.ipv4.ip_local_port_range = 10000 65000
#net.ipv4.tcp_max_syn_backlog = 8192
#net.ipv4.tcp_max_tw_buckets = 5000
#net.ipv4.tcp_fastopen = 3
#net.ipv4.tcp_mem = 25600 51200 102400
#net.ipv4.tcp_rmem = 4096 87380 67108864
#net.ipv4.tcp_wmem = 4096 65536 67108864
#net.ipv4.tcp_mtu_probing = 1

# echo 'net.core.wmem_max=12582912' >> /etc/sysctl.conf
# echo 'net.core.rmem_max=12582912' >> /etc/sysctl.conf
# echo 'net.ipv4.tcp_rmem= 10240 87380 12582912' >> /etc/sysctl.conf
# echo 'net.ipv4.tcp_wmem= 10240 87380 12582912' >> /etc/sysctl.conf
# echo 'net.ipv4.tcp_window_scaling = 1' >> /etc/sysctl.conf
# echo 'net.ipv4.tcp_timestamps = 1' >> /etc/sysctl.conf
# echo 'net.ipv4.tcp_sack = 1' >> /etc/sysctl.conf
# echo 'net.core.netdev_max_backlog = 5000' >> /etc/sysctl.conf
#sysctl -p

# install ocserv 1.1 tcp 443 udp 443
yum install ocserv -y 
wget -O /etc/ocserv/ocserv.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/ocserv.conf
systemctl enable ocserv

reboot
