# Nginx优化

## 配置文件组成

##### 1~3行为Main区，Nginx核心功能模块

```ini
#nginx进程数，建议设置为CPU总核心数也可以设置为auto
1 worker_processes 1;	
#全局错误日志定义类型
2 error_log logs/error.log;
#进程文件
3 pid 		logs/nginx.pid;	
```

##### 5~7行为Events区，Nginx核心功能模块

```ini
#events模块中包含nginx中所有处理连接设置
5 events	{
		#参考事件模型，use[kqueue | rtsig | epoll | /dev/poll | select | poll]; epoll模型是Linux2.6以上版本内核中的高性能网络I/O模型，如果在FreeBSD上面，就用kqueue模型
		use epoll;
		#单个进程最大连接数
 		worker_connections	65535;
}
```

##### 9行开始，Nginx Http 核心模块

```ini
http	{
include 				mime.types;
default_type 			application/octet-stream;
sendfile  				on;
keepalive_timeout		65;
server	{
  		listen		80;
  		server_name	www.caoliu.com;
		location / {
	  		root html;
	  		index index.html index.htm;
		}
		location = /50x.html	{
  			root html;
		}
	}
}
```