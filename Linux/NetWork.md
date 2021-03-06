# 设置NAT网卡

### 一、什么是NAT？

NAT是将一个地址域（如专用Intranet）映射到另一个地址域（如Internet）的标准方法。它是一个根据RFC1631开发的IETF标准，允许一个IP地址域以一个公有IP地址出现在Internet上。NAT可以将内部网络中的所有节点的地址转换成一个IP地址，反之亦然。它也可以应用到防火墙技术里，把个别IP地址隐藏起来不被外部发现，使外部无法直接访问内部网络设备。

### 二、NAT的工作原理

1．静态网络地址转换
① 在NAT服务器上建立静态NAT映射表。
② 当内部主机（IP地址为192.168.16.10）需要建立一条到Internet的会话连接时，首先将请求发送到NAT服务器上。NAT服务器接收到请求后，会根据接收到的请求数据包检查NAT映射表。
③ 如果已为该地址配置了静态地址转换，NAT服务器就使用相对应的内部公有IP地址，并转发数据包，否则NAT服务器不对地址进行转换，直接将数据包丢弃。 NAT服务器使用202.96.128.2来替换内部私有IP（192.168.16.10）的过程如.13所示。
④ Internet上的主机接收到数据包后进行应答（这时主机接收到202.96.128.2的请求）。
⑤ 当NAT服务器接收到来自Internet上的主机的数据包后，检查NAT映射表。如果NAT映射表存在匹配的映射项，则使用内部私有IP替换数据包的目的IP地址，并将数据包转发给内部主机。如果不存在匹配映射项则将数据包丢弃。
2．动态网络地址转换
① 当内部主机（IP地址为192.168.16.10）需要建立一条到Internet的会话连接时，首先将请求发送到NAT服务器上。NAT服务器接收到请求后，根据接收到的请求数据包检查NAT映射表。
② 如果还没有为该内部主机建立地址转换映射项，NAT服务器就会决定对该地址进行转换（建立 192.168.16.10:2320←→202.96.128.2:2320的映射项，并记录会话状态）。如果已经存在该映射项，则NAT服务器使用该 记录进行地址转换，并记录会话状态。然后NAT服务器利用转换后的地址发送数据包到Internet主机上。
③ Internet主机接收到信息后，进行应答，并将应答信息回传给NAT服务器。
④ 当NAT服务器接收到应答信息后，检查NAT映射表。如果NAT映射表存在匹配的映射项，则使用内部公有IP替换数据包的目的IP地址，并将数据包转发给内部主机。如果不存在匹配映射项则将数据包丢弃。
3．网络地址端口转换
① 当内部主机（IP地址为192.168.16.10，使用端口1235）需要与Internet上的某主机（IP地址为202.18.4.6，端口为 2350）建立连接时，首先将请求发送到NAPT服务器上。NAPT服务器接收到请求后，会根据接收到的请求数据包检查NAPT映射表。
②如果还没有为该内部主机建立地址转换映射项，NAPT服务器就会为这个传输创建一个Session，并且给这个Session分配一个端口3200，然 后改变这个数据包的源端口为3200。所以原来的192.168.16.10:1235→202.18.4.6:2350数据包经过转换后变为了 202.96.128.2:3200→202.18.4.6:2350。
③ Internet主机接收到信息后进行应答，并将应答信息回传给NAPT服务器。
④ 当NAPT服务器接收到应答信息后，检查NAPT映射表。如果NAPT映射表存在匹配的映射项，则使用内部公有IP替换数据包的目的IP地址，并将数据包转发给内部主机。如果不存在匹配映射项则将数据包丢弃。

### 三、配置网络环境

DEVICE=eth0 #网卡的设备别名
BOOTPROTO=static #网卡的IP地址是静态指定
BROADCAST=192.168.16.255 #网卡的网络地址物理机的ip
HWADDR=00:0C:29:FD:D3:29 #网卡的MAC地址
IPADDR=192.168.16.1 #网卡的IP地址 VMware Network Adapter VMnet8地址
NETMASK=255.255.255.0 #网卡的子网掩码
NETWORK=192.168.16.0 #网卡的网络地址 VMware Network Adapter VMnet8地址
ONBOOT=yes #系统启动时激活该网卡
TYPE=Ethernet #网卡的类型是以太网