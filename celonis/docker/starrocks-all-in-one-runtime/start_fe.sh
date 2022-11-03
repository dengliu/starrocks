#!/bin/bash

# Set JAVA_HOME.
export JAVA_HOME=/usr/lib/jvm/java-1.8.0

export SR_HOME=/data/deploy/starrocks

# Start FE.
cd $SR_HOME/fe/bin/

# Try stop fe first if there is a running instance
./stop_fe.sh
sleep 3

# enable [FQDN access](https://docs.starrocks.io/en-us/2.4/administration/enable_fqdn#enable-fqdn-access)
./start_fe.sh --host_type FQDN --daemon
