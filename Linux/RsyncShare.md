# RsyncShare

### 安装Rsync

```shell
yum install -y rsync
```

分为服务端跟客户端

一些参数你要自己看。

-a 归档模式，表示以递归方式传输文件，并保持所有属性，等同于-rlptgoD, -a选项后面可以跟一个 --no-OPTION 这个表示关闭-rlptgoD中的某一个例如 -a--no-l 等同于-rptgoD

-r 对子目录以递归模式处理，主要是针对目录来说的，如果单独传一个文件不需要加-r，但是传输的是目录必须加-r选项

-v 打印一些信息出来，比如速率，文件数量等

-l 保留软链结

-L 向对待常规文件一样处理软链结，如果是SRC中有软连接文件，则加上该选项后将会把软连接指向的目标文件拷贝到DST

-p 保持文件权限

-o 保持文件属主信息

-g 保持文件属组信息

-D 保持设备文件信息

-t 保持文件时间信息

--delete 删除那些DST中SRC没有的文件

--exclude=PATTERN 指定排除不需要传输的文件，等号后面跟文件名，可以是万用字符模式（如*.txt）

--exclude-from=【文件名】

--progress 在同步的过程中可以看到同步的过程状态，比如统计要同步的文件数量、同步的文件传输速度等等

-u 加上这个选项后将会把DST中比SRC还新的文件排除掉，不会覆盖

常用的有 -a -v —delete —exclude 

```shell
rsync [参数] [源目录] [目标目录]	#相当于复制命令

rsync [参数] [源目录] [主机地址:目录] #两台主机之间传输
```

### 通过配置的方式使用

```shell
vi /etc/rsyncd.conf	
port=873        #默认端口号
log file=/var/log/rsync.log
pid file=/var/run/rsyncd.pid
address=10.0.169.17     #本机IP地址

[test]  #用户名,根据目录来的，同步一个目录就要配置一个
path=/root/avi        #同步的路径地址
use chroot=false        #是否启用超级用户
max connections=4       #最大连接数
read only=no    #只读
list=true  etc     #列表
uid=root
gid=root
auth users=test #认证用户
secrets file=/etc/rsyncd.passwd #密码比对文件
hosts allow=10.0.169.46       #允许的IP地址

useradd test 
passwd test

vim /etc/rsyncd.passwd

test:123456

chmod 600 /etc/rsyncd.passwd

配置好之后，就进行下面的操作，跟命令模式是差不多的，唯一的不同就是指定刚才的配置项
rsync -av [认证用户名]@[主机地址]::[配置名]
#重启
rsync --daemon --config=/etc/rsyncd.conf

* 2 * * * rsync -av /root/avi --delete --password-file=/etc/rsync_test.passwd --exclude-from=/tmp/exclude.conf test@10.0.169.17::test 2>> /var/log/rsync/test.log   #非常实用的命令

认证不通过的话，最大的问题可能是你没有设置密码文件的权限为600
```

### 举例说明

##### service1（s1）和service2（s2）将s1上的数据手动同步到s2上

```shell
#在s1上操作以下内容
yum install -y rsync
#关闭防火墙 及安全机制
service iptables stop
setenforce 0
#第一步 打开配置文件
vim /etc/rsyncd.conf
#第二步 配置如下内容（将这些内容添加到此配置下）
port=873        #默认端口号
log file=/var/log/rsync.log
pid file=/var/run/rsyncd.pid
address=10.0.169.17     #本机IP地址

[test]  #用户名,根据目录来的，同步一个目录就要配置一个
path=/root/avi        #同步的路径地址
use chroot=false        #是否启用超级用户
max connections=4       #最大连接数
read only=no    #只读
list=true  etc     #列表
uid=root
gid=root
auth users=test #认证用户
secrets file=/etc/rsyncd.passwd #密码比对文件
hosts allow=10.0.169.46       #允许的IP地址

#第三步 创建test用户（这个步骤可以在第一步和第二步前面）
useradd test
passwd test 
(123456)
#第四步 打开配置密码比对文件，并添加用户名：密码（设置的密码）
vim /etc/rsyncd.passwd
#添加    test：123456
test:123456
#第五步 修改文件权限
chmod 600 /etc/rsyncd.passwd

#重启rsync
rsync --daemon --config=/etc/rsyncd.conf
#如果连接失败之后需要杀死前面的进程
ps aux | grep rsyncd
kill -9 
#在s2上操作如下内容

#第一步：认证
rsync -avL --delete /wwwroot/project test@123.205.60.206::test
# -avL为同步参数    /wwwroot/project 是需要将s1上的项目同步到s2的路径   test是s2上设置的用户 123.205.60.206是s2的公网IP
#第二步：如果不想输密码，可以写密码文件
vim /etc/rsyncd.test.passwd
####里面只写123456就行；
#第三步 修改密码文件权限
chmod 600 /etc/rsyncd.test.passwd
#非常实用的命令
* 2 * * * rsync -av /root/avi --delete --password-file=/etc/rsync_test.passwd --exclude-from=/tmp/exclude.conf test@10.0.169.17::test 2>> /var/log/rsync/test.log   #非常实用的命令
###如果认证失败，检查权限是否正确
```