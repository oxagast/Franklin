# part of gpt3bot

SAY="$1"
APIKEY="yourapikeygoeshere"
echo "${SAY}" >> gpt3.log;
LEN="60";
curl -s https://api.openai.com/v1/completions -H "Content-Type: application/json" -H "Authorization: Bearer ${APIKEY}" -d "{\"model\": \"text-davinci-003\",\"prompt\": \"${SAY}\",\"temperature\": 0.8,\"max_tokens\": ${LEN},\"top_p\": 1,\"frequency_penalty\": 0,\"presence_penalty\": 0}" | /usr/bin/jq ".choices" | jq  --raw-output "@text" | cut -d '"' -f 4  | sed -e "s/^....//" | sed -e 's|\\n||g' | sed -e 's/[^\.]$/.../'  | cut -c -400 | tee -a gpt3.log
