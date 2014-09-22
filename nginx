#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi

clear

cur_dir=$(pwd)

function InitInstall()
{
cat /etc/issue
uname -a
MemTotal=`free -m | grep Mem | awk '{print  $2}'`  
echo -e "\n Memory is: ${MemTotal} MB "
apt-get update
apt-get remove -y apache2 apache2-doc apache2-utils apache2.2-common apache2.2-bin apache2-mpm-prefork apache2-doc apache2-mpm-worker mysql-client mysql-server mysql-common php5 php5-common php5-cgi php5-mysql php5-curl php5-gd
killall apache2
dpkg -l |grep mysql 
dpkg -P libmysqlclient15off libmysqlclient15-dev mysql-common 
dpkg -l |grep apache 
dpkg -P apache2 apache2-doc apache2-mpm-prefork apache2-utils apache2.2-common
dpkg -l |grep php 
dpkg -P php5 php5-common php5-cgi php5-mysql php5-curl php5-gd
apt-get purge `dpkg -l | grep php| awk '{print $2}'`

#set timezone
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

apt-get install -y ntpdate
ntpdate -u pool.ntp.org
date

#Disable SeLinux
if [ -s /etc/selinux/config ]; then
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
fi

if [ -s /etc/ld.so.conf.d/libc6-xen.conf ]; then
sed -i 's/hwcap 1 nosegneg/hwcap 0 nosegneg/g' /etc/ld.so.conf.d/libc6-xen.conf
fi
 
apt-get install -y apt-spy
cp /etc/apt/sources.list /etc/apt/sources.list.bak
apt-spy update
apt-spy -d stable -a $area -t 5

grep null /etc/apt/sources.list.d/apt-spy.list
if [ $? -eq 0 ]; then
cat >/etc/apt/sources.list.d/apt-spy.list<<EOF
deb http://mirror.peer1.net/debian/ stable main #contrib non-free
deb-src http://mirror.peer1.net/debian/ stable main #contrib non-free
deb http://security.debian.org/ stable/updates main
EOF
fi

apt-get update
apt-get autoremove -y
apt-get -fy install
apt-get install -y build-essential gcc g++ make
for packages in build-essential gcc g++ make cmake autoconf automake re2c wget cron bzip2 libzip-dev libc6-dev file rcconf flex vim nano bison m4 gawk less make cpp binutils diffutils unzip tar bzip2 libbz2-dev libncurses5 libncurses5-dev libtool libevent-dev libpcre3 libpcre3-dev libpcrecpp0 libssl-dev zlibc openssl libsasl2-dev libxml2 libxml2-dev libltdl3-dev libltdl-dev libmcrypt-dev zlib1g zlib1g-dev libbz2-1.0 libbz2-dev libglib2.0-0 libglib2.0-dev libpng3 libfreetype6 libfreetype6-dev libjpeg62 libjpeg62-dev libjpeg-dev libpng-dev libpng12-0 libpng12-dev curl libcurl3 libmhash2 libmhash-dev libpq-dev libpq5 gettext libncurses5-dev libcurl4-gnutls-dev libjpeg-dev libpng12-dev libxml2-dev zlib1g-dev libfreetype6 libfreetype6-dev libssl-dev libcurl3 libcurl4-openssl-dev libcurl4-gnutls-dev mcrypt libcap-dev diffutils ca-certificates debian-keyring debian-archive-keyring;
do apt-get install -y $packages --force-yes;apt-get -fy install;apt-get -y autoremove; done
}

function InstallNginx()
{
echo "============================Install Nginx================================="
groupadd www
useradd -s /sbin/nologin -g www www

mkdir -p /home/wwwroot/default
chmod +w /home/wwwroot/default
mkdir -p /home/wwwlogs
chmod 777 /home/wwwlogs
touch /home/wwwlogs/nginx_error.log

cd $cur_dir
chown -R www:www /home/wwwroot/default

# nginx
cd $cur_dir
tar zxf pcre-8.12.tar.gz
cd pcre-8.12/
./configure
make && make install
cd ../

ldconfig

cd $cur_dir
tar zxf nginx-1.6.0.tar.gz
cd nginx-1.6.0/
./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-ipv6
make && make install
cd ../

ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx

cd $cur_dir
rm -f /usr/local/nginx/conf/nginx.conf
cp conf/nginx.conf /usr/local/nginx/conf/nginx.conf
cp conf/dabr.conf /usr/local/nginx/conf/dabr.conf
cp conf/discuz.conf /usr/local/nginx/conf/discuz.conf
cp conf/sablog.conf /usr/local/nginx/conf/sablog.conf
cp conf/typecho.conf /usr/local/nginx/conf/typecho.conf
cp conf/wordpress.conf /usr/local/nginx/conf/wordpress.conf
cp conf/discuzx.conf /usr/local/nginx/conf/discuzx.conf
cp conf/none.conf /usr/local/nginx/conf/none.conf
cp conf/wp2.conf /usr/local/nginx/conf/wp2.conf
cp conf/phpwind.conf /usr/local/nginx/conf/phpwind.conf
cp conf/shopex.conf /usr/local/nginx/conf/shopex.conf
cp conf/dedecms.conf /usr/local/nginx/conf/dedecms.conf
cp conf/drupal.conf /usr/local/nginx/conf/drupal.conf
cp conf/ecshop.conf /usr/local/nginx/conf/ecshop.conf
cp conf/pathinfo.conf /usr/local/nginx/conf/pathinfo.conf
}

function AddAndStartup()
{
echo "============================add nginx and php-fpm on startup============================"
echo "Download new nginx init.d file......"
wget -c http://soft.vpser.net/lnmp/ext/init.d.nginx
cp init.d.nginx /etc/init.d/nginx
chmod +x /etc/init.d/nginx
update-rc.d -f nginx defaults

cd $cur_dir
cp vhost.sh /root/vhost.sh
chmod +x /root/vhost.sh

/etc/init.d/nginx start

#add iptables firewall rules
if [ -s /sbin/iptables ]; then
/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
/sbin/iptables -I INPUT -p tcp --dport 3306 -j DROP
/sbin/iptables-save
fi
}

function CheckInstall()
{
echo "===================================== Check install ==================================="
clear
isnginx=""
ismysql=""
isphp=""
echo "Checking..."
if [ -s /usr/local/nginx/conf/nginx.conf ] && [ -s /usr/local/nginx/sbin/nginx ]; then
  echo "Nginx: OK"
  isnginx="ok"
  else
  echo "Error: /usr/local/nginx not found!!!Nginx install failed."
fi

if [ "$isnginx" = "ok" ] ; then
	echo "Install completed! enjoy it."
	netstat -ntl
else
	echo "Sorry,Failed to install !"
fi
}

InitInstall 2>&1 | tee /root/lnmp-install.log
InstallNginx 2>&1 | tee -a /root/lnmp-install.log
AddAndStartup 2>&1 | tee -a /root/lnmp-install.log
CheckInstall 2>&1 | tee -a /root/lnmp-install.log
