FROM debian:stretch-slim
ENV VERSION=1.0.0-r0 \ 
    BUILD_DATE=2019-12-03 \ 
    TZ=Europe/Rome \
    DEBIAN_FRONTEND=noninteractive 

LABEL maintainer="docker-dario@neomediatech.it" \ 
      org.label-schema.version=$VERSION \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-type=Git \
      org.label-schema.vcs-url=https://github.com/Neomediatech/dnsbl-docker \
      org.label-schema.maintainer=Neomediatech


COPY bin/ /usr/local/bin/
RUN apt-get -yq update && \
    apt-get -yq --no-install-recommends install \
      rbldnsd perl && \
    chmod 755 /usr/local/bin/entrypoint.sh && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/log/*

VOLUME $HOMEDIR
EXPOSE 53/udp
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
