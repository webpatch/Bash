#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo --------------- Install ---------------
read -p "Enter share path:" pathname
read -p "Enter user name:" username

if id $username &>/dev/null;then
	echo 'user check ok!' 
else
	echo 'user no exist!'
	exit 1
fi

rm -f /etc/samba/smb.conf

mkdir $pathname
chmod 777 $pathname 

apt-get install -y samba

sed -i "s/#   security = user/security = user/" /etc/samba/smb.conf

cat << EOF >>/etc/samba/smb.conf
display charset = UTF-8
unix charset = UTF-8
dos charset = cp936
[public]
path = $pathname
valid users = $username
public = yes
writable = yes
printable = no
EOF

smbpasswd -a $username
echo ------------- Restart ------------
/etc/init.d/samba restart
