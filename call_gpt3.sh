SAY="$1"
APIKEY="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"
echo "${SAY}" >> gpt3.log;
LEN="65";
RES=$(curl -s https://api.openai.com/v1/completions -H "Content-Type: application/json" -H "Authorization: Bearer ${APIKEY}" -d "{\"model\": \"text-davinci-003\",\"prompt\": \"${SAY}\",\"temperature\": 0.8,\"max_tokens\": ${LEN},\"top_p\": 1,\"frequency_penalty\": 0,\"presence_penalty\": 0}" | jq -r '.choices[].text')
echo ${RES} | sed -e 's|\\n||g' | sed -e 's/[^\.]$/.../'  | cut -c -400 | tee -a gpt3.log
