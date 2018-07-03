#!/bin/bash

# Atualiza o launcher do vino-server para que inicie automaticamente
if ! grep -q "X-MATE-Autostart-enabled=true" /etc/xdg/autostart/vino-server.desktop; then
	echo "X-MATE-Autostart-enabled=true" >> /etc/xdg/autostart/vino-server.desktop
fi

# Faz usuario habilitar vino toda vez que ligar
# Desabilitado pq tem lock
#echo "gsettings set org.gnome.Vino enabled true" >> /etc/skel/.profile
