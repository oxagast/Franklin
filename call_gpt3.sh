#!/bin/bash

SITE="https://gpt3.oxasploits.com" # where to host the overrun
HARDL="-350"                       # hard limit (in bytes)
SOFTL="120"                        # soft limit (in words)

SAY="$1"
WHO="$2"




function call_api () {
  APIKEY=$(<api.key)
  if [[ $(grep ${WHO} block.list | wc -l) -eq 0 ]]; then
    echo "${WHO}: ${SAY}" >>gpt3.log
    curl -s https://api.openai.com/v1/completions -H "Content-Type: application/json" -H "Authorization: Bearer ${APIKEY}" -d "{\"model\": \"text-davinci-003\",\"prompt\": \"${SAY}\",\"temperature\": 0.8,\"max_tokens\": ${SOFTL},\"top_p\": 1,\"frequency_penalty\": 0,\"presence_penalty\": 0}" >res.txt
    cat res.txt | tr -d "\'" | tr -d "\`" | tr -d "\;" | tr -d '\&' >sanitized.txt
    cat sanitized.txt | jq -r '.choices[].text' | sed -e 's|\\n||g' | tr -d '\n' >/var/www/html/said/${CALLR}
    SAID=$(cat /var/www/html/said/${CALLR} | sed -e 's/[^\.]$/.../' | cut -c ${HARDL})
    echo "$SAID ${SITE}/said/${CALLR}" | tee -a gpt3.log
  else
    echo "You cannot use that command."
  fi
}


# random for the end of the url, maybe add collision protection?
while [[ $CALLED -eq 0 ]]; do
  CALLR=$(echo ${RANDOM} | md5sum | cut -c -6)
  CALLED=0
  if test ! -f "/var/www/html/said/${CALLR}"; then
    CALLED=1
    call_api;
    break;
  else
    CALLED=0
  fi
done
