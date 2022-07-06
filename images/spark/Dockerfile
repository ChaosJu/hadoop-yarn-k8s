FROM apache/spark:v3.2.1

USER root

COPY ./config/* /opt/spark/conf/

COPY ./entrypoint.sh /entrypoint.sh

RUN mkdir /opt/spark/logs /etc/hadoop && \
    chmod 777 /opt/spark/logs && \
    chmod +x /entrypoint.sh

ENV HADOOP_CONF_DIR /etc/hadoop
ENV HADOOP_USER_NAME hadoop

ENTRYPOINT [ "/entrypoint.sh" ]
