#!/bin/bash
# Desabilita o autostart da mensagem de bem vinda, do update manager e mintreport
mv /etc/xdg/autostart/mintupdate.desktop /etc/xdg/autostart/mintupdate.desktop.disable
mv /etc/xdg/autostart/mintwelcome.desktop /etc/xdg/autostart/mintwelcome.desktop.disable
mv /etc/xdg/autostart/mintreport.desktop /etc/xdg/autostart/mintreport.desktop.disable

# Desabilita o autostart para o gnome-keyring
mv /etc/xdg/autostart/gnome-keyring-pkcs11.desktop /etc/xdg/autostart/gnome-keyring-pkcs11.desktop.disable
mv /etc/xdg/autostart/gnome-keyring-secrets.desktop /etc/xdg/autostart/gnome-keyring-secrets.desktop.disable
mv /etc/xdg/autostart/gnome-keyring-ssh.desktop /etc/xdg/autostart/gnome-keyring-ssh.desktop.disable

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
Name=ForceLogout
Exec=/usr/local/cmc/scripts/forcelogout.sh
X-MATE-Autostart-enabled=true' > /etc/xdg/autostart/forcelogout.desktop
