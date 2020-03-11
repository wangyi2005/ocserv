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
systemctl enable dingo-ecs-cn

#install dnsmasq
apt-get install dnsmasq 
#onedrive,github

#install sniproxy 0.6
apt-get install sniproxy

reboot

#create snapshot





