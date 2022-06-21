#!/bin/bash
# 单机部署redis集群用于测试, 需要安装docker, bitnami/redis-cluster镜像
NAME_PREFIX=redis-cluster-test-
THOUSAND_PORT=7
PASSWORD=123456
# 宿主机对外(客户端侧)地址
HOSTS=192.168.x.x

for i in `seq 6`
do
docker stop $NAME_PREFIX$i
done

for i in `seq 6`
do
docker rm $NAME_PREFIX$i
done

for i in `seq 6`
do
docker run -d -e REDIS_NODES=$HOSTS -e REDIS_PASSWORD=$PASSWORD -e REDIS_PORT_NUMBER=$THOUSAND_PORT'00'$i --network=host --name $NAME_PREFIX$i  bitnami/redis-cluster:latest
done

CLUSTERS=' '
for i in `seq 6`
do
CLUSTERS=$CLUSTERS' '$HOSTS':'$THOUSAND_PORT'00'$i' '
done

echo $CLUSTERS
echo '等容器3秒启动完成'
sleep 3

docker exec -it $NAME_PREFIX''1 redis-cli --cluster create $CLUSTERS --cluster-replicas 1 --cluster-yes -a $PASSWORD
