# ShellScript

## shell

打开文本编辑器(可以使用vi/vim命令来创建文件)，新建一个文件test.sh，扩展名为sh（sh代表shell），扩展名并不影响脚本执行，见名知意就好，如果你用php写shell 脚本，扩展名就用php好了。

```ini
#!/bin/bash
echo "Hello World!"

#"#!" 是一个约定的标记，它告诉系统这个脚本需要什么解释器来执行，即使用哪一种Shell。
#echo命令用于向窗口输出文本。 
```

##### 1、作为可执行程序

```ini
chmod +x ./test.sh  #使脚本具有执行权限
./test.sh  #执行脚本
```

注意，一定要写成./test.sh，而不是test.sh，运行其它二进制的程序也一样，直接写test.sh，linux系统会去PATH里寻找有没有叫test.sh的，而只有/bin, /sbin, /usr/bin，/usr/sbin等在PATH里，你的当前目录通常不在PATH里，所以写成test.sh是会找不到命令的，要用./test.sh告诉系统说，就在当前目录找。 

## Shell变量

### 变量

注意，变量名和等号之间不能有空格，这可能和你熟悉的所有编程语言都不一样。同时，变量名的命名须遵循如下规则：

1. 首个字符必须为字母（a-z，A-Z）。
2. 中间不能有空格，可以使用下划线（_）。
3. 不能使用标点符号。
4. 不能使用bash里的关键字（可用help命令查看保留关键字）。

### 使用变量

```ini
your_name="qinjx"
echo $your_name
echo ${your_name}
#变量名外面的花括号是可选的，加不加都行
```

### 只读变量

```ini
readonly myUrl
#readonly使用 readonly 命令可以将变量定义为只读变量，只读变量的值不能被改变。
```

### 删除变量

```ini
unset variable_name
```

### 变量类型

```ini
#运行shell时，会同时存在三种变量：

    1) 局部变量 局部变量在脚本或命令中定义，仅在当前shell实例中有效，其他shell启动的程序不能访问局部变量。
    2) 环境变量 所有的程序，包括shell启动的程序，都能访问环境变量，有些程序需要环境变量来保证其正常运行。必要的时候shell脚本也可以定义环境变量。
    3) shell变量 shell变量是由shell程序设置的特殊变量。shell变量中有一部分是环境变量，有一部分是局部变量，这些变量保证了shell的正常运行
```

### Shell字符串

#### 单引号

```ini
str='this is a string'
#单引号字符串的限制：
    #单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的；
    #单引号字串中不能出现单引号（对单引号使用转义符后也不行）。
```

#### 双引号

```ini
your_name='qinjx'
str="Hello, I know your are \"$your_name\"! \n"
 #双引号的优点：
   # 双引号里可以有变量
   # 双引号里可以出现转义字符
```

#### 拼接字符串

```ini
your_name="qinjx"
greeting="hello, "$your_name" !"
greeting_1="hello, ${your_name} !"
echo $greeting $greeting_1
```

#### 获取字符串长度

```ini
string="abcd"
echo ${#string} #输出 4
```

#### 提取子字符串

```ini
string="runoob is a great site"
echo ${string:1:4} # 输出 unoo
```

#### 查找字符串

```ini
string="runoob is a great company"
echo `expr index "$string" is`  # 输出 8

#注意： 以上脚本中 "`" 是反引号，而不是单引号 "'"，不要看错了哦。
```

### Shell 数组

### 数组格式

```ini
array_name=(value0 value1 value2 value3)
```