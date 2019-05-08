#!/bin/bash

# Atualiza o launcher do vino-server para que inicie automaticamente
if ls /etc/xdg/autostart | grep vino-server.desktop; then
	rm /etc/xdg/autostart/vino-server.desktop
fi

echo '[Desktop Entry]
Type=Application
Terminal=false
Name=Vino
Exec=/usr/lib/vino/vino-server --sm-disable
X-MATE-Autostart-enabled=true' > /etc/xdg/autostart/vino-server.desktop

# Faz usuario habilitar vino toda vez que ligar
# Desabilitado pq tem lock
#echo "gsettings set org.gnome.Vino enabled true" >> /etc/skel/.profile
