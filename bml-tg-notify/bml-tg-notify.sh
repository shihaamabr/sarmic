#!/bin/bash
#EDIT THESE:
BML_USERNAME=''
BML_PASSWORD=''
BML_ACCOUNTID=''
TG_BOT_TOKEN=''
TG_CHATID=''

TG_BOTAPI='https://api.telegram.org/bot'
BML_URL='https://www.bankofmaldives.com.mv/internetbanking/api'
mkdir -p ~/.cache/bml-cli/
COOKIE=~/.cache/bml-cli/cookie
LOGIN=$(curl -s -c $COOKIE $BML_URL/login \
	--data-raw username=$BML_USERNAME \
	--data-raw password=${BML_PASSWORD} \
	--compressed \
		| jq -r .code)
if [ "$LOGIN" = "0" ]
        then
		:
else
	echo Something went wrong
	exit
fi
curl -s -b $COOKIE $BML_URL/profile > /dev/null
while true; do
CHECKDIFF1=$(echo $HISTORY | wc -c)
HISTORY=$(curl -s -b $COOKIE $BML_URL/account/$BML_ACCOUNTID/history/today | jq -r '.payload | .history | .[]')
CHECKDIFF2=$(echo $HISTORY | wc -c)
if [ "$CHECKDIFF1" = "$CHECKDIFF2" ]
	then
	echo nothing new..checking again
else
	TRANSFERAMOUNT=$(echo $HISTORY | jq -r .amount | head -n1)
	TRANFERFROM=$(echo $HISTORY | jq -r .narrative3 | head -n1)
	echo $TRANFERFROM
	echo $TRANSFERAMOUNT
	TRANFERFROM=`echo "$TRANFERFROM" | sed "s/ /%20/"`
	curl -s ''${TG_BOTAPI}''${TG_BOT_TOKEN}'/sendMessage?chat_id='${TG_CHATID}'&text=From:'${TRANFERFROM}'MVR:'${TRANSFERAMOUNT}'' > /dev/null
fi
sleep 30
done
