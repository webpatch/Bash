#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

apt-get install -y build-essential python-dev
wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py 
python get-pip.py
pip install uwsgi

read -p "Install Python Component [Pillow & markdown & Flask] ?(y/n):" is_p
if [ "$is_p" = "y" ]; then
  apt-get install -y libtiff4-dev libjpeg62-dev zlib1g-dev libfreetype6-dev libpng12-dev
  pip install pillow
  pip install markdown
  pip install flask
fi
