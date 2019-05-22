#!/bin/bash
#Desabilita o cache do systemd-resolved

if [ -f /etc/systemd/resolved.conf ]; then

	sed -i 's|^Cache=yes|Cache=no|g' /etc/systemd/resolved.conf;

	
	if ! grep '^Cache=no' /etc/systemd/resolved.conf; then
		echo "Cache=no" >> /etc/systemd/resolved.conf;
	fi
fi
