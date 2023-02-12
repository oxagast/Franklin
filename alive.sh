#!/bin/bash
if [[ $(pgrep -c -f alive.sh) -eq "1" ]]; then
  while [[ 1 ]]; do
    if [[ $(pgrep -c irssi) -eq "1" ]]; then
      curl -s https://heartbeat.uptimerobot.com/m793650946-7aba08b41eac1a30845c47af01846a41594d456d > /dev/null;
    fi
    sleep 60;
  done;
else
    echo "Sorry, alive worker is already running.";
fi;

