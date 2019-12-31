FROM neomediatech/ubuntu-base
ENV DEBIAN_FRONTEND=noninteractive 

LABEL maintainer="docker-dario@neomediatech.it" \ 
      org.label-schema.vcs-type=Git \
      org.label-schema.vcs-url=https://github.com/Neomediatech/rbldns-static-docker \
      org.label-schema.maintainer=Neomediatech

COPY bin/entrypoint.sh /
RUN apt-get -yq update && \
    apt-get -yq --no-install-recommends install rbldnsd perl && \
    chmod 755 /entrypoint.sh && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/log/*

EXPOSE 53/udp
ENTRYPOINT ["/entrypoint.sh"]
