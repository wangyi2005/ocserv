#https://github.com/acmesh-official/acme.sh
curl https://get.acme.sh | sh
exit
export CF_Key="88851c6e592589879d8fdc1e534d2f0a20784"  
export CF_Email="tanghb@outlook.com" 
acme.sh --issue --dns dns_cf -d wangyi.cf -d *.wangyi.cf
#更新acme.sh
acme.sh --upgrade


/root/.acme.sh/wangyi.cf/wangyi.cf.cer
/root/.acme.sh/wangyi.cf/wangyi.cf.key
/root/.acme.sh/wangyi.cf/ca.cer
/root/.acme.sh/wangyi.cf/fullchain.cer


