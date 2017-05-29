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

### Windows上分享到Linux

#### 准备工作

#### 第一步、同步工作组

1. 不管使用的是什么版本的Windows操作系统，首先要保证联网的各计算机的工作组名称一致，要查看或更改计算机的工作组、计算机名等信息，请右键单击“计算机”，选择“属性”。

   若相关信息需要更改，请在“计算机名称、域和工作组设置”一栏，单击“更改设置”。

 ![20140625023424552](C:\Users\Administrator\Desktop\20140625023424552.jpg)

2.单击“更改”。

![img](http://img.9553.com/upload/info/2014/0625/20140625023433802.jpg)

3.输入合适的计算机名/工作组名后，按“确定”。

![img](http://img.9553.com/upload/info/2014/0625/20140625023442577.jpg)

4.这一步操作完成后，请重启计算机使更改生效。

#### 第二步、更改Windows7的相关设置

打开“控制面板网络和Internet网络和共享中心高级共享设置”，启用“网络发现”、“文件和打印机共享”、“公用文件夹共享”;“密码保护的共享”部分则请选择“关闭密码保护共享”。

![img](http://img.9553.com/upload/info/2014/0625/20140625023528137.jpg)

#### 第三步、共享对象设置

现在我们转向共享对象，最直接的方法就是将需要共享的文件/文件夹直接拖拽至公共文件夹中。如果需要共享某些特定的Windows7文件夹，请右键点击此文件夹，选择“属性”。

![img](http://img.9553.com/upload/info/2014/0625/20140625023550515.jpg)

win7共享文件夹无法访问解决方法：点击“共享”标签，单击“高级共享”按钮。

![img](http://img.9553.com/upload/info/2014/0625/20140625023613131.jpg)

勾选“共享此文件夹”后，单击“应用”、“确定”退出。

![img](http://img.9553.com/upload/info/2014/0625/20140625023624240.jpg)

如果某文件夹被设为共享，它的所有子文件夹将默认被设为共享，在前面第二步中，我们已经关闭了密码保护共享，所以现在要来对共享文件夹的安全权限作一些更改。右键点击将要共享的文件夹，选择“属性”。在“安全”页上，单击“编辑”。

![img](http://img.9553.com/upload/info/2014/0625/20140625023634561.jpg)

接着，请按一下“添加”按钮。

![img](http://img.9553.com/upload/info/2014/0625/20140625023644447.jpg)

键入Everyone后一路按“确定”退出。

![img](http://img.9553.com/upload/info/2014/0625/20140625023653561.jpg)

#### 第四步、防火墙设置

打开“控制面板/系统和安全/Windows防火墙”检查一下防火墙设置，确保“文件和打印机共享”是允许的状态。

![img](http://img.9553.com/upload/info/2014/0625/20140625023705984.jpg)

#### 第五步、查看共享文件

依次打开“控制面板”〉“网络和Internet”〉“查看网络计算机和设备”〉“(相应的计算机/设备名称)”即可。特别提醒：这个方法确实能帮助共享文件，但由于关闭密码访问功能，网络安全性会降低哦。

#### 第六步，创建需要共享的文件

然后在文件夹上面点击右键->属性->共享

#### 第七步：部署流程

1. 在w1(windows)上面共享一个文件夹来写项目。

2. 在v1测试以及挂载目录

   ```shell
   smbclient //w1的ip/project #测试共享目录是否可以访问
   mkdir -p /wwwroot	#创建挂载文件夹
   mount -t cifs //w1的ip/project /wwwroot	#执行手动挂载，看看是否可以成功
   ```

3. 在v1设置开机挂载，编辑/etc/fstab这个文件

   ```ini
   //10.0.169.143/project /wwwroot cifs default 0 0 

   //10.0.169.143/project /wwwroot cifs uid=1001,gid=1001 0 0 #指定挂载磁盘的用户和用户组
   ```

4. 永久关闭防火墙和selinux



