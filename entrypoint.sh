#!/bin/bash
set -e

opts=(
	dc_local_interfaces '0.0.0.0 ; ::0'
	dc_other_hostnames ''
	dc_relay_nets "$(ip addr show dev eth0 | awk -v ORS=':' '$1 == "inet" { print $2 }' | rev | cut -c 2- | rev)"
)

if [ "$GMAIL_USER" -a "$GMAIL_PASSWORD" ]; then
	# see https://wiki.debian.org/GmailAndExim4
	opts+=(
		dc_eximconfig_configtype 'smarthost'
		dc_smarthost 'smtp.gmail.com::587'
	)
	echo "*.google.com:$GMAIL_USER:$GMAIL_PASSWORD" > /etc/exim4/passwd.client
else
  if [ "$COMPANY_USER" -a "$COMPANY_PASSWORD" ]; then
	opts+=(
		dc_eximconfig_configtype 'satellite'
		dc_smarthost '$COMPANY_SMARTHOST::587'
	)  
  else
	  opts+=(
  		dc_eximconfig_configtype 'internet'
	  )
fi

set-exim4-update-conf "${opts[@]}"

exec "$@"
