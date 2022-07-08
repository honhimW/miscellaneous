#!/bin/bash

# pulsar server
docker run -d -p 6650:6650  -p 6060:8080 -p 6061:8081 --name pulsar -it apachepulsar/pulsar:2.10.1 bin/pulsar standalone
# 开启容器内SQL-worker进程，Presto端口8081，映射到6061
docker exec -it -d pulsar bin/pulsar sql-worker run

#=============================================================================================================

# pulsar-manager
docker run -dp 9527:9527 -p 7750:7750 --name pulsar-manager -e SPRING_CONFIGURATION_FILE=/pulsar-manager/pulsar-manager/application.properties apachepulsar/pulsar-manager:v0.2.0
# sqlpad Web端SQL工具，注意sqlpad连接Presto时账号填：1，密码为空
docker run -dp 3000:3000 --name sqlpad -e SQLPAD_ADMIN="admin" -e SQLPAD_ADMIN_PASSWORD="123456" sqlpad/sqlpad

# pulsar-manager 配置账号：pulsar，密码：pulsar
SEC_TO_WAIT=25
echo 'wait '$SEC_TO_WAIT's for application to start up, then config the user to login manager...'
sleep $SEC_TO_WAIT
CSRF_TOKEN=$(curl http://10.37.1.132:7750/pulsar-manager/csrf-token)
curl -H 'X-XSRF-TOKEN: '$CSRF_TOKEN -H 'Cookie: XSRF-TOKEN='$CSRF_TOKEN -H "Content-Type: application/json" -X PUT http://10.37.1.132:7750/pulsar-manager/users/superuser -d '{"name": "pulsar", "password": "pulsar", "description": "test", "email": "honhimw@outlook.com"}'
