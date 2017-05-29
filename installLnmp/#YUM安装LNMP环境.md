# YUM安装LNMP环境

## 软件环境

linux 6.0 64位

nginx	1.1

mysql 5.5

php 7



## 安装流程

1. 准备工作

   ```shell
   setenforce 0 #关闭selinux
   service iptables stop #关闭防火墙
   #配置好yum源地址
   ```

2. 安装可能需要的依赖

   ```shell
   yum -y install ntp make openssl openssl-devel pcre pcre-devel libpng libpng-devel libjpeg-6b libjpeg-devel-6b freetype freetype-devel gd gd-devel zlib zlib-devel  gcc gcc-c++ libXpm libXpm-devel ncurses ncurses-devel libmcrypt libmcrypt-devel libxml2 libxml2-devel imake autoconf automake screen sysstat compat-libstdc++-33 curl curl-devel
   ```

3. 安装nginx

   ```shell
   yum install -y nginx	#安装nginx
   ```

4. 安装mysql

   ```shell
   yum -y install mysql mysql-server mysql-devel
   ```

5. 安装php

   ```shell
   yum -y install php php-mysql gd php-gd gd-devel php-xml php-common php-mbstring php-ldap php-pear php-xmlrpc php-imap php-fpm
   ```

6. 配置nginx

   ​