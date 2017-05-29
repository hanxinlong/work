# UpdateYum

### 阿里云YUM源

```shell
cd /etc/
mv /etc/yum.repos.d /etc/yum.repos.d.backup4comex
mkdir /etc/yum.repos.d
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

yum clean all
yum makecache
```

### 千锋YUM源

```shell
mv /etc/yum.repos.d /etc/yum.repos.d.bak
mkdir /etc/yum.repos.d && cd /etc/yum.repos.d
curl -O http://10.0.8.15/yum/CentOS-Base.repo
curl -O http://10.0.8.15/yum/epel.repo
yum clean all && yum makecache	#清楚缓存并且生成缓存
```

## 切换内外网脚本

```ini
#！/bin/bash
rm -rf /ect/yum.repos.d
read -p "请输入要切换到内网还是外网（内网输入1，阿里yum源输入2，163yum源输入3）" network
if [$network == 1]
then
	echo "你选择了内网"
	cp -r /etc/yum.repos.d.local /etc/yum.repos.d
	cd /etc/yum.repos.d
	curl -O http://10.0.8.15/yum/CentOS-Base.repo
	curl -O http://10.0.8.15/yum/epel.repo
elif [$network == 2]
then
	echo "你选择了阿里yum源"
	cp -r /etc/yum.repos.d.forgin /etc/yum.repos.d
	cd /etc/yum.repos.d
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
else
	echo "你选择了163yum源"
	cp -r /etc/yum.repos.d.forgin /etc/yum.repos.d
	cd /etc/yum.repos.d
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/centos.html
fi

yum clean all
yum makecache
```

