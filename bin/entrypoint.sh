#! /bin/bash

export PID_FILE=/var/run/rbldnsd.pid

ZONES=${ZONES:-/data}
USERNAME=${USERNAME:-rbldns}
RBL_DOMAIN=${RBL_DOMAIN:-bl.localhost.tld}
NS_SERVERS=${NS_SERVERS:-127.0.0.1}
LOGGING=${LOGGING:-0}
CUSTOM_ZONES=${CUSTOM_ZONES:-}
CUSTOM_CONFIG=${CUSTOM_CONFIG:-}

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

if [ -n "$CUSTOM_ZONES" ]; then
  IFS=,
  tmpzone=""
  echo "Configuring custom zones..."
  for zone in $CUSTOM_ZONES; do
    if [ -s $zone ]; then
      tmpzone="$tmpzone,$zone"
    else
      echo "WARN: file $ZONES/$zone does't exists or has 0 size, skipping configuring it..."
    fi
  done
  unset IFS
fi

[ -n "$tmpzone" ] && custom_zone="$tmpzone" || custom_zone=""

chown $USERNAME $bl $wl forward

rbldnsd $LOGGING -f -n -r $ZONES -vv -b 0.0.0.0/53 -p $PID_FILE \
  $RBL_DOMAIN:ip4set:$bl,${wl}$custom_zone \
  $RBL_DOMAIN:generic:forward $CUSTOM_CONFIG
