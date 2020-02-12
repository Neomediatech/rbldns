FROM neomediatech/ubuntu-base:latest

ENV VERSION=0.998b~pre1-1 \
    SERVICE=rbldns-static-docker

LABEL maintainer="docker-dario@neomediatech.it" \
      org.label-schema.version=$VERSION \
      org.label-schema.vcs-type=Git \
      org.label-schema.vcs-url=https://github.com/Neomediatech/$SERVICE \
      org.label-schema.maintainer=Neomediatech

COPY bin/entrypoint.sh /
RUN apt-get -yq update && \
    apt-get -yq --no-install-recommends install rbldnsd perl && \
    chmod 755 /entrypoint.sh && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/log/*

EXPOSE 53/udp
ENTRYPOINT ["/entrypoint.sh"]
