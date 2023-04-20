FROM apache/spark:v3.2.1

USER root

COPY ./entrypoint.sh /entrypoint.sh

ENV HADOOP_CONF_DIR /etc/hadoop
ENV HADOOP_USER_NAME hadoop

ENTRYPOINT [ "/entrypoint.sh" ]
