#! /bin/bash

export PID_FILE=/var/run/rbldnsd.pid

ZONES=${ZONES:-/data}
USERNAME=${USERNAME:-rbldns}
RBL_DOMAIN=${RBL_DOMAIN:-bl.localhost.tld}
NS_SERVERS=${NS_SERVERS:-127.0.0.1}
LOGGING=${LOGGING:-0}

mkdir -p $ZONES
chown $USERNAME $ZONES

chsh $USERNAME -s /bin/bash

# spammerlist
bl="bl"
# whitelist
wl="wl"

if [ $LOGGING -eq 1 ]; then
  LOGGING="-l +rbldns.log"
  touch "$ZONES/rbldns.log"
  chown $USERNAME "$ZONES/rbldns.log"
else
  LOGGING=""
fi

cd $ZONES
[ -e $bl ] || touch $bl
[ -e $wl ] || touch $wl
if [ ! -e forward ]; then
  echo '$SOA' 3600 $RBL_DOMAIN $RBL_DOMAIN 0 600 300 86400 300 >forward
  echo '$NS' 3600 $NS_SERVERS >>forward
fi

chown $USERNAME $bl $wl forward

rbldnsd $LOGGING -f -n -r $ZONES -b 0.0.0.0/53 -p $PID_FILE \
  $RBL_DOMAIN:ip4set:$bl,$wl \
  $RBL_DOMAIN:generic:forward
