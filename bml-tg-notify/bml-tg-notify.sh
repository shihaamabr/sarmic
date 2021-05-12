#!/bin/bash
source .env
mkdir -p ~/.cache/bml-cli/
TG_BOTAPI='https://api.telegram.org/bot'
BML_URL='https://www.bankofmaldives.com.mv/internetbanking/api'
COOKIE=~/.cache/bml-cli/cookie

while true; do
LOGIN=$(curl -s -c $COOKIE $BML_URL/login --data-raw username=$BML_USERNAME --data-raw password=${BML_PASSWORD} | jq -r .code)
if [ "$LOGIN" = "0" ]
        then
		PROFILE=$(curl -s -b $COOKIE $BML_URL/profile | jq -r '.payload | .profile | .[] | .profile' | head -n 1)
		curl -s -b $COOKIE $BML_URL/profile --data-raw profile=$PROFILE > /dev/null
else
	echo Something went wrong
	exit
fi

CHECKDIFF1=$(echo $HISTORY | wc -c)
HISTORY=$(curl -s -b $COOKIE $BML_URL/account/$BML_ACCOUNTID/history/today | jq -r '.payload | .history | .[]')
CHECKDIFF2=$(echo $HISTORY | wc -c)

if [ "$CHECKDIFF1" = "$CHECKDIFF2" ]
	then
	echo nothing new..checking again
else
	TRANSFERAMOUNT=$(echo $HISTORY | jq -r .amount | head -n1)
	TRANFERFROM=$(echo $HISTORY | jq -r .narrative3 | head -n1)
	echo From: $TRANFERFROM
	echo MVR: $TRANSFERAMOUNT
	TRANFERFROM=`echo "$TRANFERFROM" | sed "s/ /%20/g"`
	curl -s $TG_BOTAPI$TG_BOT_TOKEN/sendMessage?chat_id=$TG_CHATID'&'text=From:%20$TRANFERFROM%0AMVR:%20$TRANSFERAMOUNT > /dev/null
fi
sleep $SLEEP
done
