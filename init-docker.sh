#!/bin/sh
docker run --privileged --rm -v /var/run/docker.sock:/var/run/docker.sock \
    --label consul=yes --label mongo=yes --label api=yes \
    -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.6 http://10.0.0.5:8080