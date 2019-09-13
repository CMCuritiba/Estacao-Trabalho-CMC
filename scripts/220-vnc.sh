#!/bin/bash

# Atualiza o launcher do vino-server para que inicie automaticamente
if [ ! -f /etc/xdg/autostart/vino-server.desktop ]; then
	echo '[Desktop Entry]
Type=Application
Terminal=false
Name=Vino
Exec=/usr/lib/vino/vino-server --sm-disable
X-MATE-Autostart-enabled=true' > /etc/xdg/autostart/vino-server.desktop
elif ! grep -q "X-MATE-Autostart-enabled=true" /etc/xdg/autostart/vino-server.desktop; then
	echo 'X-MATE-Autostart-enabled=true' >> /etc/xdg/autostart/vino-server.desktop;
fi


# Faz usuario habilitar vino toda vez que ligar
# Desabilitado pq tem lock
#echo "gsettings set org.gnome.Vino enabled true" >> /etc/skel/.profile
