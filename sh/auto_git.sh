#!/bin/bash


git checkout my
git add .
read -p "���������ύ��˵��" explain
git commit -a -m $explain
git checkout develop
git merge my
git push origin develop
git checkout my
