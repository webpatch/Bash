#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

apt-get install -y build-essential python-dev
wget -c --no-check-certificate https://bootstrap.pypa.io/get-pip.py 
python get-pip.py
pip install uwsgi

mkdir -p /etc/uwsgi

touch /var/log/uwsgi.log
chmod 777 /var/log/uwsgi.log

cp init.d.uwsgi /etc/init.d/uwsgi
chmod +x /etc/init.d/uwsgi
update-rc.d -f uwsgi defaults

read -p "Install Python Component [Pillow & markdown & Flask] ?(y/n):" is_p
if [ "$is_p" = "y" ]; then
  apt-get install -y libjpeg-dev libjpeg62-dev libtiff4-dev zlib1g-dev libfreetype6-dev libpng12-dev
  pip install pillow
  pip install markdown
  pip install flask
fi

echo "===============Install uWSGI Success======================="
echo "install path: /usr/local/bin/uwsgi"
echo "config path: /etc/uwsgi"
echo "service: server uwsgi {start|stop|restart}"
