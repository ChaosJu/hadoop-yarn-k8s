FROM hadoop-base

COPY --chown=hadoop:hadoop entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]
