echo "Create rancher container"
docker pull rancher/server:stable
docker run --name=rancheros -d --restart=always -p 8080:8080  -p 9345:934 rancher/server:stable \
    --db-host 10.0.0.6 --db-port 3306 --db-user cattle --db-pass cattle --db-name cattle \
    --advertise-address $(ip route get 8.8.8.8 | awk '{print $NF;exit}')