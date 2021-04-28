#!/bin/bash
read -p "Database Host [localhost]: " DB_HOST
read -p "Database Port [3306]: " DB_PORT
read -p "Database Name [zabbix]: " DB_NAME
read -p "Database User [zabbix]: " DB_USER
read -s -p "Database Password [zabbix]: " DB_PASS

if [ "$DB_HOST" = "" ]
then
        DB_HOST=localhost
else
                        :
fi
if [ "$DB_PORT" = "" ]
then
        DB_PORT=3306
else
                        :
fi
if [ "$DB_NAME" = "" ]
then
        DB_NAME=zabbix
else
                        :
fi
if [ "$DB_USER" = "" ]
then
        DB_USER=zabbix
else
                        :
fi
if [ "$DB_PASS" = "" ]
then
        DB_PASS=zabbix
else
                        :
fi

echo ""
echo ""
echo "Select Authention Type"
echo "0 - Internal"
echo "1 - LDAP"
read -p "Please Input: " AUTHTYPE
echo ""
if [ "$AUTHTYPE" = "0" ]
	then
		:
elif [ "$AUTHTYPE" = "1" ]
	then
		:
else
	echo "There was an error"
	exit
fi

mysql -u ${DB_USER} -p${DB_PASS} \
	-h ${DB_HOST} -P ${DB_PORT} \
	-D ${DB_NAME} \
	--execute="update zabbix.config set authentication_type='${AUTHTYPE}' where configid='1'";
