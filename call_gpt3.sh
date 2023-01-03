#!/bin/bash
## Franklin is a gpt3 api calling bot for irc (easily adapted to other applications)


SITE="https://gpt3.oxasploits.com" # where to host the overrun
HARDL="-350"                       # hard limit (in bytes)
SOFTL="120"                        # soft limit (in words)
MODEL="text-davinci-003"
HEAT="0.8"
SAY="$1"
WHO="$2"

function call_api () {
  APIKEY=$(<api.key)
  SRV="https://api.openai.com/v1/completions"
  if [[ $(grep ${WHO} block.list | wc -l) -eq 0 ]]; then
    echo "${WHO}: ${SAY}" >>gpt3.log
    curl -s ${SRV} -H "Content-Type: application/json" -H "Authorization: Bearer ${APIKEY}" \
      -d "{\"model\": \"${MODEL}\",\"prompt\": \"${SAY}\",\"temperature\": ${HEAT},\"max_tokens\": \
      ${SOFTL},\"top_p\": 1,\"frequency_penalty\": 0,\"presence_penalty\": 0}" >res.txt
    # sanitizes input
    cat res.txt | tr -d "\'" | tr -d "\`" | tr -d "\;" | tr -d '\&' >sanitized.txt
    # json extraction and formatting
    cat sanitized.txt | jq -r '.choices[].text' | sed -e 's|\\n||g' | tr -d '\n' >/var/www/html/said/${CALLR}
    # add it to the webserver dir and say/log its response
    SAID=$(cat /var/www/html/said/${CALLR} | sed -e 's/[^\.]$/.../' | cut -c ${HARDL})
    echo "$SAID ${SITE}/said/${CALLR}" | tee -a gpt3.log
  else
    echo "You cannot use that command."
  fi
}

# random for the end of the url
while [[ $CALLED -eq 0 ]]; do
  CALLR=$(echo ${RANDOM} | md5sum | cut -c -6)
  CALLED=0
  # test to see if a file is already there by that name
  if test ! -f "/var/www/html/said/${CALLR}"; then
    CALLED=1
    # the main api calling function
    call_api;
    break;
  else
    CALLED=0
  fi
done
