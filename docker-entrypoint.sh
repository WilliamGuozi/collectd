#!/bin/bash

set -e

COLLECTD_CONFIG=${1:-/etc/collectd/collectd.conf}
COLLECTD_DIR=$(dirname "$COLLECTD_CONFIG")

if [ ! -f "$COLLECTD_CONFIG" ]; then

  if [ ! -d "$COLLECTD_DIR" ]; then
    mkdir -p $COLLECTD_DIR
  fi

#cd $(dirname $0)

cat > $COLLECTD_CONFIG << EOF

Hostname    "${HOSTNAME:-$HOSTNAME}"
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
	FSType "ext4"
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
  <Node "example">
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

#fi
#
exec collectd -f -C ${COLLECTD_CONFIG}
