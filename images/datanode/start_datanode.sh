#!/bin/bash

until $HADOOP_HOME/bin/hdfs --loglevel INFO datanode;
do
  echo "Datanode failed. Retrying in 5 seconds..."
  sleep 5
done
