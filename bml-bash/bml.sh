#!/bin/bash

source .env

BML_URL='https://www.bankofmaldives.com.mv/internetbanking/api'

curl -s -c /tmp/bmlcookie $BML_URL/login \
	--data-raw username=$BML_USERNAME \
	--data-raw password=$BML_PASSWORD \
	--compressed > /dev/null
echo "Menu"
echo ""
echo "1 - Accounts"
echo "2 - Contacts"
echo "3 - Activities"
echo "4 - Services"
echo ""
printf 'Please Input: '
read -r INPUT1


if [ "$INPUT1" = "1" ]
	then
		curl -s -c /tmp/bmlcookie $BML_URL/dashboard | jq
elif [ "$INPUT1" = "2" ]
	then
		curl -s -b /tmp/bml/cookie $BML_URL/contacts | jq
else
	echo "There was an error"
fi

#curl -s -b /tmp/bmlcookie $BML_URL/contacts | jq
