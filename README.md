# rbldns-static-docker
rbldnsd dockerized daemon to run a RBL list

Inspired from https://github.com/instantlinux/docker-tools/tree/master/images/blacklist .  

This version runs rbldnsd based on files.  
Maybe in future i'll create another version based on instantlinux mysql work.

### Variables

These variables can be passed to the image from kubernetes.yaml or docker-compose.yml as needed:

| Variable | Default | Description |
| -------- | ------- | ----------- |
| ZONES | /rbldns | directory for zone files |
| NS_SERVERS | 127.0.0.1 | upstream nameservers having NS records |
| RBL_DOMAIN | bl.localhost.tld | domain name to serve |
| TZ | Europe/Rome| time zone |
| USERNAME | rbldns | username to run as |
