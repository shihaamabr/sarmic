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
	echo Something went wrong.. Probably your account locked or wrong username password OR your IP Blocked by CF
	exit
fi

CHECKDIFF1=$(echo $HISTORY | wc -c)
HISTORY=$(curl -s -b $COOKIE $BML_URL/account/$BML_ACCOUNTID/history/today | jq -r '.payload | .history | .[]')
CHECKDIFF2=$(echo $HISTORY | wc -c)
DELAY=$(cat delay)

if [ "$CHECKDIFF1" != "$CHECKDIFF2" ]
then
	DESCRIPTION=$(echo $HISTORY | jq -r .description | head -n1)
	AMOUNT=$(echo $HISTORY | jq -r .amount | head -n1)
	if [ "$DESCRIPTION" = "Transfer Credit" ]
	then
		FROMTO=From
		ENTITY=$(echo $HISTORY | jq -r .narrative3 | head -n1)
	elif [ "$DESCRIPTION" = "Transfer Debit" ]
	then
		FROMTO=To
		ENTITY=$(echo $HISTORY | jq -r .narrative3 | head -n1)
	elif [ "$DESCRIPTION" = "Salary" ]
	then
		FROMTO=From
		ENTITY=$(echo $HISTORY | jq -r .narrative2 | head -n1)
	fi
	echo $DESCRIPTION
	echo $FROMTO: $ENTITY
	echo $CURRENCY: $AMOUNT
	DESCRIPTION=`echo $DESCRIPTION | sed "s/ /%20/g"` #Fix spaces
	ENTITY=`echo $ENTITY | sed "s/ /%20/g"` #Fix spaces
	TGTEXT=$(echo $DESCRIPTION%0A$FROMTO:%20$ENTITY%0A$CURRENCY:%20$AMOUNT)
	curl -s $TG_BOTAPI$TG_BOT_TOKEN/sendMessage?chat_id=$TG_CHATID'&'text=$TGTEXT > /dev/null
	echo "Next check in $DELAY seconds"
else
	echo "nothing new..checking again in $DELAY seconds"
fi
sleep $DELAY
done
