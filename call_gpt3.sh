SAY="$1"
# api key
APIKEY="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"
echo "${SAY}" >> gpt3.log;
# these can be adjusted for the lengths, one is a soft and another hard limit.  Soft is words, hard is characters.
HARDL="-400"
SOFTL="65";
# pushes question and pulls response in json
curl -s https://api.openai.com/v1/completions -H "Content-Type: application/json" -H "Authorization: Bearer ${APIKEY}" -d "{\"model\": \"text-davinci-003\",\"prompt\": \"${SAY}\",\"temperature\": 0.8,\"max_tokens\": ${SOFTL},\"top_p\": 1,\"frequency_penalty\": 0,\"presence_penalty\": 0}"  > res.txt
# sanitizes response!
cat res.txt | tr -d "\'" | tr -d "\`" | tr -d "\;" | tr -d '\&' > res2.txt
# parses the json and does some formatting corrections, prints bare response and logs
cat res2.txt | jq -r '.choices[].text' |  sed -e 's|\\n||g' | sed -e 's/[^\.]$/.../'  | tr -d '\n' | tr -d '\' | cut -c ${HARDL} | tee -a gpt3.log
