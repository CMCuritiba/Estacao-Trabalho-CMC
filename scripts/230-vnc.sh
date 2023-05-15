#!/bin/bash

# Atualiza o launcher do vino-server para que inicie automaticamente
if [ ! -f /etc/xdg/autostart/vino-server.desktop ]; then
	echo '[Desktop Entry]
Type=Application
Terminal=false
Name=Vino
Exec=/usr/lib/vino/vino-server --sm-disable
X-GNOME-Autostart-enabled=true' > /etc/xdg/autostart/vino-server.desktop
elif ! grep -q "X-GNOME-Autostart-enabled=true" /etc/xdg/autostart/vino-server.desktop; then
	echo 'X-GNOME-Autostart-enabled=true' >> /etc/xdg/autostart/vino-server.desktop;
fi
