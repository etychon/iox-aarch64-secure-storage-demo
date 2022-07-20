#!/bin/sh

CAF_SS_ENV_FILE="/data/.env"
if [ -f $CAF_SS_ENV_FILE ]; then
  source $CAF_SS_ENV_FILE
fi

while true

do

# get token (verified)
echo "Getting the TOKEN from SSS service using http://$CAF_SS_IP_ADDR:$CAF_SS_PORT/SS/TOKEN/$CAF_APP_ID/$CAF_SYSTEM_UUID..."
export CAF_SS_TOKEN=`curl  --silent "http://$CAF_SS_IP_ADDR:$CAF_SS_PORT/SS/TOKEN/$CAF_APP_ID/$CAF_SYSTEM_UUID"` && echo $CAF_SS_TOKEN
echo "Got it: $CAF_SS_TOKEN"

# store secure object (verified)
echo "Storing an object in SS..."
curl -s -X POST "http://$CAF_SS_IP_ADDR:$CAF_SS_PORT/SS/$CAF_APP_ID/Object" -H "content-type: multipart/form-data" -F "ss-Token=$CAF_SS_TOKEN" -F "Object-type=Object" -F "object-Name=testKey" -F "ss-Content=testKeyContent"
echo $'\nStoring done.'

# get key content (verified)
echo "Getting the object from SS..."
curl -s -X GET "http://$CAF_SS_IP_ADDR:$CAF_SS_PORT/SS/$CAF_APP_ID/Object?ss-Token=$CAF_SS_TOKEN&object-name=testKey"
echo $'\ndone'

# get list of SS object stored
echo "List of objects in SS:"
curl -s -X GET "http://$CAF_SS_IP_ADDR:$CAF_SS_PORT/SS/$CAF_APP_ID/list?ss-Token=$CAF_SS_TOKEN"
echo $'\n[end]'

# delete object
echo "Deleting object in SS..."
curl -s -X DELETE "http://$CAF_SS_IP_ADDR:$CAF_SS_PORT/SS/$CAF_APP_ID/Object?ss-Token=$CAF_SS_TOKEN&object-name=testKey"
echo $'\nDelete done.'

sleep 5

done
