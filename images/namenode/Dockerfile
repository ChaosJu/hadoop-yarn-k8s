FROM hadoop-base

RUN $HADOOP_HOME/bin/hdfs namenode -D dfs.namenode.name.dir=file:///data/hdfs/namenode -format

COPY --chown=hadoop:hadoop entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
