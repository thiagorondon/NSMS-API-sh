#!/bin/sh

# http://www.nsms.com.br
# Criado por Thiago Rondon, 2011.
#
# Script para envio de SMS via comando, para mais informações use ./nsms.sh -h
#


base_url=http://api.nsms.com.br/api
prog_name=nsms.sh

E_NOACTION=60
E_NOCURL=61

hash curl 2>&- || { echo >&2 "$prog_name require curl but it's not installed."; exit $E_NOCURL; }

while getopts b:u:p:t:e:m: option; do
	case $option in
		b) base_url=$OPTARG;;
		u) username=$OPTARG;;
		p) password=$OPTARG;;
		t) to=$OPTARG;;
		m) message=$OPTARG;;
		e) extra=$OPTARG;;
		h|?) cat >&2 <<EOF
Usage: $prog_name
	-b BASE_URL, default is $base_url
	-u USERNAME
	-p PASSWORD
	-t TO (destination of SMS)
	-e EXTRA
	-m MESSAGE
EOF
	esac
done

function auth {
	url="$base_url/auth/$username/$password"
	curl -L -X GET "$url"
}

function send {
	url="$base_url/get/json?to=55$to&extra=$extra"
	curl --data-urlencode "content=$message" -L -X GET "$url"
}

if [ ! -z $username ] ; then
	run=1
	auth
fi

if [ ! -z $to ] ; then
	run=1
	send
fi

if [ -z "$run" ] ; then
	echo "You need to pass username and password to authentication."
	echo "You need to pass to and message to send a sms."
	exit $NO_ACTION
else
	exit 0
fi


