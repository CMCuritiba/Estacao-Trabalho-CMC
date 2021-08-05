#!/bin/bash

# Garante acesso vindo da TI
if ! grep -q "10\.0\.1\.0" /etc/cups/cupsd.conf; then
    sed -i 's/Allow @LOCAL/Allow @LOCAL\n  Allow 10.0.1.0\/24/g' /etc/cups/cupsd.conf
fi

# Desativa o discovery do cups
if ! grep -q "^BrowseRemoteProtocols none" /etc/cups/cups-browsed.conf; then
    # Garante que a linha não está comentada
    echo 'BrowseRemoteProtocols none' >>/etc/cups/cups-browsed.conf
fi

service cups restart
service cups-browsed restart
cupsctl --remote-admin
