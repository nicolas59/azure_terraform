#!/bin/sh
mysql_password=PasswdTest
docker cp init-rancher.sql mysql-container:/init-rancher.sql
docker exec mysql -uroot -p$mysql_password < init-rancher.sql
