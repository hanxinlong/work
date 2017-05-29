

# Install Apache

### 安装软件之源码安装

#### 源代码安装三步走

1.   ./configure 配置
2.   make 编译
3.   make install 安装

### Apache安装前工具准备

1.安装gcc，C语言的编译器

```shell
yum install -y gcc   #安装c语言的编译环境
```

2.安装C++的编译环境

```shell
yum -y install gcc gcc-c++ libstdc++-devel   #安装C++的编译环境
```

3.安装解压工具

```shell
yum install -y unzip   #安装解压工具
yum install -y tar     #安装解压工具
```

### Apache安装前软件准备

#### 安装apr

```shell
wget -c http://apache.fayea.com//apr/apr-1.5.2.tar.gz
tar -zxvf apr-1.5.2.tar.gz	#解压
cd apr-1.5.2
./configure --prefix=/usr/local/apr	#配置
make	#编译
make install	#安装
```

#### 安装apr-util

```shell
wget -c http://apache.fayea.com//apr/apr-util-1.5.4.tar.gz
tar -zxvf apr-util-1.5.4.tar.gz
cd apr-util-1.5.4
./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr && make && make install
```

#### 安装pcre

```shell
wget -c https://sourceforge.net/projects/pcre/files/pcre/8.39/pcre-8.39.zip
unzip pcre-8.39.zip
cd pcre-8.39
./configure --prefix=/usr/local/pcre && make && make install
```

## 下载并安装Apache（httpd）

```shell
#下载并安装httpd 安装apache
wget -c http://mirrors.hust.edu.cn/apache/httpd/httpd-2.4.25.tar.gz
tar -zxvf httpd-2.4.25.tar.gz	#解压
cd httpd-2.4.25	#进入目录
./configure --prefix=/usr/local/apache2 --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --with-pcre=/usr/local/pcre
make
make install
```

## 配置虚拟环境

```shell
cd /usr/local/apache2/conf
vim httpd.conf
#在文件的ServerRoot ".usr/local/apache2"后面添加 ServerName localhost
#关闭虚拟机的防火墙
#关闭开启防火墙服务(不建议永久关闭防火墙)：
#永久生效：chkconfig iptables on/off(重启生效)
#即时生效：service iptables start/stop(重启失效)
apachectl start	#启动apache
```

## 安装完毕！！！

