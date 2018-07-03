#!/bin/bash

# Garante que a linha não está comentada

# Desativa o discovery do cups
if ! grep -q "^BrowseRemoteProtocols none" /etc/cups/cups-browsed.conf; then
	echo 'BrowseRemoteProtocols none' >> /etc/cups/cups-browsed.conf;
fi

service cups restart
service cups-browsed restart
cupsctl --remote-admin
