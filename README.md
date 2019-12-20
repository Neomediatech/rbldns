# rbldns-static-docker
rbldnsd dockerized daemon to run a RBL list

Inspired from https://github.com/instantlinux/docker-tools/tree/master/images/blacklist .  

This version runs rbldnsd based on files.  
Maybe in future i'll create another version based on instantlinux mysql work.

### Variables

These variables can be passed to the image from kubernetes.yaml or docker-compose.yml as needed:

| Variable | Default | Description |
| -------- | ------- | ----------- |
| ZONES | /data | directory for zone files |
| NS_SERVERS | 127.0.0.1 | upstream nameservers having NS records |
| RBL_DOMAIN | bl.localhost.tld | domain name to serve |
| TZ | Europe/Rome| time zone |
| USERNAME | rbldns | username to run as |
| LOGGING | 0 | 1 to enable logging on $ZONES/rbldns.log |

### Zone file format
http://www.corpit.ru/mjt/rbldnsd.html

#### Examples
```
:127.0.0.2:Open relay, see http://relays.example.com/lookup?$
# The above is a default or implicit value which is used when no value given
# for an entry.  The `$' characters will be replaced by an IP address in
# question.

127.8.8.10
# A simplest case: single IP address, with default value.

10.8.60.0/24 :127.0.0.3:Address $ is from a private IP range
# Netblock - 256 IP addresses with their own A and TXT records

192.168	 Dialup pool, see http://dialups.example.com/lookup?$ for explanations
# IP numbers may be abbreviated, the above is the same as 192.168.0.0/16

10.10    :5:This network blocked due to massive spam issues
# A value may be abbreviated as well - :5: is the same as :127.0.0.5:.

10.10.5-129	:5:Those hosts are nasty
# repeat last octet: 10.10.5.0..10.10.129.255 inclusive

!10.10.1.2
# exclusion entry

# some specials
$SOA 3000 ns1.example.com admin.example.com 0 600 300 86400 300
# Start of authority record (TTL 3000), with serial (0) computed as
# a timestamp of data file
$NS 3000 ns1.example.com ns2.example.com
# two nameservers
```
For blacklist (bl) file we'll use default 127.0.0.2 and for whitelist (wl) 127.0.0.10

