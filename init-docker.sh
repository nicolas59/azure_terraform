#!/bin/sh
docker run --privileged --rm -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.6 http://$1/v1/scripts/$2