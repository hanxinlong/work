## memcache 基于内存的缓存

## 安装memcached

1. 安装所需要的依赖

   ```shell
   yum install -y libevent libevent-devel
   ```

2. 准备需要的memcached的安装包

   ```shell
   tar -zxvf memcached-1.4.33.tar.gz
   cd memcached-1.4.33
   ./configure --prefix=/usr/local/memcached --enable-64bit && make && make install #以64位的模式安装。
   ```

3. 启动memcahed

   ```shell
   cd memcached/bin
   ./memcached -u www -d 	#后台进行启动运行
   ```

## php使用memcached

安装libmemcached的扩展

```shell
tar -zxvf libmemcached-1.0.18.tar.gz
cd libmemcached-1.0.18	#进入目录
./configure --prefix=/usr/local/libmemcached --with-memcached	#编译
make	#准备安装
make install	#安装
```

安装php7-memcached

```shell
tar php
cd php-memcached-php7	#进入目录
/usr/local/php7/bin/phpize	#安装php扩展需要这个命令来解压
./configure --with-php-config=/usr/local/php7/bin/php-config --with-libmemcached-dir=/usr/local/libmemcached/ --disable-memcached-sasl	#编译，指定php-config的位置，指定libmemcached的目录，关闭memcached-sasl选项
make && make install	#安装

/usr/local/php7/lib/php/extensions/no-debug-non-zts-20151012/memcached.so #安装后的memcached的扩展,请这个地址添加到php.ini配置文件中，然后重启php-fpm
service php-fpm restart
```



## memcached装逼指南

Memcached是一个自由开源的，高性能，分布式内存对象缓存系统。

Memcached是以LiveJournal旗下Danga Interactive公司的Brad Fitzpatric为首开发的一款软件。现在已成为mixi、hatena、Facebook、Vox、LiveJournal等众多服务中提高Web应用扩展性的重要因素。

Memcached是一种基于内存的key-value存储，用来存储小块的任意数据（字符串、对象）。这些数据可以是数据库调用、API调用或者是页面渲染的结果。

Memcached简洁而强大。它的简洁设计便于快速开发，减轻开发难度，解决了大数据量缓存的很多问题。它的API兼容大部分流行的开发语言。

本质上，它是一个简洁的key-value存储系统。

一般的使用目的是，通过缓存数据库查询结果，减少数据库访问次数，以提高动态Web应用的速度、提高可扩展性。