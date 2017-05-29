# VMwareTools安装

###### 第一步：打开虚拟机中的linux系统;然后选择虚拟机菜单上的"虚拟机"选项中的"安装VMware Tools.

```shell
#准备软件
yum install perl gcc kernel-devel tar

#在任意位置,新建一个目录 /mnt/cdrom, 用于挂载虚拟光驱(cd):
$ mkdir /mnt/cdrom
#将目录 /mnt/cdrom挂载在虚拟光驱 /dev/cdrom:
$ mount /dev/cdrom /mnt/cdrom
#再在根目录中新建一目录:
$ mkdir /cdrom
#将挂载在虚拟光驱中的目录的 /mnt/cdrom 中的VMwareTools-9.6.1-1378637.tar.gz 文件拷贝到 /cdrom/ 目录下:
$ cp /mnt/cdrom/VMwareTools-9.6.1-1378637.tar.gz  /cdrom/
#在/cdrom/目录下，tar解压缩VMwareTools-9.6.1-1378637.tar.gz
$ tar -zxf VMwareTools-9.6.1-1378637.tar.gz
#再cd到 /cdrom/ 目录下的 vmware-tools-distrib目录:
$ cd /cdrom/vmware-tools-distrib 
#并运行改目录下的vmware-install.pl文件:
$ ./vmware-install.pl
#一路按<enter>键,当运行到Would you like to enable VMware automatic kernel modules?的时候,输入 yes
#在linux中设置好后,选择虚拟机中的 "虚拟机"->"设置"
#选择"选项"选项卡:
#选择"共享文件夹",并选择"总是启用"
#点击下方的"添加"按钮,并选择window中需要共享的文件

#共享完成之后，cd /mnt/hgfs/下面没有共享目录如何解决
mount -t vmhgfs .host:/ /mnt/hgfs
#如果在终端中你还看不到共享，就手动点开linux下的目录/mnt/hgfs，去看看要是看到，就表示成功了，然后你再重新开一个终端，再次重复5的操作就可在终端下看到共享目录。如果还不行，就将操作5和6多重复几次，一般来说就没有问题了，我就是这样解决的，希望对各位同道中人有所帮助！
#然后将下列命令添加到/etc/fstab
.host:/ /mnt/hgfs vmhgfs defaults 0 0
#生效
mount -a
```

