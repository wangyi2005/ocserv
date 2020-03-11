# GCP console
# area: asia-east-1 Taiwan
# machine： 1cpu 600M 10G
# OS: ubuntu 19.10
# manage network：IP forward
# setup firewall rule: accept udp 443

# SSH browser
sudo -i 
nano /etc/ssh/sshd_config
# PermitRootLogin yes
# PasswordAuthentication yes
passwd root

# root，putty
#BBR，ip_forward
nano /etc/sysctl.conf
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
net.ipv4.ip_forward = 1

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
yum install https://www.elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm
rpm -qa | grep kernel
yum remove.....
yum install --enablerepo=elrepo-kernel kernel-ml kernel-ml-headers kernel-ml-devel kernel-ml-tools kernel-ml-tools-libs
grub2-set-default 0
grub2-mkconfig -o /etc/grub2.cfg
reboot
yum remove.....

# disbable systemd-resolved
systemctl stop systemd-resolved
systemctl disable systemd-resolved

#install wireguard
add-apt-repository ppa:wireguard/wireguard
apt-get update
apt-get install wireguard
nano /etc/wireguard/wg0.conf
[Interface]
PrivateKey = YM1ktOPrdzW7bABxoJaA1zvK/zeMPWsK0uqrGNw/TUw=
Address = 192.168.88.1/24
ListenPort = 443
PostUp   = iptables -t nat -A POSTROUTING -o ens4 -j MASQUERADE
PostDown = iptables -t nat -D POSTROUTING -o ens4 -j MASQUERADE
mtu = 1400

# install dingo
wget -O /usr/bin/dingo  https://github.com/pforemski/dingo/releases/download/0.13/dingo-linux-amd64
chmod +x /usr/bin/dingo
nano /etc/systemd/system/dingo-ecs-cn.service
#before=dnsmasq.service
systemctl enable dingo-ecs-cn

#install dnsmasq
apt-get install dnsmasq
nano /etc/dnsmasq.conf
nano nano /etc/systemd/system/sniproxy.service 
#onedrive,github
#after=wg-quick@wg0.service

#install sniproxy 0.6
apt-get install sniproxy
nano /etc/systemd/system/sniproxy.service 
#after=wg-quick@wg0.service
nano /etc/sniproxy.conf

reboot

#create snapshot





