#!/bin/bash

#Import Credentials
source .env 2> /dev/null

DHIRAAGU_LOGIN_URL='https://portal.dhivehinet.net.mv/adsls/login_api'
DHIRAAGU_HOME_URL='https://portal.dhivehinet.net.mv/home'
CF_API_URL='https://api.cloudflare.com/client/v4'

#Set AUTH, login to generate cookie in /tmp directory and regext to extract AUTH status.
AUTH=$(curl -s -c /tmp/dcookies \
         --data-urlencode data[adsl][username]=$DHIRAAGU_USERNAME \
         --data-urlencode data[adsl][password]=$DHIRAAGU_PASSWORD \
                $DHIRAAGU_LOGIN_URL \
                        | awk -F ',' '{print $2}' \
                        | cut --complement -d ':' -f 1)

#Check if Dhiraagu Username and password is correct before continuing. Print error, delete the cookie and stop script if any errors.
if [ "$AUTH" = "1" ]
        then
                :
elif [ "$AUTH" = "0" ]
        then
                echo "Username or Password incorrect" 1>&2
                rm /tmp/dcookies
                exit
else
                echo "Unknown Error" 1>&2
                rm /tmp/dcookies
                exit
fi

#Set DHIRAAGU_IP, login with generated cookie and some regex to extract Dhiraagu IP address
DHRAAGU_IP=$(curl -s -b /tmp/dcookies \
	 $DHIRAAGU_HOME_URL \
	| grep 'IP Address' -A1 \
	| tail -n1 \
	| awk '{print $2}' \
	| cut -f1 -d '<' \
	| cut --complement -d '>' -f 1)

#Send Dhiraagu IP to cloudflare for DNS update
curl -s -X PUT $CF_API_URL/zones/$CF_ZONE_ID/dns_records/$CF_DNS_RECORDS \
	-H Content-Type:application/json \
	-H X-Auth-Key:$CF_API_KEY \
	-H X-Auth-Email:$CF_EMAIL \
	--data '{"type":"A","name":"'${CF_DOMAIN}'","content":"'${DHIRAAGU_IP}'","ttl":120,"proxied":false}' > /dev/null

#Print IP address to console
echo IP Address = $DHIRAAGU_IP

#delete the cookie from /tmp directory
rm /tmp/dcookies
