# Coding配置主机信任

## SSH公钥

### 1、打开xShell命令行中端，输入以下命令

```shell
ssh-keygen -t rsa -b 4096 -C "1624495727@qq.com"
#Enter file in which to save the key (/Users/you/.ssh/id_rsa): [Press enter]  // 推荐使用默认地址,如果使用非默认地址需要配置 .ssh/config
```

### 2、在Coding.net添加公钥

本地打开 id_rsa.pub 文件（或执行 $cat id_rsa.pub ），复制其中全部内容，添加到账户[“SSH 公钥”页面](https://coding.net/user/account/setting/keys) 中，公钥名称可以随意起名字。完成后点击“添加”，然后输入密码或动态码即可添加完成。

### 3、测试是否配置成功

```shell
ssh -T git@git.coding.net
```

### 4、非默认路径执行以下代码

```shell
#在vim /root/.ssh/config中添加
Host git.coding.net
User 1624495727@qq.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/id_rsa_shopping  // 生成的非默认地址的公钥存放点
```

# 配置完毕

