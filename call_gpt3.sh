#!/bin/bash

SITE="https://gpt3.oxasploits.com" # where to host the overrun
HARDL="-400"                       # hard limit (in bytes)
SOFTL="65"                         # soft limit (in words)

SAY="$1"
WHO="$2"
CALLR=$(echo ${RANDOM} | md5sum | cut -c -6)
APIKEY=$(<api.key)
if [[ $(grep ${WHO} block.list | wc -l) -eq 0 ]]; then
  echo "${SAY}" >>gpt3.log
  curl -s https://api.openai.com/v1/completions -H "Content-Type: application/json" -H "Authorization: Bearer ${APIKEY}" -d "{\"model\": \"text-davinci-003\",\"prompt\": \"${SAY}\",\"temperature\": 0.8,\"max_tokens\": ${SOFTL},\"top_p\": 1,\"frequency_penalty\": 0,\"presence_penalty\": 0}" >res.txt
  cat res.txt | tr -d "\'" | tr -d "\`" | tr -d "\;" | tr -d '\&' >sanitized.txt
  cat sanitized.txt | jq -r '.choices[].text' | sed -e 's|\\n||g' | tr -d '\n' >/var/www/html/said/${CALLR}
  SAID=$(cat /var/www/html/said/${CALLR} | sed -e 's/[^\.]$/.../' | tr -d '\n' | cut -c ${HARDL})
  echo $SAID ${SITE}/said/${CALLR}
else
  echo "You cannot use that command."
fi
