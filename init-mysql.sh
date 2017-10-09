#!/bin/sh
mysql_password=PasswdTest

echo "Create mysql container"
docker pull mysql/mysql-server
docker run --name mysql-container -e MYSQL_ROOT_PASSWORD=$mysql_password -p 3306:3306 -d mysql/mysql-server
