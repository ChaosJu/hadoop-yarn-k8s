#!/bin/bash

until $HADOOP_HOME/bin/yarn --loglevel INFO resourcemanager;
do
  echo "Resourcemanager failed, retrying in 5 seconds..."
  sleep 5
done
