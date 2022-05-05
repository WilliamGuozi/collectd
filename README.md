# collectd

Monitor group: grafana & graphite & collectd, collectd is member of group.
Basic collectd-based server monitoring. Sends stats to Graphite.

With inspiration from [pboos/docker-collectd-graphite](https://github.com/pboos/docker-collectd-graphite). But not using python to replace the settings.

## Collectd metrics

* CPU used/free/idle/etc
* Free disk (via mounting hosts '/' into container, eg: -v /:/hostfs:ro)
* Disk performance
* Load average
* Memory used/free/etc
* Uptime
* Network interface
* Swap

## Environment variables

* `HOSTNAME`
  - Will be sent to Graphite
  - Required
* `GRAPHITE_HOST`
  - Graphite IP or hostname
  - Required
* `GRAPHITE_PORT`
  - Graphite port
  - Optional, defaults to 2003
* `GRAPHITE_PREFIX`
  - Graphite prefix
  - Optional, defaults to collectd.
* `REPORT_BY_CPU`
  - Report per-CPU metrics if true, global sum of CPU metrics if false (details: [collectd.conf man page](https://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_cpu))
  - Optional, defaults to false.
* `INTERVAL`
  - Controls how often registered read functions are called and with that the resolution of the collected data. (details: [collectd.conf man page](https://collectd.org/wiki/index.php/Interval))
  - Optional, defaults to 10.

## Example execution
> run command, replace HOSTNAME GRAPHITE_HOST correct with your server.
```bash
#!/bin/bash
#
# Created by William Guozi
#

# 获取镜像地址
DOCKER_IMAGE="${1:-reg.dcmining.io/dcmining/ops/collectd:latest}"

# 判断容器是否存在，并将其删除
docker pull $DOCKER_IMAGE && \
docker ps -a | awk -F' ' '{print $NF}' | grep "ops-collectd" && \
docker stop ops-collectd && \
docker rm -f "ops-collectd" || \
echo "Image $image_url pull failed or No container ops-collectd."

# 启动容器
docker run -d \
 --cpus 1 \
 -m 1G \
 -e GRAPHITE_PREFIX=collectd \
 -e GRAPHITE_PORT=2003 \
 -e GRAPHITE_HOST=locahost \
 -e REPORT_BY_CPU=false \
 -e INTERVAL=10 \
 --privileged \
 --restart always \
 -v /:/hostfs:ro \
 -v $PWD:/etc/collectd \
 --name "collectd" \
 $DOCKER_IMAGE
```
