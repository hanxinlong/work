# NFS

## 简介

network file system 网络文件系统，采用RPC协议进行调用。简单点说就是把搭建了NFS的服务器中的一个目录共享给其他的客户端主机使用。

## 软硬件环境

linux 主机（server 1）一台，centos 6.8_x64。

客户端主机（client 1）一台，centos 6.8_x64.

## 开始安装

1. 在s1上面安装nfs

   ```shell
   yum install -y nfs-utils	#安装nfs组件
   ```

   安装成功之后就可以使用了。

2. 编辑s1上面的nfs配置文件/etc/exports

   ```ini
   /wwwpub 10.0.169.0/24(rw,sync,no_root_squash)
   ```

   文件编写说明：

   rw ：读写；

   ro ：只读；

   sync ：同步模式，内存中数据时时写入磁盘；

   async ：不同步，把内存中数据定期写入磁盘中；

   no_root_squash ：加上这个选项后，root用户就会对共享的目录拥有至高的权限控制，就像是对本机的目录操作一样。不安全，不建议使用；

   root_squash：和上面的选项对应，root用户对共享目录的权限不高，只有普通用户的权限，即限制了root；

   all_squash：不管使用NFS的用户是谁，他的身份都会被限定成为一个指定的普通用户身份；

   anonuid/anongid ：要和root_squash 以及all_squash一同使用，用于指定使用NFS的用户限定后的uid和gid，前提是本机的/etc/passwd中存在这个uid和gid。

   介绍了上面的相关的权限选项后，再来分析一下刚刚配置的那个/etc/exports文件。其中要共享的目录为/home，信任的主机为192.168.137.0/24这个网段，权限为读写，同步，限定所有使用者，并且限定的uid和gid都为501。

3. 启动nfs服务

   ```shell
   /etc/init.d/rpcbind start|stop|restart	#开启rpc协议绑定
   /etc/init.d/nfs start|stop|start	#开启nfs服务

   exportfs -arv #修改配置之后，立即生效
   ```

4. 在客户端主机上面使用

   ```shell
   yum install -y nfs-utils #如果没有安装需要安装这个组件
   showmount -e 10.0.169.131	#查看nfs主机共享了哪些目录

   mount -t nfs 10.0.169.131:/wwwpub /mnt	#挂载nfs主机的共享目录到本地中的目录
   umount /mnt	#取消挂载
   ```

5. 在客户端主机编辑开机启动文件/etc/fstab

   ```ini
   10.0.169.131:/wwwpub /222 nfs nolock 0 0 #挂载到本机的目录，开机启动
   ```

   ```shell
   mount -a #立即生效
   ```

教程到此为止，谢谢！