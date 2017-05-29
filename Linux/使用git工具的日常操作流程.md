# Git版本控制工具操作流程

### Git背景

Git最初由Linux Torvalds编写，用于Linux内核开发的版本控制工具。

### Git优点

1. 更方便的Merge
2. 更方便管理
3. 更健壮的系统
4. 对网络的依赖性更低
5. 更少的‘仓库污染'

### Git和Svn的区别

1. git是分布式，SVN不是
2. Git把内容按元数据方式存储，而SVN是按文件存储
3. Git分支和SVN的分支不同
4. Git没有一个全局的版本号，而SVN有
5. Git的内容完整性要优于SVN

### Git和CVS的区别

1. 分支更快，更容易
2. 支持离线工作，本地提交可以稍后可以提交到服务器上
3. Git提交都是原子的，且是整个项目范围的，而不像CVS中一样是对每个文件的
4. Git中的每个工作树都包含一个具有完整项目历史的版本仓库
5. 没有哪一个Git仓库天生比其他仓库更重要

### Git、CVS、SVN综合比较

http://www.cnblogs.com/baby-blue/p/6130562.html

1. 版本模型（Repository Model）:描述了多个源码版本库副本间的关系，有客户端/器和分布式的两种模式
2. 并发模式(Concurrency model):描述了当同时对统一工作副本、文件进行更改时或者编辑时，如何管理这种冲突以避免禅城无意义的数据
3. 历史模式(History model):描述了如何在版本库中存储文件的更改信息，有快照和改变及两种模式；在快照模式下，版本库会分别存贮更改繁盛前后的工作副本；而在改变集模式下，版本库除了保存更改反升后的改变信息
4. 变更范围(Scope of change):描述了版本编号是针对单个文件还是整个目录树
5. 网络协议(Network protocols):描述了多个版本库进行同步是采用的网络协议
6. 原子提交性(Atomic commit):描述了在提交更改时，能否保证所有更改要么全部提交或者合并，要么不会发生任何改变
7. 部分克隆(Partial checkout/clone):是否支持只拷贝版本库中特定的子目录

| **名称** | **版本库模型**     | **并发模式**                                 | **历史模式**               | **变更范围** | **网络协议**                                 | **原子提交性** | **部分克隆** |
| ------ | ------------- | ---------------------------------------- | ---------------------- | -------- | ---------------------------------------- | --------- | -------- |
| CVS    | Client-server | Merge                                    | Changeset              | File     | Pserver,ssh                              | No        | Yes      |
| SVN    | Client-server | 3-way merge, recursivemerge, octopus merge | Changeset and Snapshot | Tree     | custom (svn), custom (svn) over ssh,HTTP and SSL (usingWebDAV) | Yes       | Yes      |
| Git    | Distributed   | Merge or lock                            | Snapshot               | Tree     | custom, custom over ssh, rsync,HTTP/HTTPS, email, bundles | Yes       | No       |

### Git工作的一般流程

#### 简单的来说可以分为五步

1. 获得一个Git管理的工作区

   ​	自己初始化一个仓库

   ​	从远程仓库获得工作目录

2. 添加修改推送

3. 分支

4. 拉取别人的提交

5. 处理冲突

#### 流程详解

##### 获得一个Git管理的工作区

使用Git开始工作，首先需要一个Git管理的工作区，这个工作区可以是自己init创建的，也可以是从远程仓库clone下来的

```shell
##新建一个目录作为工作目录
mkdir git_demo
cd git_demo
##在本地初始化git仓库
git init
```

这时，我们已经创建了一个本地仓库，但是，一般我们和其他人共同开发一个项目，则需要添加一个远程仓库。现在假设我已经才github上面建立了一个叫做git_demo的空仓库，现在需要将其添加到本地仓库。

```shell
##添加一个叫origin的远程仓库
git remote add origin git@github.com:hanxinlong/git_demo.git
vim README.md
git commit -m 'first commit with'
##推送到远程仓库
git push -u origin master
```

##### 从远程仓库获得工作目录

大多数时候，我们没有机会从头init仓库，而是远程仓库直接克隆项目

```shell
##把刚才推送上去的仓库clone下来
git clone git@github.com:hanxinlong/git_demo.git
cd git_demo
git status
```

##### 添加、推送、修改

```shell
##添加所有修改
git add .
##提交修改
git commir -a -m 'add some files'
##推送到远程仓库
git push
```

#### 分支

```shell
## 新建一个iss1分支
$ git branch iss1
## 切换到iss1分支
$ git checkout iss1
Switched to branch 'iss1'
## 查看分支，当前已经在iss1分支上面
$ git branch
* iss1
  master
## 在当前分支上进行一些修改
$ echo "file3" >> file3
## 添加并提交修改到本地
$ git add file3
$ git commit -m "add file3"
## 推送到远程，因为现在远程还没有iss1分支，所以需要set-upstream
## 这样，在远程仓库就有了iss1分支，之后可以直接push
$ git push --set-upstream origin iss1

## iss1解决后，把修改合并会master，并删除iss1分支
$ git checkout master
$ git merge iss1
$ git branch -d iss1
$ git push
## 删除远程分支
$ git push origin :iss1
To git@github.com:JavyZheng/git_demo.git
 - [deleted]         iss1
```

##### 拉取别人的分支

```shell
$ git push
## push被驳回了，因为有其他人已经提交了更新
 ! [rejected]        master -> master (fetch first)
error: failed to push some refs to 'git@github.com:JavyZheng/git_demo.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.

## 拉取远程提交内容并合并到当前工作区
$ git pull
## 重新push到远程
$ git push
```

#### 处理冲突

```shell
$ git pull
remote: Counting objects: 5, done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 5 (delta 2), reused 5 (delta 2), pack-reused 0
Unpacking objects: 100% (5/5), done.
From github.com:JavyZheng/git_demo
   7d4f14a..e2e17d3  master     -> origin/master
## 尝试自动合并file1
Auto-merging file1
## 发现冲突，需要手动解决冲突
CONFLICT (content): Merge conflict in file1
Automatic merge failed; fix conflicts and then commit the result.

## 此时，git已经把可能冲突的地方都写进了文件
$ vim file1
## 可以看见冲突的地方
<<<<<<< HEAD
file1 + add 1
=======
file1 + del 4
>>>>>>> e2e17d311ec33700e94ce5dd694aa340920deb7c

## vim里手动解决冲突后，add进来
$ git add file1
$ git commit -m "resolve confict in file1"
## 推送到远程分支
$ git push
```