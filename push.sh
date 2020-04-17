# !/usr/bin/env sh
time=$(date "+%Y-%m-%d %H:%M:%S")
echo "${time}"
git add .
git commit -m time
git push
echo 'git提交成功'
