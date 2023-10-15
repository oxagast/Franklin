#!/bin/bash
#  add a crontab that reads:
# */10 * * * * /var/www/franklin/scripts/changedate.sh > /var/www/franklin/changedate.html
# make sure changedate.html can be written by your user
D=$(date +"%a %b %d, %Y");
echo "<h5 id="date"> $D </h5>"
