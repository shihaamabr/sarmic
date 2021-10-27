#!/bin/bash

#Import Credentials
source .env 2> /dev/null

fetchzoneid(){
        FETCHZONEID=$(curl -s $CF_API_URL/zones?name=$CF_ROOT_ZONE \
                        -H Content-Type:application/json \
                        -H X-Auth-Key:$CF_API_KEY \
                        -H X-Auth-Email:$CF_EMAIL)
        CF_ZONE_ID=$(echo $FETCHZONEID  | jq -r '.result | .[] | .id')
}

fetchdnsid(){
        FETCHDNSID=$(curl -s $CF_API_URL/zones/$CF_ZONE_ID/dns_records?name=$CF_DOMAIN \
                        -H Content-Type:application/json \
                        -H X-Auth-Key:$CF_API_KEY \
                        -H X-Auth-Email:$CF_EMAIL)
        CF_DNS_ID=$(echo $FETCHDNSID | jq -r '.result | .[] | .id')
}

getip(){
        MY_IP=$(curl -s $WHATISMYIP)
}
getdatetime(){
        TIME=$(date)
}
updateip(){
        curl -s -X PUT $CF_API_URL/zones/$CF_ZONE_ID/dns_records/$CF_DNS_ID \
                -H Content-Type:application/json \
                -H X-Auth-Key:$CF_API_KEY \
                -H X-Auth-Email:$CF_EMAIL \
                --data '{"type":"A","name":"'${CF_DOMAIN}'","content":"'${MY_IP}'","ttl":120,"proxied":false}' > /dev/null
}

fetchzoneid
fetchdnsid
while true; do
        getip
        updateip
        getdatetime
        (echo $MY_IP - $TIME) |  tee -a ip.log
        sleep $DELAY
done
