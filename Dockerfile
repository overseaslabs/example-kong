FROM kong:0.14.0-centos

LABEL vendor="Overseas Labs Limited" \
      vendor.website=http://overseaslsbs.com \
      description="Kong API Gate" \
      project="Example project" \
      tag="overseaslabs/example-kong:1.0.0"

#install the postgres client for polling
RUN yum install -y postgresql && yum clean all

COPY migrations-entrypoint.sh /migrations-entrypoint.sh

RUN chmod +x /migrations-entrypoint.sh

ENTRYPOINT ["/migrations-entrypoint.sh"]

CMD ["kong", "docker-start"]