FROM ubuntu:disco

RUN apt-get update &&\
    apt-get -y install apt-utils ocserv iptables  &&\
    mkdir -p /dev/net &&\
    mknod /dev/net/tun c 10 200 &&\
    chmod 0666 /dev/net/tun 
    #iptables -t nat -A POSTROUTING -j MASQUERADE &&\
    #iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu 
CMD ["ocserv", "-c", "/etc/ocserv/ocserv.conf", "-f"]
EXPOSE 8080
