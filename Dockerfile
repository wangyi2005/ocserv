FROM alpine:latest

ENV OC_VERSION=0.12.1

RUN apk add --virtual .run-deps gnutls-utils iptables libnl3 readline &&\
    mkdir -p /dev/net &&\
    mknod /dev/net/tun c 10 200 &&\
    chmod 0666 /dev/net/tun &&\
    iptables -t nat -A POSTROUTING -j MASQUERADE &&\
    iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu 
 
 EXPOSE 8080
