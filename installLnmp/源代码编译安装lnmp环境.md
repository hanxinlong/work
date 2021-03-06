# 源代码编译安装lnmp环境

## 准备工作

```shell
#关闭防火墙
setenforce 0
service iptables stop
##########################开始安装#################################
mdkir -p /lnmp/src	#创建需要安装的软件包目录
#下载需要安装的软件包到这个目录
boost_1_59_0.tar.gz   libmcrypt-2.5.8.tar.gz  pcre-8.39.tar.gz
cmake-2.8.7.tar.gz    mysql-5.5.28.tar.gz     php-7.0.7.tar.bz2
gd-2.0.36RC1.tar.gz   nginx-1.11.5.tar.gz
openssl-1.1.0b.tar.gz

setenforce 0	#关闭selinux
service iptables stop #关闭防火墙

#安装可能需要用到的依赖包
yum install -y make apr* autoconf automake curl curl-devel gcc gcc-c++  cmake  gtk+-devel zlib-devel openssl openssl-devel pcre-devel gd kernel keyutils patch perl kernel-headers compat* cpp glibc libgomp libstdc++-devel keyutils-libs-devel  libarchive libsepol-devel libselinux-devel krb5-devel libXpm* freetype freetype-devel freetype* fontconfig fontconfig-devel libjpeg* libpng* php-common php-gd gettext gettext-devel ncurses* libtool* libxml2 libxml2-devel patch policycoreutils bison vim wget

```

## 源码安装几个可能用到的依赖

1. 安装cmake ，因为5.5以后的mysql需要用到cmake进行编译

   ```shell
   cd /lnmp/src/
   https://cmake.org/files/v2.8/cmake-2.8.7.tar.gz
   tar -zxvf cmake-2.8.7.tar.gz
   cd  /lnmp/src/cmake-2.8.7
   ./configure --prefix=/usr/local/cmake
   make #编译
   make install #安装
   vim /etc/profile 在path路径中增加cmake执行文件路径
   export PATH=$PATH:/usr/local/cmake/bin:/usr/local/mysql/bin
   source /etc/profile使配置立即生效
   ```

2. 安装pcre

   ```shell
   cd /lnmp/src/
   https://sourceforge.net/projects/pcre/files/pcre/8.39/pcre-8.39.tar.gz
   tar zxvf pcre-8.39.tar.gz
   cd pcre-8.39
   ./configure --prefix=/usr/local/pcre 
   make && make install
   ```

3. 安装libcrypt

   ```shell
   cd /lnmp/src/
   tar -zxvf libmcrypt-2.5.8.tar.gz
   cd /lnmp/src/libmcrypt-2.5.8
   ./configure #配置
   make #编译
   make install #安装
   ```

4. 安装GD库文件

   ```shell
   cd /lnmp/src/
   tar zxvf gd-2.0.36RC1.tar.gz
   cd gd-2.0.36RC1
   ./configure --enable-m4_pattern_allow --prefix=/usr/local/gd --with-jpeg=/usr/lib --with-png=/usr/lib --with-xpm=/usr/lib --with-freetype=/usr/lib --with-fontconfig=/usr/lib 
   make #编译
   make install #安装
   ```

## 安装mysql

```shell
groupadd mysql #添加mysql组
useradd -g mysql mysql -s /sbin/nologin #创建用户mysql并加入到mysql组，不允许mysql用户直接登录系统
mkdir -p /var/mysql/data #创建MySQL数据库存放目录
chown -R mysql:mysql /var/mysql/data #设置MySQL数据库目录权限
cd /lnmp/src
tar -zxvf mysql-5.5.28.tar.gz #解压

cd mysql-5.5.28
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 -DENABLED_LOCAL_INFILE=1 \
-DMYSQL_DATADIR=/var/mysql/data \
-DMYSQL_USER=mysql -DMYSQL_TCP_PORT=3306
#运行下面命令
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DENABLED_LOCAL_INFILE=1 -DMYSQL_DATADIR=/var/mysql/data -DMYSQL_USER=mysql -DMYSQL_TCP_PORT=3306

make
make install
cd /usr/local/mysql

cp ./support-files/my-huge.cnf /etc/my.cnf #拷贝配置文件（注意：如果/etc目录下面默认有一个my.cnf，直接覆盖即可）注意：：一定要进去查看是否复制成功，成功之后在执行下面这一条，添加，一定是添加
vim /etc/my.cnf #编辑配置文件,在 [mysqld] 部分增加
datadir = /var/mysql/data #添加MySQL数据库路径
cd /usr/local/mysql
./scripts/mysql_install_db --user=mysql #生成mysql系统数据库
cp ./support-files/mysql.server /etc/rc.d/init.d/mysqld #把Mysql加入系统启动
chmod 755 /etc/init.d/mysqld #增加执行权限
chkconfig mysqld on #加入开机启动
vim /etc/rc.d/init.d/mysqld #编辑
basedir=/usr/local/mysql #MySQL程序安装路径
datadir=/var/mysql/data #MySQl数据库存放目录
service mysqld start #启动,可能无法写入pid文件，注意将mysql用户权限加入至/usr/local/mysql，执行下面这一条即可,然后重新启动，查看是否成功
chown -R mysql:mysql /usr/local/mysql

vim /etc/profile #把mysql服务加入系统环境变量：在最后添加下面这一行
export PATH=$PATH:/usr/local/cmake/bin:/usr/local/mysql/bin
source /etc/profile #使配置立即生效

mkdir /var/lib/mysql #创建目录
ln -s /tmp/mysql.sock /var/lib/mysql/mysql.sock #添加软链接
mysql_secure_installation #先回车，设置Mysql密码，根据提示按Y 再回车输入2次密码
#下面根据提示输入
/usr/local/mysql/bin/mysqladmin -u root -p password "123456" #或者直接修改密码
到此，mysql安装完成！
```

## 安装nginx

```shell
cd /lnmp/src
tar -zxvf nginx-1.11.5.tar.gz
groupadd www #添加www组
useradd -g www www -s /sbin/nologin #创建nginx运行账户www并加入到www组，不允许www用户直接登录系统
cd /lnmp/src/
tar -zxvf openssl-1.1.0b.tar.gz	#解压就可以了，不需要安装
cd nginx-1.11.5
./configure --prefix=/usr/local/nginx --without-http_memcached_module --user=www --group=www   --with-http_stub_status_module --with-openssl=/lnmp/src/openssl-1.1.0b --with-pcre=/lnmp/src/pcre-8.39   --with-http_ssl_module
注意:--with-pcre=/usr/local/src/pcre-8.39指向的是源码包解压的路径，而不是安装的路径，否则会报错
如果是家目录~ 就要从根目录root进入制定全路径
make
make install
/usr/local/nginx/sbin/nginx #启动nginx
设置nginx开启启动
vim /etc/rc.d/init.d/nginx #编辑启动文件添加下面内容
=======================================================
#!/bin/bash
# nginx Startup script for the Nginx HTTP Server
# it is v.0.0.2 version.
# chkconfig: - 85 15
# description: Nginx is a high-performance web and proxy server.
# It has a lot of features, but it's not for everyone.
# processname: nginx
# pidfile: /var/run/nginx.pid
# config: /usr/local/nginx/conf/nginx.conf
nginxd=/usr/local/nginx/sbin/nginx
nginx_config=/usr/local/nginx/conf/nginx.conf
nginx_pid=/usr/local/nginx/logs/nginx.pid
RETVAL=0
prog="nginx"
# Source function library.
. /etc/rc.d/init.d/functions
# Source networking configuration.
. /etc/sysconfig/network
# Check that networking is up.
[ ${NETWORKING} = "no" ] && exit 0
[ -x $nginxd ] || exit 0
# Start nginx daemons functions.
start() {
if [ -e $nginx_pid ];then
echo "nginx already running...."
exit 1
fi
echo -n $"Starting $prog: "
daemon $nginxd -c ${nginx_config}
RETVAL=$?
echo
[ $RETVAL = 0 ] && touch /var/lock/subsys/nginx
return $RETVAL
}
# Stop nginxc daemons functions.
stop() {
echo -n $"Stopping $prog: "
killproc $nginxd
RETVAL=$?
echo
[ $RETVAL = 0 ] && rm -f /var/lock/subsys/nginx /usr/local/nginx/logs/nginx.pid
}
reload() {
echo -n $"Reloading $prog: "
#kill -HUP `cat ${nginx_pid}`
killproc $nginxd -HUP
RETVAL=$?
echo
}
# See how we were called.
case "$1" in
start)
start
;;
stop)
stop
;;
reload)
reload
;;
restart)
stop
start
;;
status)
status $prog
RETVAL=$?
;;
*)
echo $"Usage: $prog {start|stop|restart|reload|status|help}"
exit 1
esac
exit $RETVAL
=======================================================
:wq! #保存退出
chmod 775 /etc/rc.d/init.d/nginx #赋予文件执行权限
chkconfig nginx on #设置开机启动
/etc/rc.d/init.d/nginx restart #重新启动Nginx
service nginx restart
```

## 安装PHP

```shell
cd /lnmp/src
tar -jxvf php-7.0.7.tar.bz2
cd php-7.0.7
./configure --prefix=/usr/local/php7 --with-config-file-path=/usr/local/php7/etc  --with-mysqli=/usr/local/mysql/bin/mysql_config --enable-mysqlnd --with-mysql-sock=/usr/local/mysql/mysql.sock --with-gd --with-iconv --with-zlib --enable-xml --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --enable-mbregex --enable-fpm --enable-mbstring --enable-ftp --enable-gd-native-ttf --with-openssl --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --without-pear --with-gettext --enable-session --with-mcrypt --with-curl --with-jpeg-dir --with-freetype-dir   --with-pdo-mysql=/usr/local/mysql/

make #编译,，若遇到make: *** [ext/fileinfo/libmagic/apprentice.lo] 错误 ，这加参数–-disable-fileinfo
make install #安装

cp php.ini-production /usr/local/php7/etc/php.ini #复制php配置文件到安装目录
rm -rf /etc/php.ini #删除系统自带配置文件
ln -s /usr/local/php7/etc/php.ini /etc/php.ini #添加软链接

cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
cp -r /usr/local/php7/etc/php-fpm.conf.default /usr/local/php7/etc/php-fpm.conf #拷贝模板文件为php-fpm配置文件
cp /usr/local/php7/etc/php-fpm.d/www.conf.default /usr/local/php7/etc/php-fpm.d/www.conf  

vim /usr/local/php7/etc/php-fpm.d/www.conf  #编辑

user = www #设置php-fpm运行账号为www
group = www #设置php-fpm运行组为www

vim /usr/local/php7/etc/php-fpm.conf
pid = run/php-fpm.pid #取消前面的分号

设置 php-fpm 开机启动
cp /lnmp/src/php-7.0.7/sapi/fpm/init.d.php-fpm /etc/rc.d/init.d/php-fpm #拷贝php-fpm到启动目录
chmod +x /etc/rc.d/init.d/php-fpm #添加执行权限
chkconfig php-fpm on #设置开机启动
vim /usr/local/php7/etc/php.ini #编辑配置文件
找到：disable_functions =
修改为：disable_functions = passthru,exec,system,chroot,scandir,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,escapeshellcmd,dll,popen,disk_free_space,checkdnsrr,checkdnsrr,getservbyname,getservbyport,disk_total_space,posix_ctermid,posix_get_last_error,posix_getcwd, posix_getegid,posix_geteuid,posix_getgid, posix_getgrgid,posix_getgrnam,posix_getgroups,posix_getlogin,posix_getpgid,posix_getpgrp,posix_getpid, posix_getppid,posix_getpwnam,posix_getpwuid, posix_getrlimit, posix_getsid,posix_getuid,posix_isatty, posix_kill,posix_mkfifo,posix_setegid,posix_seteuid,posix_setgid,posix_setpgid,posix_setsid,posix_setuid,posix_strerror,posix_times,posix_ttyname,posix_uname


列出PHP可以禁用的函数，如果某些程序需要用到这个函数，可以删除，取消禁用

找到：;date.timezone =
修改为：date.timezone = PRC #设置时区
找到：expose_php = On
修改为：expose_php = OFF #禁止显示php版本的信息
找到：short_open_tag = Off
修改为：short_open_tag = ON #支持php短标签

vim /usr/local/nginx/conf/nginx.conf

location / {
    root /data/www;
    index index.php index.html index.htm;
}
location ~ \.php$ {
    root /data/www;
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
}

mkdir -p /data/www
chown www:www /data/www/ -R #设置目录所有者
chmod 700 /data/www -R #设置目录权限
	
服务器相关操作命令
service nginx restart #重启nginx
service mysqld restart #重启mysql
service php-fpm restart


/usr/local/php/sbin/php-fpm #启动php-fpm
/etc/rc.d/init.d/php-fpm restart #重启php-fpm
/etc/rc.d/init.d/php-fpm stop #停止php-fpm
/etc/rc.d/init.d/php-fpm start #启动php-fpm
```