#!/bin/bash

ls -lah $HADOOP_HOME/etc/hadoop/conf
until $HADOOP_HOME/bin/hdfs --loglevel INFO namenode;
do
  echo "Namenode failed. Retrying in 5 seconds..."
  sleep 5
done
