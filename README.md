# collectd
monitor group: grafana &amp; graphite &amp; collectd

# run command, replace HOSTNAME GRAPHITE_HOST correct with your server.
```bash
docker run -d \
 --net=host --privileged \
 --restart always \
 -v /:/hostfs:ro \
 -e HOST_NAME=myhostname \
 -e GRAPHITE_HOST=graphite.glinux.top \
 --name collectd collectd:latest
```
