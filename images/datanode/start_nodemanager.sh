#!/bin/bash

until $HADOOP_HOME/bin/yarn --loglevel INFO nodemanager;
do
  echo "Nodemanager failed. Retrying in 5 seconds..."
  sleep 5
done
