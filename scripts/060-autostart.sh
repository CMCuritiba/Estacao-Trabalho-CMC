#!/bin/bash
# Desabilita o autostart da mensagem de bem vinda e do update manager
mv /etc/xdg/autostart/mintupdate.desktop /etc/xdg/autostart/mintupdate.desktop.disable
mv /etc/xdg/autostart/mintwelcome.desktop /etc/xdg/autostart/mintwelcome.desktop.disable

# Adiciona ao autostart o ownCloud e o Psi
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
Version=1.0
Type=Application
Name=Psi
GenericName=XMPP Client
Comment=Communicate over the XMPP network
Icon=psi
Exec=psi %U
MimeType=x-scheme-handler/xmpp;
Terminal=false
StartupWMClass=Psi
Categories=Network;InstantMessaging;Qt;
Keywords=XMPP;Jabber;Chat;InstantMessaging;
X-MATE-Autostart-enabled=true' > /etc/xdg/autostart/psi.desktop

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
