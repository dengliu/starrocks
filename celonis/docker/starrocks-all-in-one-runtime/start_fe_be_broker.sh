#!/bin/bash

# Set JAVA_HOME.
export JAVA_HOME=/usr/lib/jvm/java-1.8.0

export SR_HOME=/data/deploy/starrocks

# Start FE.
cd $SR_HOME/fe/bin/
# enable [FQDN access](https://docs.starrocks.io/en-us/2.4/administration/enable_fqdn#enable-fqdn-access)
./start_fe.sh --host_type FQDN --daemon

# Start BE.
cd $SR_HOME/be/bin/
./start_be.sh --daemon

# Start broker.
cd $SR_HOME/apache_hdfs_broker/bin/
./start_broker.sh --daemon

# Sleep until the cluster starts.
sleep 30;

# Set BE and broker server IP.
# Note this command only works for Centos 7 docker container.
# It does NOT work on Ubuntu.
IP=$(ifconfig eth0 | grep 'inet' | cut -d: -f2 | awk '{print $2}')

# Fetch fqdn with the command suggested by AWS official doc: https://docs.aws.amazon.com/managedservices/latest/userguide/find-FQDN.html
MYFQDN=`hostname --fqdn`
mysql -uroot -h${MYFQDN} -P 9030 -e "alter system add backend '${MYFQDN}:9050';"
mysql -uroot -h${MYFQDN} -P 9030 -e "alter system add broker broker1 '${MYFQDN}:8000';"


# Loop to detect the process.
while sleep 60; do
  ps aux | grep starrocks | grep -q -v grep
  PROCESS_STATUS=$?

  if [ PROCESS_STATUS -ne 0 ]; then
    echo "one of the starrocks process already exit."
    exit 1;
  fi
done
