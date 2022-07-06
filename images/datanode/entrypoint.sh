#!/bin/bash

cat > /etc/hadoop/core-site.xml <<EOL
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://namenode:9000</value>
  </property>
  <property>
    <name>hadoop.http.filter.initializers</name>
    <value>org.apache.hadoop.security.HttpCrossOriginFilterInitializer</value>
  </property>
  <property>
    <name>hadoop.http.cross-origin.enabled</name>
    <value>true</value>
  </property>
  <property>
    <name>hadoop.http.cross-origin.allowed-methods</name>
    <value>GET,POST,HEAD,DELETE,PUT,OPTIONS</value>
  </property>
  <property>
    <name>hadoop.http.staticuser.user</name>
    <value>hadoop</value>
  </property>
</configuration>
EOL

cat > /etc/hadoop/hdfs-site.xml <<EOL
<configuration>
  <property>
    <name>dfs.datanode.use.datanode.hostname</name>
    <value>false</value>
  </property>
  <property>
    <name>dfs.client.use.datanode.hostname</name>
    <value>false</value>
  </property>
  <property>
    <name>dfs.replication</name>
    <value>3</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:///data/hdfs/datanode</value>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:///data/hdfs/namenode</value>
  </property>
  <property>
    <name>hadoop.http.staticuser.user</name>
    <value>hadoop</value>
  </property>
  <property>
    <name>dfs.namenode.datanode.registration.ip-hostname-check</name>
    <value>false</value>
  </property>
  <property>
    <name>dfs.permissions</name>
    <value>false</value>
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
    <value>resourcemanager</value>
  </property>
</configuration>
EOL

$HADOOP_HOME/bin/hdfs --loglevel INFO --daemon start datanode
$HADOOP_HOME/bin/yarn --loglevel INFO --daemon start nodemanager

until find $HADOOP_HOME/logs -mmin -1 | egrep -q '.*'; echo "`date`: Waiting for logs..." ; do sleep 2 ; done
tail -F $HADOOP_HOME/logs/* &
while true; do sleep 1000; done
