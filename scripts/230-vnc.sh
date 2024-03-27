#!/bin/bash

# Atualiza o launcher do vino-server para que inicie automaticamente
VINO="/etc/xdg/autostart/vino-server.desktop"
if [ ! -f "$VINO" ]; then
    echo '[Desktop Entry]
Type=Application
Terminal=false
Name=Vino
Exec=/usr/lib/vino/vino-server --sm-disable
X-GNOME-Autostart-enabled=true' >"$VINO"
elif ! grep -q "X-GNOME-Autostart-enabled=true" "$VINO"; then
    echo 'X-GNOME-Autostart-enabled=true' >>"$VINO"
fi
