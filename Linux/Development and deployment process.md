## 比较装逼的开发上线部署流程

## 本地开发环节部署

### 软硬件环境

| 名称          | 系统环境           | 软件环境          |
| ----------- | -------------- | ------------- |
| 写代码的电脑（w1）  | windows        | sublime       |
| 开发环境虚拟机（v1） | centos-6.8-x64 | lnmp环境，git客户端 |

### 部署流程

1. 在w1上面共享一个文件夹来写项目。

2. 在v1里面安装cifs-utils、samba-client支持。

   ```shell
   yum install -y cifs-utils samba-client	#安装依赖组件
   ```

3. 在v1测试以及挂载目录

   ```shell
   smbclient //10.0.169.143/project #测试共享目录是否可以访问
   mkdir -p /wwwroot	#创建挂载文件夹
   mount -t cifs //10.0.169.143/project /wwwroot	#执行手动挂载，看看是否可以成功
   ```

4. 在v1设置开机挂载，编辑/etc/fstab这个文件

   ```ini
   //10.0.169.143/project /wwwroot cifs default 0 0 

   //10.0.169.143/project /wwwroot cifs uid=1001,gid=1001 0 0 #指定挂载磁盘的用户和用户组
   ```

5. 永久关闭防火墙和selinux

6. 在coding上面添加一个仓库，然后根据下面的链接地址生成公钥私钥，添加信任关系

   ```html
   https://coding.net/help/doc/git/ssh-key.html
   ```

7. 在v1上面安装git，然后clone这个项目，添加三个分支分别是my,develop,online其中my分支不需要推送到线上。

8. 开始修改w1上面的host记录添加域名解析。

9. 修改v1上面的虚拟机主机配置。

10. 搭建测试服务器，v1的环境要一模一样。

11. 找到测试服务器的nginx使用的用户，或者是php-fpm的用户，最后以在php文件中写下面的代码测试为准

   ```shell
   <?php
   echo exec('whami');	#以这个输出结果为准，如果是www用户执行下一步
   ```

12. 修改/etc/passwd里面的www用户的一些设置，如下

   ```ini
   www:x:1001:1001:root:/home/www:/bin/bash	#最终修改成类似这样，指定www用户的家目录，创建一个家目录，去掉/sbin/nologin,加上/bin/bash的环境执行权限
   ```

   创建家目录

   ```shell
   mkdir -p /home/www/
   mkdir -p /hom/www/.ssh/	#没有这个隐藏目录也要创建

   su www #下换到www用来执行下一步，如果涉及到权限临时切换会root，执行完再切换回来。
   ```

13. 使用www用户来生成公钥和私钥，并添加到git账户里面，参照这一步https://coding.net/help/doc/git/ssh-key.html

14. 使用www用户重新clone一份代码到开发测试服务器。

15. 在v1虚拟机系统里面的项目目录下创建两个文件如下：

   auto.sh

   ```shell
   #!/bin/bash
   cd /wwwpub/caoliu	
   git pull origin develop 2>> /var/logs/error.log
   ##注意这个文件针对的是开发测试服务器的环境，只是通过虚拟更新上去而已。
   ```

   webhooks.php

   ```shell
   <?php
   exec('./auto.sh');	#执行这一步就够了
   file_put_contents('data.txt',  date('Y-m-d H:i:s'));
   ```

16. 写好之后，上传到git上面去，第一次要手动在测试服务器进行git pull 保证获取到这两个文件，以后就会自动触发这两个文件来实现代码的自动部署。

17. 还需要在git账户上面添加webHooks的回调地址，http://xxx.php/webhooks.php



## 同步到生产环境服务器

使用rsync来同步。



