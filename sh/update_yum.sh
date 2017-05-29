#!/bin/bash
rm -rf /ect/yum.repos.d
read -p "请输入要切换到内网还是外网（内网输入1，阿里输入2,163输入3）" network
if [$network == 1] ;
then
	echo "你选择了内网"
	cp -r /etc/yum.repos.d.local /etc/yum.repos.d
	cd /etc/yum.repos.d
	curl -O http://10.0.8.15/yum/CentOS-Base.repo
	curl -O http://10.0.8.15/yum/epel.repo
elif [$network == 2] ;
then
	echo "你选择了阿里yum源"
	cp -r /etc/yum.repos.d.forgin /etc/yum.repos.d
	cd /etc/yum.repos.d
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
else
	echo "你选择了163yum源"
	cp -r /etc/yum.repos.d.forgin /etc/yum.repos.d
	cd /etc/yum.repos.d
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/centos.html
fi
yum clean all
yum makecache
