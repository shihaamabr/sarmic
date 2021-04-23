#!/bin/bash

source .env

BML_URL='https://www.bankofmaldives.com.mv/internetbanking/api'
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

LOGIN=$(curl -s -c /tmp/bmlcookie $BML_URL/login \
	--data-raw username=$BML_USERNAME \
	--data-raw password=$BML_PASSWORD \
	--compressed \
		| awk -F 'success":' '{print $2}' \
		| cut -f1 -d ',' )

if [ "$LOGIN" = "true" ]
        then
                NAME=$(curl -s -b /tmp/bmlcookie $BML_URL/profile \
			| awk -F 'fullname":"' '{print $2}' \
			| cut -f1 -d '"')
		echo ""
		echo ${green}Welcome ${reset}$NAME
		echo ""
elif [ "$LOGIN" = "false" ]
        then
                echo "${red}Username or Password incorrect" 1>&2
                rm /tmp/bmlcookies 2> /dev/null
                exit
else
                echo "${red}Unknown Error" 1>&2
                rm /tmp/bmlcookies 2> /dev/null
                exit
fi

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
		curl -s -b /tmp/bmlcookie $BML_URL/dashboard | jq
elif [ "$INPUT1" = "2" ]
	then
		curl -s -b /tmp/bml/cookie $BML_URL/contacts | jq
else
	echo "${red}There was an error"
fi

#curl -s -b /tmp/bmlcookie $BML_URL/contacts | jq
