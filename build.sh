#!/bin/bash
#
# Created by William Guozi
#

# venv and generate requirement
#source ~/venv/$(basename "$PWD")/bin/activate
#pip3 freeze > requirement

# push with commit
git add .
minsec=$(date "+%H-%M")
git commit -m "update $minsec"
git push

# push with tag
versionCommit=$(git rev-parse --short=8 HEAD)
versionDate=$(git log --pretty=format:"%ad" --date=short | head -1)
version=v$versionCommit-$versionDate
git tag -a $version -m "auto tag $version"
git push origin --tags


export version=v$versionCommit-$versionDate
# start.sh
##!/bin/bash
##
## Created by William Guozi
##
#
## 获取镜像地址
#DOCKER_IMAGE="${1}"
#
## 判断容器是否存在，并将其删除
#docker pull $DOCKER_IMAGE && \
#docker ps -a | awk -F' ' '{print $NF}' | grep "$(basename "$PWD")" && \
#docker rm -f "$(basename "$PWD")" || \
#echo "Image $image_url pull failed or No container $(basename "$PWD")."
#
## 启动容器
#docker run -d \
#    --name "$(basename "$PWD")" \
#    -v /var/run/docker.sock:/var/run/docker.sock:ro \
#    -v /opt/$(basename "$PWD")/config.toml:/app/config.toml \
#    --cpus 1 \
#    -m 1G \
#    --restart always \
#    $DOCKER_IMAGE


