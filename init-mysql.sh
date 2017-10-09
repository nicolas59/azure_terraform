#!/bin/sh
mysql_root=$1
mysql_password=$2

echo "Create mysql container with user $mysql_root"
docker pull mysql/mysql-server:5.6
docker run --name mysql-container -e MYSQL_ROOT_PASSWORD=$mysql_password -d mysql/mysql-server:5.6
