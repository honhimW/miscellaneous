#!/bin/bash
# $1 redis密码
# $2 keys表达式

if [ -z $1 ]; then
echo '密码不能为空'
exit 1
fi

if [ -z $2 ]; then
echo 'KEYS pattern 不能为空'
exit 1
fi

redis-cli -h 10.37.1.132 -p 6001 -a $1 --raw KEYS $2 | xargs -I {} redis-cli -h 10.37.1.132 -p 6001 -a $1 DEL '{}'
redis-cli -h 10.37.1.132 -p 6002 -a $1 --raw KEYS $2 | xargs -I {} redis-cli -h 10.37.1.132 -p 6002 -a $1 DEL '{}'
redis-cli -h 10.37.1.132 -p 6003 -a $1 --raw KEYS $2 | xargs -I {} redis-cli -h 10.37.1.132 -p 6003 -a $1 DEL '{}'
