#!/bin/bash

namenode_host="namenode.hadoop.svc.cluster.local"
resourcemanager_host="resourcemanager.hadoop.svc.cluster.local"
spark_host="spark.hadoop.svc.cluster.local"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --namenode-host) namenode_host="$2"; shift ;;
        --resourcemanager-host) resourcemanager_host="$2"; shift ;;
        --spark-host) spark_host="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

cat > /etc/hadoop/core-site.xml <<EOL
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://$namenode_host:9000</value>
  </property>
</configuration>
EOL

cat > /etc/hadoop/hdfs-site.xml <<EOL
<configuration>
  <property>
      <name>dfs.replication</name>
      <value>3</value>
  </property>
</configuration>
EOL

cat > /etc/hadoop/yarn-site.xml <<EOL
<configuration>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.resourcemanager.hostname</name>
    <value>$resourcemanager_host</value>
  </property>
</configuration>
EOL

cat > $SPARK_HOME/conf/spark-defaults.conf <<EOL
spark.yarn.historyServer.address                    $spark_host:18080
spark.yarn.historyServer.allowTracking              true
spark.eventLog.dir                                  hdfs:///logs
spark.eventLog.enabled                              true
spark.history.fs.logDirectory                       hdfs:///logs
spark.ui.view.acls                                  hadoop
spark.ui.filters                                    org.apache.spark.deploy.yarn.YarnProxyRedirectFilter
EOL

# $SPARK_HOME/sbin/start-history-server.sh
until find $SPARK_HOME/logs -mmin -1 | egrep -q '.*'; echo "`date`: Waiting for logs..." ; do sleep 2 ; done
tail -F $SPARK_HOME/logs/* &
while true; do sleep 1000; done
