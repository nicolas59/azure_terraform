#!/bin/sh
mysql_root=$1
mysql_password=$2

echo "Create mysql container with user $mysql_root"
docker run --name mysql-container -e MYSQL_ROOT_PASSWORD=$mysql_password -d mysql/mysql-server:tag
