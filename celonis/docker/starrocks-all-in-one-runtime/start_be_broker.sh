#!/bin/bash

# Set JAVA_HOME.
export JAVA_HOME=/usr/lib/jvm/java-1.8.0

export SR_HOME=/data/deploy/starrocks

# Start BE.
cd $SR_HOME/be/bin/

# Try stop be if there is an instance
./stop_be.sh
sleep 3
./start_be.sh --daemon

# Start broker.
cd $SR_HOME/apache_hdfs_broker/bin/

# Try stop broker if there is an instance
./stop_broker.sh
sleep 3

./start_broker.sh --daemon

# Loop to detect the process.
while sleep 60; do
  ps aux | grep starrocks | grep -q -v grep
  PROCESS_STATUS=$?

  if [ PROCESS_STATUS -ne 0 ]; then
    echo "one of the starrocks process already exit."
    exit 1;
  fi
done
