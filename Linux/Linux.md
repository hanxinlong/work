## Linux常用命令

### 一、目录操作篇

#### 1.切换目录

```shell
cd test 			#test目录名
cd / 				#绝对路径
cd ~				#直接输入cd进入当前用户的家目录
cd -				#回到上一次进入的目录
cd .				#当前目录
cd ..				#进入当前目录的上一级目录
```

#### 2.常见目录

##### （1）命令目录

```shell
/bin 			 #命令保存目录（普通用户就可以读取的命令）
/sbin	 		 #命令保存目录（超级用户才能使用的目录）
/usr/bin		 #系统命令（普通用户）
/usr/sbin		 #系统命令（超级用户）
```

##### （2）家目录

```shell
/root			#超级用户的家目录
/home			#普通用户家目录
```

##### （3）系统相关

```shell
/				#根目录
/boot			#启动目录
/dev			#设置文件目录
/etc			#配置文件保存目录
```

##### （4）挂载目录

```
/mnt(常用)
/media
/tmp
```
##### （5）直接写入内存的

```shell
/proc 
/sys
```

##### （6）系统相关文档说明（可变数据）

```shell
/var/log			#系统日志位置
/var/spool/mail		#系统默认邮箱位置
/var/lib/mysql		#默认安装的Mysql的库文件目录
```

#### 3、建立目录

```shell
mkdir test   #test目录名
mkdir -p  d1/d2/d3    #递归建立目录
```

#### 4、删除目录

```shell
rmdir test #test目录名 只能为空目录
rm -rf test # -r递归； -f 强制删除
```

#### 5、查看

```shell
pwd 			#查看当前目录
tree test   	#树型显示指定目录下的所有内容
ls				#显示当前目录下的所有内容
ls -l 或者 ll   #以长格式显示当前目录下的所有内容
ls -la 或者 ll -a #以长格式显示当前目录下的所有内容（包含隐藏文件）
ls -ld  test 或者 ll -d test #test目录名 查看制定目录的详细信息（大小，权限等）
```
### 二、文件和目录操作篇

#### 1、删除

```sh
rm -rf test/index.php #test目录名 index.php文件名（-r 递归； -f 强制删除）
```

#### 2、拷贝

```shell
cp 原文件名或目录名 目录位置 #拷贝文件或者目录到目标位置
cp 原文件或目录名 目标位置/新文件名或者新目录名 #拷贝文件或目录到目标位置并改名
cp *.php/test #批量复制多个文件到目标位置
cp -a test #源 目标
-a <==> -pdr(-r 复制目录、 -p 连带文件属性复制、 -d若源文件是链接文件，则复制链接属性)
```

#### 4、剪切

```shell
mv 源文件名或目录名 目标位置 #将原文件剪切到目标位置
```

#### 5、修改名称

```shell
mv 原文件名或目录名 新文件名或目录名 #将源文件名修改成新文件名
```

#### 6、修改属主和属组

```shell
chown root index.php  #root 用户名  index.php文件名或者目录名-------------->修改属主
chgrp root index.php #root用户组名 index.php文件名和目录名------------------>修改属组
chown root：han index.php #root是用户名 han是用户组名 index.php文件名或目录名  ------------->同时修改属主和属组
```

#### 7、添加，删除用户、用户组

```shell
useradd hanxinlong #添加用户hanxinlong
groupadd hanxinlong #添加用户组hanxinlong
userdel hanxinlong #删除用户hanxinlong
groupdel hanxinlong #删除用户组hanxinlong
passwd -l hanxinlong #锁定用户
passwd -u hanxinlong #解锁用户
```
## 三、文件操作

#### 1、创建空文件夹

```shell
touch index.php #index.php是文件名
#在Linux中，文件的扩展名没有意义，若要提那家扩展名知识用于标识和管理员管理系统的方便
```

#### 2、更新文件的修改时间

```shell
touch index.php #index.php已存在或者已经创建的文件名
```

#### 3、删除文件

```shell
rm -rf index.php  #index.php 文件名 （-r 递归   -f 强制删除）
```

#### 4、查看文件

##### （1）cat

```shell
cat index.php #从头到尾显示整个文件夹的内容，当文件很大时，中断无法完全显示所有内容
cat -n index.php #显示文件内容时，添加行号
```

##### （2）more

```shell
more index.php   #分屏显示文件内容（百分比）空格向下分页，b向上分页 q退出
```

##### （3）head

```shell
head index.php #显示文件头部，默认10行
head -n 100 index.php #查看文件的前100行
```

##### （4）tail

```shell
tail index.php   #显示文件尾部 默认10行
tail -n 100 index.php #查看文件的最后100行
```

##### （5）创建链接文件

```shell
ln -s a hanxinlong 
#文件名都必须写绝对路径
#删除源文件，软链接将无法打开
```

## 四、查找或者搜索

### 1、which

```shell
which ls #ls命令的名字----------->显示ls命令的位置

#给命令其别名 eg: ls1为别名 ls命令名
alias ls1='ls' 
#取消别名
unalias ls1
```

### 2、whereis

```shell
whereis ls  #查看命令的位置、安装包位置
```

### 3、find

```shell
find / -name index.php #按照文件名查找 /查找文件的位置
find / -iname index.php #按照文件名查找（不区分大小写）/查找文件的位置
find / -user hanxinlong #按用户名的查找 /查找文件的位置
find / -nouser   #查找没有属主的文件 /查找文件的位置
find / -group root #按照组名查找 /查找文件的位置 root组名

find / -size +5K #在/目录下，查找大于5K的文件
find / -size -1K -a -size +10K  #在、目录下，查找大于1K和小于10K
find / -size f  #按照文件类型查找 f:普通； d，目录； l,链接
find / -perm 755 #按照权限查找
find /etc -mmin -5 -a -type f #查找5分钟内改变过内容的文件
find /var/log/ -mtime +10 -exec rm -rf {} \; #删除10天的日志文件
```

### 4、grep

```shell
grep -i *root* /etc/passwd  #在passwd文件中查找是否有root的内容
```