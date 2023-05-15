#!/bin/bash

# Bloqueia a execução do gnome-terminal pelos demais usuários
chmod 700 /usr/bin/gnome-terminal

#Remove execução do Mintupdate
chmod 700 /usr/bin/mintupdate # update automatico

#Remove execução do Mintreport
chmod 700 /usr/bin/mintreport # reporta problemas e atualizações de versão

# Remove execução do programa editor de itens do menu
chmod 700 /usr/bin/cinnamon-menu-editor

# Remove execução do editor de cada item do menu, cinnamon-desktop-item-edit
chmod 700 /usr/bin/cinnamon-desktop-editor

# Desabilita edição de conexão:
chmod 700 /usr/bin/nm-connection-editor

# Desabilita editor de proxy/rede
#chmod 700 /usr/bin/mate-network-properties
chmod 700 /usr/bin/nm-applet

#desabilita gnome-keyring - fica pedindo senha de root para usuários
chmod 700 /usr/bin/gnome-keyring
chmod 700 /usr/bin/gnome-keyring-3
chmod 700 /usr/bin/gnome-keyring-daemon

# Cria uma ACL para ajustar as permissões do usuário suporte
setfacl -m u:suporte:rwx /usr/bin/gnome-terminal
setfacl -m u:suporte:rx /usr/bin/cinnamon-desktop-editor
setfacl -m u:suporte:rx /usr/bin/nm-connection-editor
setfacl -m u:suporte:rx /usr/bin/nm-applet

# Cria uma ACL para ajustar as permissões da DTIC
setfacl -m "g:$DTIC_GIDNUMBER:rx" /usr/bin/gnome-terminal
setfacl -m "g:$DTIC_GIDNUMBER:rx" /usr/bin/cinnamon-desktop-editor
setfacl -m "g:$DTIC_GIDNUMBER:rx" /usr/bin/nm-connection-editor
setfacl -m "g:$DTIC_GIDNUMBER:rx" /usr/bin/nm-applet
