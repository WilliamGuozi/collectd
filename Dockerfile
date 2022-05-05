FROM  alpine:3.14
LABEL maintainer="WilliamGuo <634206396@qq.com>"

RUN   apk update
RUN   apk add collectd
RUN   apk add --no-cache bash
RUN   apk add collectd-plugins-all

# add a fake mtab for host disk stats
ADD   etc_mtab /etc/mtab

COPY docker-entrypoint.sh /
RUN  chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
