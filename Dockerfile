FROM    ubuntu:xenial
LABEL maintainer="WilliamGuo <634206396@qq.com>"

ENV     DEBIAN_FRONTEND noninteractive

RUN     apt-get -y update \
        && apt-get -y install collectd

# add a fake mtab for host disk stats
ADD     etc_mtab /etc/mtab
ADD     collectd.conf.tpl /etc/collectd/collectd.conf.tpl
COPY    entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["collectd", "-f"]
