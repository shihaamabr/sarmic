#!/bin/bash

#import credentials
source .env

#
DATETIME="$(date +'%d-%m-%Y_%H:%M:%S')"
GZFILE=$DB_DATABASE-$DATETIME.sql.gz

#change working directory to temporary
cd /tmp/

#dump the database to compressed .sql.gz file
mysqldump --opt --user=$DB_USERNAME --password=$DB_PASSWORD $DB_DATABASE | gzip > $GZFILE

#send to gzip file to telegram
curl -s -F document=@$GZFILE https://api.telegram.org/bot$TG_BOT_TOKEN/sendDocument?chat_id=$TG_CHATID

#delete .gzip file
rm $GZFILE
