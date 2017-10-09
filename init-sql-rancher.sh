#!/bin/sh
mysql_password=PasswdTest
docker cp init-rancher.sql mysql-container:/init-rancher.sql
docker cp init.sh mysql-container:/init.sh
docker exec mysql-container sh init.sh $mysql_password
