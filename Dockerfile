FROM debian:stretch-slim
ENV TZ=Europe/Rome \
    DEBIAN_FRONTEND=noninteractive 

LABEL maintainer="docker-dario@neomediatech.it" \ 
      org.label-schema.vcs-type=Git \
      org.label-schema.vcs-url=https://github.com/Neomediatech/rbldns-static-docker \
      org.label-schema.maintainer=Neomediatech


COPY bin/ /usr/local/bin/
RUN apt-get -yq update && \
    apt-get -yq --no-install-recommends install rbldnsd perl && \
    chmod 755 /usr/local/bin/entrypoint.sh && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/log/*

EXPOSE 53/udp
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
