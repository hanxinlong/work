# Auto_Git自动提交脚本

##### 以路径/www/root为例

```ini
#!/bin/bash
cd  /www/root
git checkout my
git add .
read -p "请输入你提交的说明" explain
git commit -a -m $explain
git checkout develop
git merge my
git push origin develop
git checkout my
```