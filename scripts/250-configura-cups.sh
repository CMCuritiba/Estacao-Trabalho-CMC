#!/bin/bash

CUPSD="/etc/cups/cupsd.conf"
CUPS_BROWSED="/etc/cups/cups-browsed.conf"

# Garante acesso vindo da TI
if ! grep -q "$DTIC_NETWORK" "$CUPSD"; then
    # sed -i "/^<Location.*/a \ \ Allow @LOCAL\n  Allow $DTIC_NETWORK" "$CUPSD"
    sed -i "s|Allow @LOCAL|Allow @LOCAL\n  Allow $DTIC_NETWORK|g" "$CUPSD"
fi

# Desativa o discovery do cups
if ! grep -q "^BrowseRemoteProtocols none" "$CUPS_BROWSED"; then
    if grep -q "^BrowseRemoteProtocols" "$CUPS_BROWSED"; then
        sed -i '/^BrowseRemoteProtocols/c\BrowseRemoteProtocols none' "$CUPS_BROWSED"
    else
        # Garante que a linha não está comentada
        echo 'BrowseRemoteProtocols none' >>"$CUPS_BROWSED"
    fi
fi

service cups restart
service cups-browsed restart
cupsctl --remote-admin
