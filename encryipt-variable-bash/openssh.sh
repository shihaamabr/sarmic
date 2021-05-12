read -p 'Username: ' BML_USERNAME
read -s -p 'Enter Pin: ' PIN
read -s -p 'Repeat Pin: ' REPEAT_PIN

if [ "$PIN" = "$REPEAT_PIN" ]
	then
		echo $BML_USERNAME | PASS=$(openssl aes-256-cbc -a -salt -pass pass:$PIN)
		echo $PASS > bruh
else
	echo "Pin do not match"
fi
