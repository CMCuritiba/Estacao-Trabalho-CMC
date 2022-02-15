#!/bin/bash

CUPSD="/etc/cups/cupsd.conf"
CUPS_BROWSED="/etc/cups/cups-browsed.conf"

# Altera cupsd.conf para permitir acesso remoto
cupsctl --remote-admin

# Garante acesso vindo da TI
if ! grep -q "$DTIC_NETWORK" "$CUPSD"; then
    cp -af --backup=t "$CUPSD" "$CUPSD-old"
    sed -i "s|Allow @LOCAL|Allow @LOCAL\n  Allow $DTIC_NETWORK|g" "$CUPSD"
fi

# Desativa o discovery do cups
if ! grep -q "^BrowseRemoteProtocols none" "$CUPS_BROWSED"; then
    if grep -q "^BrowseRemoteProtocols" "$CUPS_BROWSED"; then
        cp -af --backup=t "$CUPS_BROWSED" "$CUPS_BROWSED-old"
        sed -i '/^BrowseRemoteProtocols/c\BrowseRemoteProtocols none' "$CUPS_BROWSED"
    else
        # Garante que a linha não está comentada
        echo 'BrowseRemoteProtocols none' >> "$CUPS_BROWSED"
    fi
fi

systemctl restart cups
systemctl restart cups-browsed
