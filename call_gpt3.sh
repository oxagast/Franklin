#!/bin/bash
SAY="$1"
WHO="$2"
CALLR=$(echo ${RANDOM} | md5sum | cut -c -6)
if [[ $(grep ${WHO} block.list | wc -l) -eq 0 ]]; then
APIKEY=""
echo "${SAY}" >> gpt3.log;
HARDL="-400"
SOFTL="65";
curl -s https://api.openai.com/v1/completions -H "Content-Type: application/json" -H "Authorization: Bearer ${APIKEY}" -d "{\"model\": \"text-davinci-003\",\"prompt\": \"${SAY}\",\"temperature\": 0.8,\"max_tokens\": ${SOFTL},\"top_p\": 1,\"frequency_penalty\": 0,\"presence_penalty\": 0}"  > res.txt
cat res.txt | tr -d "\'" | tr -d "\`" | tr -d "\;" | tr -d '\&' > res2.txt
cat res2.txt | jq -r '.choices[].text' |  sed -e 's|\\n||g' | tr -d '\n' > /var/www/html/said/${CALLR}
SAID=$(cat /var/www/html/said/${CALLR} | sed -e 's/[^\.]$/.../'  | tr -d '\n' | cut -c ${HARDL})
echo $SAID https://gpt3.oxasploits.com/said/${CALLR}
else
echo "You cannot use that command."
fi
