#!/bin/bash
if [ -f /etc/NetworkManager/NetworkManager.conf ]; then
	# Comenta o dnsmasq
	sed -i 's|^dns=dnsmasq|#dns=dnsmasq|g' /etc/NetworkManager/NetworkManager.conf
fi

