# 解决克隆VMware虚拟机之后，解决网卡问题

```shell
ifconfig -a 
#查看之后默认网卡为eth1，而ls /etc/sysconfig/network-scripts/中默认为eth0
#也可以ip addr show查看网卡信息

#故障产生的原因： 
#由于克隆后的系统，虚拟机只是修改了虚拟机的名字MAC等，并在/etc/udev/rules.d/70-persistent-net.rules文件中增加了一行名为eth1的设备名

#解决办法
#1、修改/etc/udev/rules.d/70-presistent-net.rules文件
#注释有关eth0的信息
#将etn1的网卡名称修改位eth0
#记住刚才所修改网卡名称网卡的MAC地址
#2、打开/etc/sysconfig/network-scripts/ifcfg-eth0
#修改HWADDR地址为刚才记住的MAC地址
#3、重启虚拟机
#4、重启网卡，就行啦！！！
```