#!/bin/bash
# Desabilita o autostart da mensagem de bem vinda, do update manager e mintreport
mv /etc/xdg/autostart/mintupdate.desktop /etc/xdg/autostart/mintupdate.desktop.disable
mv /etc/xdg/autostart/mintwelcome.desktop /etc/xdg/autostart/mintwelcome.desktop.disable
mv /etc/xdg/autostart/mintreport.desktop /etc/xdg/autostart/mintreport.desktop.disable

# Adiciona ao autostart o ownCloud
echo '[Desktop Entry]
Type=Application
Terminal=false
Name=ownCloud
Exec=owncloud
Icon=owncloud
Icon[pt_BR]=owncloud
Name[pt_BR]=ownCloud
X-MATE-Autostart-enabled=true' > /etc/xdg/autostart/owncloud.desktop

echo '[Desktop Entry]
Type=Application
Terminal=false
Name=InstantMsg
Exec=bash /usr/local/cmc/scripts/instant.msg.sh
Name[pt_BR]=InstantMsg
X-MATE-Autostart-enabled=true' > /etc/xdg/autostart/instant.msg.desktop

echo '[Desktop Entry]
Type=Application
Terminal=false
Name=ForceLogout
Exec=/usr/local/cmc/scripts/forcelogout.sh
X-MATE-Autostart-enabled=true' > /etc/xdg/autostart/forcelogout.desktop
