#!/bin/bash
# wikimon 1.0 - WikiCoin Masternode Monitoring 

#Processing command line params
if [ -z $1 ]; then dly=1; else dly=$1; fi   # Default refresh time is 1 sec

datadir="/$USER/.wikicore$2"   # Default datadir is /root/.wikicore
 
# Install jq if it's not present
dpkg -s jq 2>/dev/null >/dev/null || sudo apt-get -y install jq

#It is a one-liner script for now
watch -ptn $dly "echo '===========================================================================
Outbound connections to other WIKI nodes [WIKI datadir: $datadir]
===========================================================================
Node IP               Ping    Rx/Tx     Since  Hdrs   Height  Time   Ban
Address               (ms)   (KBytes)   Block  Syncd  Blocks  (min)  Score
==========================================================================='
wiki-cli -datadir=$datadir getpeerinfo | jq -r '.[] | select(.inbound==false) | \"\(.addr),\(.pingtime*1000|floor) ,\
\(.bytesrecv/1024|floor)/\(.bytessent/1024|floor),\(.startingheight) ,\(.synced_headers) ,\(.synced_blocks)  ,\
\((now-.conntime)/60|floor) ,\(.banscore)\"' | column -t -s ',' && 
echo '==========================================================================='
uptime
echo '==========================================================================='
echo 'Masternode Status: \n# wiki-cli masternode status' && wiki-cli -datadir=$datadir masternode status
echo '==========================================================================='
echo 'Sync Status: \n# wiki-cli mnsync status' &&  wiki-cli -datadir=$datadir mnsync status
echo '==========================================================================='
echo 'Masternode Information: \n# wiki-cli getinfo' && wiki-cli -datadir=$datadir getinfo
echo '==========================================================================='
echo 'Usage: wikimon.sh [refresh delay] [datadir index]'
echo 'Example: wikimon.sh 10 22 will run every 10 seconds and query wikid in /$USER/.wikicore22'
echo '\n\nPress Ctrl-C to Exit...'"
