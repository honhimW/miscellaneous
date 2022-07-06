#!/bin/bash

# zookeeper
docker run -dp 2181:2181 --name zookeeper -e ALLOW_ANONYMOUS_LOGIN=yes bitnami/zookeeper
# kafka server
docker run -d --network=host --name kafka -e ALLOW_PLAINTEXT_LISTENER=yes -e KAFKA_CFG_ZOOKEEPER_CONNECT=10.37.1.132:2181 bitnami/kafka
# kafdrop add-host需要到kafka-server容器内查看
docker run -dp 9001:9000 --name kafdrop --add-host=m11132:10.37.1.132 -e KAFKA_BROKERCONNECT=10.37.1.132:9092 -e JVM_OPTS="-Xms32M -Xmx64M" -e SERVER_SERVLET_CONTEXTPA
TH="/" obsidiandynamics/kafdrop
