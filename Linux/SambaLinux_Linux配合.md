# Samba简介

　　Samba是一个能让Linux系统应用Microsoft网络通讯协议的软件，而SMB是Server Message Block的缩写，即为服务器消息块 ，SMB主要是作为Microsoft的网络通讯协议，后来Samba将SMB通信协议应用到了Linux系统上，就形成了现在的Samba软件。后来微软又把 SMB 改名为 CIFS（Common Internet File System），即公共 Internet 文件系统，并且加入了许多新的功能，这样一来，使得Samba具有了更强大的功能。

　　Samba最大的功能就是可以用于Linux与windows系统直接的文件共享和打印共享，Samba既可以用于windows与Linux之间的文件共享，也可以用于Linux与Linux之间的资源共享，由于NFS(网络文件系统）可以很好的完成Linux与Linux之间的数据共享，因而 Samba较多的用在了Linux与windows之间的数据共享上面。

　　SMB是基于客户机/服务器型的协议，因而一台Samba服务器既可以充当文件共享服务器，也可以充当一个Samba的客户端，例如，一台在Linux 下已经架设好的Samba服务器，windows客户端就可以通过SMB协议共享Samba服务器上的资源文件，同时，Samba服务器也可以访问网络中 其它windows系统或者Linux系统共享出来的文件。
Samba在windows下使用的是NetBIOS协议，如果你要使用Linux下共享出来的文件，请确认你的windows系统下是否安装了NetBIOS协议。

　　组成Samba运行的有两个服务，一个是SMB，另一个是NMB；SMB是Samba 的核心启动服务，主要负责建立 Linux Samba服务器与Samba客户机之间的对话， 验证用户身份并提供对文件和打印系统的访问，只有SMB服务启动，才能实现文件的共享，监听139 TCP端口；而NMB服务是负责解析用的，类似与DNS实现的功能，NMB可以把Linux系统共享的工作组名称与其IP对应起来，如果NMB服务没有启动，就只能通过IP来访问共享文件，监听137和138 UDP端口。

　　Samba服务器可实现如下功能：WINS和DNS服务； 网络浏览服务； Linux和Windows域之间的认证和授权； UNICODE字符集和域名映射；满足CIFS协议的UNIX共享等。

##### 2、按下面的要求实做一个通过 SMB 共享 /share 目录

您的 SMB 服务器必须是 WORKGROUP 工作组的一个成员，共享名必须为 public。
用户 zxw 能够读取共享中的内容。

基本上首先是安装、配置Samba共享目录；第二是使用zxw用户能够访问共享盘；第三是防火墙和se要配置为能够访问Samba共享。

#### 3、没看出来samba装没装

[root@beiigang ~]# rpm -qa | grep -i samba
samba-winbind-clients-3.6.9-164.el6.x86_64
samba-client-3.6.9-164.el6.x86_64
samba4-libs-4.0.0-58.el6.rc4.x86_64
samba-winbind-3.6.9-164.el6.x86_64
samba-common-3.6.9-164.el6.x86_64

#### 有配置文件等

[root@beiigang ~]# find / -name samba
/etc/samba
/etc/sysconfig/samba
/usr/lib64/samba
/var/log/samba
/var/lib/samba
[root@beiigang ~]#

#### 到底装没装，装完后如下，看来是先前没装

[root@beiigang ~]# rpm -qa | grep -i samba
samba-common-3.6.23-12.el6.x86_64
samba-3.6.23-12.el6.x86_64
samba4-libs-4.0.0-58.el6.rc4.x86_64
samba-winbind-3.6.23-12.el6.x86_64
samba-winbind-clients-3.6.23-12.el6.x86_64
samba-client-3.6.23-12.el6.x86_64

#### 4、不管装没装，先删

[root@beiigang ~]# yum remove samba
Loaded plugins: fastestmirror, refresh-packagekit, security
Setting up Remove Process
No Match for argument: samba
Loading mirror speeds from cached hostfile

* base: centos.ustc.edu.cn
* extras: centos.ustc.edu.cn
* updates: centos.ustc.edu.cn
  Package(s) samba available, but not installed.
  No Packages marked for removal

#### 5、安装

[root@beiigang ~]# yum search samba

###### 查一下相关包

[root@beiigang ~]# yum -y install samba
Loaded plugins: fastestmirror, refresh-packagekit, security
Loading mirror speeds from cached hostfile
* base: mirror.bit.edu.cn
* extras: mirror.bit.edu.cn
* updates: mirror.bit.edu.cn
  Setting up Install Process
  Resolving Dependencies
  --> Running transaction check
  ---> Package samba.x86_64 0:3.6.23-12.el6 will be installed
  。。。
  Installed:
  samba.x86_64 0:3.6.23-12.el6

Dependency Updated:
libsmbclient.x86_64 0:3.6.23-12.el6 samba-client.x86_64 0:3.6.23-12.el6 samba-common.x86_64 0:3.6.23-12.el6
samba-winbind.x86_64 0:3.6.23-12.el6 samba-winbind-clients.x86_64 0:3.6.23-12.el6

Complete!

#### 6、装完后如下，多了个samba-3.6.23-12.el6.x86_64

[root@beiigang ~]# rpm -qa | grep -i samba
samba-common-3.6.23-12.el6.x86_64
samba-3.6.23-12.el6.x86_64
samba4-libs-4.0.0-58.el6.rc4.x86_64
samba-winbind-3.6.23-12.el6.x86_64
samba-winbind-clients-3.6.23-12.el6.x86_64
samba-client-3.6.23-12.el6.x86_64

#### 7、查询启动方式

[root@beiigang ~]# rpm -ql samba | grep '/etc'
/etc/logrotate.d/samba
/etc/openldap/schema
/etc/openldap/schema/samba.schema
/etc/pam.d/samba
/etc/rc.d/init.d/nmb
/etc/rc.d/init.d/smb
/etc/samba/smbusers

[root@beiigang ~]# /etc/init.d/smb start
Starting SMB services: [ OK ]
[root@beiigang ~]# service nmb start
Starting NMB services: [ OK ]

#### 设置开机自启动

chkconfig --level | grep smb
chkconfig --level 35 smb on
chkconfig --level 35 nmb on
chkconfig --level | grep smb

#### 查看端口

[root@beiigang ~]# netstat -tunpl | grep '[sn]mb'
tcp 0 0 0.0.0.0:139 0.0.0.0:* LISTEN 2071/smbd
tcp 0 0 0.0.0.0:445 0.0.0.0:* LISTEN 2071/smbd
tcp 0 0 :::139 :::* LISTEN 2071/smbd
tcp 0 0 :::445 :::* LISTEN 2071/smbd
udp 0 0 192.168.18.255:137 0.0.0.0:* 21924/nmbd
udp 0 0 192.168.18.99:137 0.0.0.0:* 21924/nmbd
udp 0 0 0.0.0.0:137 0.0.0.0:* 21924/nmbd
udp 0 0 192.168.18.255:138 0.0.0.0:* 21924/nmbd
udp 0 0 192.168.18.99:138 0.0.0.0:* 21924/nmbd
udp 0 0 0.0.0.0:138 0.0.0.0:* 21924/nmbd

#### 8、查看samba的配置文件

[root@beiigang ~]# rpm -qc samba samba-common
/etc/logrotate.d/samba
/etc/pam.d/samba
/etc/samba/smbusers
/etc/samba/lmhosts
/etc/samba/smb.conf
/etc/sysconfig/samba
[root@beiigang ~]#

#### 9、配置

[root@beiigang ~]# vi /etc/samba/smb.conf
[global]
workgroup = WORKGROUP
server string = Samba Server Version %v
public = yes

netbios name = ZXWSamba
lanman auth = yes
client lanman auth = yes


security = share


[public]
comment = Public Stuff
path = /share
public = yes
writable = yes

#### 10

[root@beiigang ~]# /etc/init.d/smb restart
Shutting down SMB services: [ OK ]
Starting SMB services: [ OK ]

[root@beiigang ~]# service nmb status
nmbd is stopped
[root@beiigang ~]# service nmb stop
Shutting down NMB services: [FAILED]
[root@beiigang ~]# service nmb start
Starting NMB services: [ OK ]
[root@beiigang ~]# service nmb stop
Shutting down NMB services: [ OK ]

#### 11、测试

[root@beiigang ~]# testparm
Load smb config files from /etc/samba/smb.conf
rlimit_max: increasing rlimit_max (1024) to minimum Windows limit (16384)
Processing section "[homes]"
Processing section "[printers]"
Processing section "[public]"
Loaded services file OK.
Server role: ROLE_STANDALONE
Press enter to see a dump of your service definitions

[global]
netbios name = ZXWSAMBA
server string = Samba Server Version %v
lanman auth = Yes
log file = /var/log/samba/log.%m
max log size = 50
idmap config * : backend = tdb
guest ok = Yes
cups options = raw

[homes]
comment = Home Directories
read only = No

[printers]
comment = All Printers
path = /var/spool/samba
guest ok = No
printable = Yes
print ok = Yes
browseable = No

[public]
comment = Public Stuff
path = /share
read only = No

#### 12、

[root@beiigang ~]# mkdir /share
[root@beiigang ~]# cd /share/
[root@beiigang share]# touch sambatest.txt
[root@beiigang share]# chown -R nobody:nobody /share/
[root@beiigang share]# chmod -R 777 /share/
[root@beiigang share]# ll
total 0
-rwxrwxrwx. 1 nobody nobody 0 Dec 2 17:34 sambatest.txt

#### 13、

[root@beiigang share]# smbclient //192.168.18.99/public
WARNING: The security=share option is deprecated
Enter root's password:
Domain=[WORKGROUP] OS=[Unix] Server=[Samba 3.6.23-12.el6]
Server not using user level security and no password supplied.
Server requested LANMAN password (share-level security) but 'client lanman auth = no' or 'client ntlmv2 auth = yes'
tree connect failed: NT_STATUS_ACCESS_DENIED
[root@beiigang share]#

#### 14、查看状态

[root@beiigang share]# smbstatus

Samba version 3.6.23-12.el6
PID Username Group Machine
-------------------------------------------------------------------
<processes do not show up in anonymous mode>


Service pid machine Connected at
-------------------------------------------------------
public 2399 test-pc Tue Dec 2 17:05:09 2014
IPC$ 2399 test-pc Tue Dec 2 17:00:56 2014

Locked files:
Pid Uid DenyMode Access R/W Oplock SharePath Name Time
--------------------------------------------------------------------------------------------------
2399 99 DENY_NONE 0x100081 RDONLY NONE /home/share . Tue Dec 2 17:10:20 2014

#### 15、

[root@beiigang ~]# vi /etc/samba/smb.conf
security = user


[root@beiigang share]# service smb restart
Shutting down SMB services: [ OK ]
Starting SMB services: [ OK ]
[root@beiigang share]# service nmb restart
Shutting down NMB services: [ OK ]
Starting NMB services: [ OK ]

#### 16、

[root@beiigang share]# smbstatus

Samba version 3.6.23-12.el6
PID Username Group Machine
-------------------------------------------------------------------
2142 zxw zxw test-pc (192.168.18.101)


Service pid machine Connected at
-------------------------------------------------------
zxw 2142 test-pc Wed Dec 3 10:20:52 2014
zxw 2142 test-pc Wed Dec 3 10:20:52 2014
public 2142 test-pc Wed Dec 3 10:20:52 2014
IPC$ 2142 test-pc Wed Dec 3 10:20:52 2014

No locked files
看来是可以了

#### 17、列出smb服务共享目录

[root@beiigang share]# smbclient -L 192.168.18.99
Enter root's password:
session setup failed: NT_STATUS_LOGON_FAILURE
这是因为登陆的用户没有成为samba服务的用户

[root@beiigang share]# smbpasswd -a zxw
New SMB password:
Retype new SMB password:
Added user zxw.

#### 18、

[root@beiigang share]# smbclient -L 192.168.18.99 -U zxw
Enter zxw's password:
Domain=[WORKGROUP] OS=[Unix] Server=[Samba 3.6.23-12.el6]

Sharename Type Comment
--------- ---- -------
homes Disk Home Directories
public Disk Public Stuff
IPC$ IPC IPC Service (Samba Server Version 3.6.23-12.el6)
zxw Disk Home Directories
Domain=[WORKGROUP] OS=[Unix] Server=[Samba 3.6.23-12.el6]

Server Comment
--------- -------
ZXWSAMBA Samba Server Version 3.6.23-12.el6

Workgroup Master
--------- -------
WORKGROUP

#### 19、连接测试，连接成功，但看不了

[root@beiigang share]# smbclient //192.168.18.99/public -U zxw
Enter zxw's password:
Domain=[WORKGROUP] OS=[Unix] Server=[Samba 3.6.23-12.el6]
smb: \> dir
NT_STATUS_ACCESS_DENIED listing \*
smb: \> ls
NT_STATUS_ACCESS_DENIED listing \*
smb: \>

#### 20、se的问题，关掉ok

[root@beiigang share]# setenforce 0
[root@beiigang share]# getenforce
Permissive
[root@beiigang share]# smbclient //192.168.18.99/public -U zxw
Enter zxw's password:
Domain=[WORKGROUP] OS=[Unix] Server=[Samba 3.6.23-12.el6]
smb: \> ls
. D 0 Tue Dec 2 17:34:59 2014
.. DR 0 Wed Dec 3 09:20:49 2014
sambatest.txt A 0 Tue Dec 2 17:34:59 2014

55119 blocks of size 131072. 25361 blocks available
smb: \>

#### 21、windows上看

