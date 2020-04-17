# !/usr/bin/env sh
time = date +%F+%H:%M:%S
echo time
git add .
git commit -m time
git push
echo 'git提交成功'
