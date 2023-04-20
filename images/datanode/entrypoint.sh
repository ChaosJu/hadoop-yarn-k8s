#!/bin/bash

./start_datanode.sh &
./start_nodemanager.sh &

while true; do sleep 1000; done
