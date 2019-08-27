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
docker run -d \
 --net=host \
 --privileged \
 --restart always \
 -v /:/hostfs:ro \
 -e HOST_NAME=myhostname \
 -e GRAPHITE_HOST=graphite.glinux.top \
 --name collectd \
 williamguozi/collectd:latest
```
