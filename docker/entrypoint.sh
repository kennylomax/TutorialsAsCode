#!/bin/bash
set -x -e
if [ -z "$KARATE_JOBURL" ]
  then
    export KARATE_OPTIONS="-h"
    export KARATE_START="false"
  else
    export KARATE_START="true"
    export KARATE_OPTIONS="-j $KARATE_JOBURL"
fi
if [ -z "$KARATE_SOCAT_START" ]
  then
	export KARATE_SOCAT_START="false"
	export KARATE_CHROME_PORT="9222"
  else
	export KARATE_SOCAT_START="true"
	export KARATE_CHROME_PORT="9223"
fi
[ -z "$KARATE_WIDTH" ] && export KARATE_WIDTH="1760"
[ -z "$KARATE_HEIGHT" ] && export KARATE_HEIGHT="1480"

echo "AUTO_START :"$AUTO_START
echo "JOURNEY_NAME :"$JOURNEY_NAME
echo "KLX1"

if [ -z "$AUTO_START" ]
then
  echo "manual start"
  exec /usr/bin/supervisord
else 
  echo "auto start"
  exec /usr/bin/supervisord  &
  echo "Starting sleep to allow bootup - perhaps not necessary"
  sleep 10
  export NOW=$(date +%s%3N)
  cd src 
  ls -la  
  echo "Calling validatejourney.sh with" $JOURNEY_NAME $NOW 0 999
  source ./validatejourney.sh $JOURNEY_NAME $NOW 0 999
  echo "Finished"
fi
