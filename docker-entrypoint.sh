#!/bin/bash

set -e

COLLECTD_CONFIG=${1:-/hostfs/opt/ops-collectd/collectd.conf}

if [ -f "$COLLECTD_CONFIG" ]; then
    echo "$COLLECTD_CONFIG has been existed"
    exit
fi

cd $(dirname $0)

cat >> $COLLECTD_CONFIG << EOF

FQDNLookup   false

Interval     ${INTERVAL:-10}

Timeout         2
ReadThreads     5

LoadPlugin syslog
LoadPlugin logfile

<Plugin logfile>
	LogLevel info
	File STDOUT
	Timestamp true
	PrintSeverity false
</Plugin>

LoadPlugin cpu
LoadPlugin df
LoadPlugin disk
LoadPlugin interface
LoadPlugin load
LoadPlugin memory
LoadPlugin write_graphite


<Plugin cpu>
  ReportByCpu ${REPORT_BY_CPU:-false}
  ReportByState true
  ValuesPercentage false
  ReportNumCpu false
  ReportGuestState false
  SubtractGuestState true
</Plugin>


<Plugin df>
	Device "/dev/sda1"
	Device "/dev/sda15"
  MountPoint "/etc/resolv.conf"
  MountPoint "/etc/hostname"
  MountPoint "/etc/hosts"
  FSType rootfs
  FSType sysfs
  FSType proc
  FSType devtmpfs
  FSType devpts
  FSType tmpfs
  FSType fusectl
  FSType cgroup
  FSType overlay
  FSType debugfs
  FSType pstore
  FSType securityfs
  FSType hugetlbfs
  FSType squashfs
  FSType mqueue
  FSType shm
	IgnoreSelected true
	LogOnce false
	ReportByDevice false
	ReportInodes false
	ValuesAbsolute true
	ValuesPercentage false
</Plugin>

<Plugin disk>
	Disk "/^[hs]d[a-f][0-9]?$/"
	IgnoreSelected false
</Plugin>

<Plugin interface>
  Interface "lo"
  Interface "/^veth.*/"
  Interface "/^docker.*/"
  IgnoreSelected true
</Plugin>

<Plugin write_graphite>
  <Node "Dcmining">
    Host "${GRAPHITE_HOST:-locahost}"
    Port "${GRAPHITE_PORT:-2003}"
    Prefix "${GRAPHITE_PREFIX:-collectd}."
    Protocol "tcp"
    ReconnectInterval 0
    LogSendErrors true
    Postfix ""
    StoreRates true
    AlwaysAppendDS false
    EscapeCharacter "_"
    SeparateInstances false
    PreserveSeparator false
    DropDuplicateFields false
    ReverseHost false
  </Node>
</Plugin>

EOF
#
#collectd -f -C ${COLLECTD_CONFIG}
exec "$@"