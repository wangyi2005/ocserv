#https://github.com/acmesh-official/acme.sh 支持自动续期
#https://github.com/acmesh-official/acme.sh/wiki/dnsapi
#安装
curl https://get.acme.sh | sh
卸载
acme.sh --uninstall
#先退出终端再次进入
exit
#cloudflare 不再支持 cf,ml等域名的dns api
#export CF_Key="88851c6e592589879d8fdc1e534d2f0a20784"  
#export CF_Email="tanghb@outlook.com" 
#查看变量
env
acme.sh --issue --dns dns_cf -d wangyi.cf -d *.wangyi.cf
#更新acme.sh
acme.sh --upgrade
------------------------------------------------------------------------------------
# 手动模式 https://github.com/acmesh-official/acme.sh/wiki/dns-manual-mode
/root/.acme.sh/acme.sh --issue --dns -d vpn.wangyi.cf --yes-I-know-dns-manual-mode-enough-go-ahead-please
/root/.acme.sh/acme.sh --issue --dns -d cn2.wangyi.cf --yes-I-know-dns-manual-mode-enough-go-ahead-please
#ECC 证书
/root/.acme.sh/acme.sh --issue --dns -d gia.wangyi.cf --yes-I-know-dns-manual-mode-enough-go-ahead-please --keylength ec-256
# 在 cloudflare 添加 提示 的 TXT 记录。
type：TXT
name：_acme-challenge.cn2
content:E8RGF1QkE3eZHq0WxI8mdqwMSvbU842KUfth4vyvI2Y

acme.sh --renew --dns -d vpn.wangyi.cf --yes-I-know-dns-manual-mode-enough-go-ahead-please
#ECC 证书
acme.sh --renew --dns -d gia.wangyi.cf --yes-I-know-dns-manual-mode-enough-go-ahead-please --keylength ec-256

/root/.acme.sh/wangyi.cf/vpn.wangyi.cf.cer
/root/.acme.sh/wangyi.cf/vpn.wangyi.cf.key
/root/.acme.sh/wangyi.cf/ca.cer
/root/.acme.sh/wangyi.cf/fullchain.cer


