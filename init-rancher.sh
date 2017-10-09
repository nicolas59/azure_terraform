echo "Create rancher container"
docker pull rancher/server
docker run -d --restart=unless-stopped -p 8080:8080 rancher/server \
    --db-host 10.0.0.6 --db-port 3306 --db-user cattle --db-pass cattle --db-name cattle