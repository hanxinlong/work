## SambaShare共享

### 使用Samba共享文件必备

1.在service1上面安装samba组件

```shell
yum install -y samba samba-client cifs-utils#安装组件
```

2.编辑smaba的配置文件, /etc/smaba/smb.conf

```ini
[global]					#全局的配置
        workgroup = MYGROUP	#window里面的工作组，默认是WORKGROUP
        server string = Samba Server Version %v
        security = user
        passdb backend = tdbsam
        load printers = yes
        cups options = raw
[homes]	#模块的配置
        comment = Home Directories
        browseable = no
        writable = yes
[printers]	#模块的配置
        comment = All Printers
        path = /var/spool/samba
        browseable = no
        guest ok = no
        writable = no
        printable = yes
```

[global] 定义全局的配置，workgroup用来定义工作组，相信如果你安装过windows的系统，你会对这个workgroup不陌生。一般情况下，需要我们把这里的MYGROUP改成WORKGROUP（windows默认的工作组名字）。

security = user #这里指定samba的安全等级。关于安全等级有四种：

share：用户不需要账户及密码即可登录samba服务器

user：由提供服务的samba服务器负责检查账户及密码（默认）

server：检查账户及密码的工作由另一台windows或samba服务器负责

domain：指定windows域控制服务器来验证用户的账户及密码。

passdb backend = tdbsam # passdb backend（用户后台），samba有三种用户后台：smbpasswd, tdbsam和ldapsam.

smbpasswd：该方式是使用smb工具smbpasswd给系统用户（真实用户或者虚拟用户）设置一个Samba密码，客户端就用此密码访问Samba资源。smbpasswd在/etc/samba中，有时需要手工创建该文件。

tdbsam：使用数据库文件创建用户数据库。数据库文件叫passdb.tdb，在/etc/samba中。passdb.tdb用户数据库可使用 smbpasswd -a 创建Samba用户，要创建的Samba用户必须先是系统用户。也可使用pdbedit创建Samba账户。pdbedit参数很多，列出几个主要的：

pdbedit -a username：新建Samba账户。

pdbedit -x username：删除Samba账户。

pdbedit -L：列出Samba用户列表，读取passdb.tdb数据库文件。

pdbedit -Lv：列出Samba用户列表详细信息。

pdbedit -c “[D]” -u username：暂停该Samba用户账号。

pdbedit -c “[]” -u username：恢复该Samba用户账号。

ldapsam：基于LDAP账户管理方式验证用户。首先要建立LDAP服务，设置 “passdb backend = ldapsam:ldap://LDAP Server”

load printers 和 cups options 两个参数用来设置打印机相关。

除了这些参数外，还有几个参数需要你了解：

netbios name = MYSERVER # 设置出现在网上邻居中的主机名

hosts allow = 127. 192.168.12. 192.168.13. # 用来设置允许的主机，如果在前面加 ”;” 则表示允许所有主机

log file = /var/log/samba/%m.log #定义samba的日志，这里的%m是上面的netbios name

max log size = 50 # 指定日志的最大容量，单位是K

[homes] 该部分内容共享用户自己的家目录，也就是说，当用户登录到samba服务器上时实际上是进入到了该用户的家目录，用户登陆后，共享名不是homes而是用户自己的标识符，对于单纯的文件共享的环境来说，这部分可以注视掉。

[printers] 该部分内容设置打印机共享。

### Linux上分享到Linux

#### 准备工作

共享一个目录，任何人都可以用，不属于用户名密码也可以使用。

修改全局的设置

1. ​


```ini
WORKGROUP = WORKGROUP
security = share
```

然后将[homes]改为[avi]

```ini
[homes]	#模块的配置
        comment = Home Directories
        browseable = no
        writable = yes
[avi]
        comment = share all
        path = /avi    #一般情况下将路径和模块名一样
        browseable = yes
        public = yes
        writable = no
```

启动samba共享服务

```shell
/etc/init.d/smb start
testparm	#测试配置文件
```

二、共享一个目录，使用用户名与密码登录后才可以访问，要求可读写

修改全局的配置文件

```ini
[global]
	workgroup=WORKGROUP
	security = user
	server string = hello
	passdb backend = tdbsam
	load printers = yes
	cups options = yes
```

添加一个共享模块

```ini
[bigbo]
	comment = dabo
	path = /bigbo
	browseable = yes
	public = yes
	writable = yes
```

添加一个用户

```ini
useradd bigbo	#添加系统用户
pdbedit -a bigbo	#指定系统用户samba用户
pdbedit -L	#查看smaba用户
pdbedit -Lv	#查看详情
mkdir -p /bigbo
chmod -R 777 /bigbo
```

重启samba服务

```shell
service smb restart
```

三、在linux里面使用samba客户端

```ini
yum install -y samba-client	#先安装samba客户端

smbclient //10.0.169.131/bigbo -U bigbo #进入samba命令模式
#进入之后可以使用的命令有ls，rm、mkdir、get、put，一个命令不知道参数怎么用，那么请使用help 【命令】

#挂载samba的目录
mount -t cifs //10.0.169.131/bigbo /mnt -o username=bigbo,password=123456	#手动挂载

#配置启动挂载文件/etc/fstab，编辑加入一行
//10.0.169.131/bigbo /mnt cifs username=bigbo,password=123456 0 0  
```