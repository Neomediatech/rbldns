#! /bin/bash

export PID_FILE=/var/run/rbldnsd.pid

mkdir -p $HOMEDIR/$CFG_NAME
chown $USERNAME $HOMEDIR/$CFG_NAME

chsh $USERNAME -s /bin/bash

# spammerlist
bl="bl"
# whitelist
wl="wl"

su $USERNAME bash -c "
  cd $HOMEDIR/$CFG_NAME
  [ -e $bl ] || touch $bl
  [ -e $wl ] || touch $wl
  if [ ! -e forward ]; then
    echo '\$SOA' 3600 $RBL_DOMAIN $RBL_DOMAIN 0 600 300 86400 300 >forward
    echo '\$NS' 3600 \$NS_SERVERS >>forward
  fi"

rbldnsd -f -n -r $HOMEDIR/$CFG_NAME -b 0.0.0.0/53 -p $PID_FILE \
  $RBL_DOMAIN:ip4set:$bl,$wl \
  $RBL_DOMAIN:generic:forward
