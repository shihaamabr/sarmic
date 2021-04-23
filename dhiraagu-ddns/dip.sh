#!/bin/bash
source .env

DHIRAAGU_LOGIN_URL='https://portal.dhivehinet.net.mv/adsls/login_api'
DHIRAAGU_HOME_URL='https://portal.dhivehinet.net.mv/home'



AUTH=$(curl -s -c /tmp/dcookies \
    	 --data-urlencode data[adsl][username]=$DHIRAAGU_USERNAME \
    	 --data-urlencode data[adsl][password]=$DHIRAAGU_PASSWORD \
		$DHIRAAGU_LOGIN_URL \
			| awk -F ',' '{print $2}' \
			| cut --complement -d ':' -f 1)

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


DHIRAAGU_IP=$(curl -s -b /tmp/dcookies \
		 $DHIRAAGU_HOME_URL \
			| grep 'IP Address' -A1 \
			| tail -n1 \
			| awk '{print $2}' \
			| cut -f1 -d '<' \
			| cut --complement -d '>' -f 1)

echo IP Address = $DHIRAAGU_IP

rm /tmp/dcookies
