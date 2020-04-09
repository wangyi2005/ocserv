#centos 7 (18.10)
#cat /etc/redhat-release
yum update -y
yum install wget net-tools -y
#rpm -qa | grep epel
#rpm -e epel-release-7-11.noarch
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
curl -Lo /etc/yum.repos.d/jdoss-wireguard-epel-7.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
#yum repolist
#yum install epel-release -y

#v2ray tcp h2 8443 quic 4443
bash <(curl -L -s https://install.direct/go.sh)
wget -O /etc/v2ray/config.json  https://raw.githubusercontent.com/wangyi2005/ocserv/master/v2ray_server.json
wget -O /etc/v2ray/wy_cer.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wy_cer.pem 
wget -O /etc/v2ray/wy_key.pem   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wy_key.pem 
systemctl enable v2ray
#systemctl start v2ray

# install sniproxy
wget -O /usr/bin/sniproxy.rpm  https://raw.githubusercontent.com/wangyi2005/ocserv/master/sniproxy-0.6.0.rpm
yum install /usr/bin/sniproxy.rpm
wget -O /etc/systemd/system/sniproxy.service   https://raw.githubusercontent.com/wangyi2005/ocserv/master/sniproxy.service
wget -O /etc/sniproxy.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/sniproxy.conf
systemctl enable sniproxy

# install gost
wget -O /usr/bin/gost.gz  https://github.com/ginuerzh/gost/releases/download/v2.8.2/gost-linux-amd64-2.8.2.gz
gzip -d /usr/bin/gost.gz
chmod +x /usr/bin/gost
wget -O /etc/systemd/system/gost.service   https://raw.githubusercontent.com/wangyi2005/ocserv/master/gost.service
systemctl enable gost
#systemctl start gost

# nginx v2ray ws
yum install nginx
wget -O  /etc/nginx/conf.d/nginx-v2ray.conf https://raw.githubusercontent.com/wangyi2005/ocserv/master/nginx-v2ray.conf
systemctl enable nginx
#systemctl start nginx

# caddy
curl https://getcaddy.com | bash -s personal tls.dns.cloudflare
#curl https://getcaddy.com | bash -s personal http.cors
chown root:root /usr/local/bin/caddy
chmod 755 /usr/local/bin/caddy
setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy
groupadd -g 33 www-data
useradd -g www-data --no-user-group --home-dir /var/www --no-create-home --shell /usr/sbin/nologin --system --uid 33 www-data
mkdir /etc/caddy
chown -R root:root /etc/caddy
mkdir /etc/ssl/caddy
chown -R root:www-data /etc/ssl/caddy
chmod 0770 /etc/ssl/caddy
wget -O /etc/caddy/Caddyfile https://raw.githubusercontent.com/wangyi2005/ocserv/master/Caddyfile
chown root:root /etc/caddy/Caddyfile
chmod 644 /etc/caddy/Caddyfile
mkdir /var/www
chown www-data:www-data /var/www
chmod 555 /var/www
wget -O /var/www/index.html https://raw.githubusercontent.com/wangyi2005/ocserv/master/Welcome.html
wget -O /etc/systemd/system/caddy.service https://raw.githubusercontent.com/caddyserver/caddy/master/dist/init/linux-systemd/caddy.service
chown root:root /etc/systemd/system/caddy.service
chmod 644 /etc/systemd/system/caddy.service
systemctl enable caddy.service
#systemctl start caddy.service

# install dingo port 5353 CDN-china-domains
#wget -O /usr/bin/dingo  https://raw.githubusercontent.com/wangyi2005/ocserv/master/dingo-linux-amd64
wget -O /usr/bin/dingo  https://github.com/pforemski/dingo/releases/download/0.13/dingo-linux-amd64
chmod +x /usr/bin/dingo
wget -O /etc/systemd/system/dingo-ecs-us.service   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dingo-ecs-us.service
wget -O /etc/systemd/system/dingo-ecs-cn.service   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dingo-ecs-cn.service
systemctl enable dingo-ecs-us
systemctl enable dingo-ecs-cn
#systemctl start dingo
#systemctl start dingo-edns

# install dnsmasq port 53
yum -y install dnsmasq
wget -O /etc/dnsmasq.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/dnsmasq.conf
systemctl enable dnsmasq
#systemctl start dnsmasq

# install PowerDNS Recursor - https://repo.powerdns.com 
#yum -y install https://repo.powerdns.com/centos/x86_64/7Server/rec-42/pdns-recursor-4.2.0-1pdns.el7.x86_64.rpm
#wget -O /etc/yum.repos.d/powerdns-rec-42.repo https://repo.powerdns.com/repo-files/centos-rec-42.repo
#yum -y install pdns-recursor
#nano /etc/pdns-recursor/recursor.conf
#wget -O /etc/pdns-recursor/recursor.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/pdns-recursor.conf 
#systemctl enable pdns-recursor
#systemctl start pdns-recursor

# install iptables
systemctl stop firewalld.service
systemctl mask firewalld.service

yum install iptables-services  -y
iptables -t nat -A POSTROUTING -s 192.168.88.0/24 -o eth0 -j MASQUERADE
iptables -t mangle -A POSTROUTING -o eth0 -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1380 
iptables -t mangle -A FORWARD -o eth0 -p tcp -m tcp --tcp-flags SYN,RST SYN -s 172.16.16.0/24 -m tcpmss --mss 1361:1536 -j TCPMSS --set-mss 1360
iptables -t mangle -A FORWARD -s 192.168.88.0/24 -o eth0 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
#iptables -A FORWARD -i wg0 -j ACCEPT
#iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD -s 192.168.88.0/255.255.255.0 -i eth0 -o eth1 -m conntrack --ctstate NEW -j ACCEPT
#iptables -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
#iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1380 
iptables-save > /etc/sysconfig/iptables
#iptables-restore < /etc/sysconfig/iptables
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf 
tuned-adm list
tuned-adm profile network-throughput
#tuned-adm profile network-latency
#tuned-adm profile latency-performance
#tuned-adm profile throughput-performance
#tuned-adm active
# Disable IPv6
#echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
#echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf

#https://shadowsocks.org/en/config/advanced.html
https://klaver.it/linux/sysctl.conf
https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt

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

#echo "net.core.rmem_max = 67108864" >> /etc/sysctl.conf
#echo "net.core.rmem_default = 12582912" >> /etc/sysctl.conf
#echo "net.core.wmem_max = 67108864" >> /etc/sysctl.conf
#echo "net.core.wmem_default = 12582912" >> /etc/sysctl.conf
#echo "net.ipv4.tcp_rmem = 4096 87380 33554432" >> /etc/sysctl.conf
#echo "net.ipv4.tcp_wmem = 4096 65536 33554432" >> /etc/sysctl.conf
#echo "net.ipv4.tcp_mtu_probing=1" >> /etc/sysctl.conf
#echo "net.core.netdev_max_backlog = 5000" >> /etc/sysctl.conf
#echo 'net.ipv4.tcp_window_scaling = 1' >> /etc/sysctl.conf
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

#install cloud-torrent
mkdir /cloud-torrent
wget -O /cloud-torrent/cloud-torrent.gz  https://github.com/jpillora/cloud-torrent/releases/download/0.8.25/cloud-torrent_linux_amd64.gz
gzip -d /cloud-torrent/cloud-torrent.gz
chmod +x /cloud-torrent/cloud-torrent
wget -O /etc/systemd/system/cloud-torrent.service   https://raw.githubusercontent.com/wangyi2005/ocserv/master/cloud-torrent.service
systemctl enable cloud-torrent
#systemctl start cloud-torrent

# wireguard need reboot
mkdir /etc/wireguard 
#yum --enablerepo=elrepo-kernel install kernel-ml kernel-ml-headers kernel-ml-devel -y
yum install wireguard-dkms wireguard-tools -y
wget -O /etc/wireguard/wg0.conf   https://raw.githubusercontent.com/wangyi2005/ocserv/master/wg0.conf
chmod 600 /etc/wireguard/wg0.conf
#wg-quick up wg0
#wg-quick down wg0
systemctl enable wg-quick@wg0
#systemctl start wg-quick@wg0

#ip link set eth0 txqueuelen 5000
#ip link set wg0 txqueuelen 5000
#ip link set vpns0 txqueuelen 5000

reboot
