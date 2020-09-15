#!/bin/bash
# Bloqueia a execução do mate-terminal pelos demais usuários
chmod 700 /usr/bin/mate-terminal

#Remove execução do Mintupdate
chmod 700 /usr/bin/mintupdate #update automatico

#Remove execução do Mintreport
chmod 700 /usr/bin/mintreport #reporta problemas e atualizações de versão

# Remove execução do editor de permissões usuário dconf-editor
#chmod 700 /usr/bin/dconf-editor #editor de permissões usuário
# Não vem instalado por padrão

# Remove execução do programa editor de itens do menu, menulibre
#chmod 700 /usr/bin/menulibre

# Remove execução do editor de cada item do menu, mate-desktop-item-edit
chmod 700 /usr/bin/mate-desktop-item-edit

# Remove execução do compiz
chmod 700 /usr/bin/ccsm

# Desabilita edição de conexão:
chmod 700 /usr/bin/nm-connection-editor 

# Desabilita editor de proxy
chmod 700 /usr/bin/mate-network-properties

#desabilita gnome-keyring
chmod 700 /usr/bin/gnome-keyring
chmod 700 /usr/bin/gnome-keyring-3
chmod 700 /usr/bin/gnome-keyring-daemon

# Cria uma ACL para que suporte possa abrir terminal
setfacl -m u:suporte:rwx /usr/bin/mate-terminal

# Cria uma ACL para que dtic possa abrir terminal
setfacl -m g:dtic:rx /usr/bin/mate-terminal
setfacl -m g:dtic:rx /usr/bin/mate-desktop-item-edit
setfacl -m g:dtic:rx /usr/bin/nm-connection-editor
setfacl -m g:dtic:rx /usr/bin/ccsm
setfacl -m g:dtic:rx /usr/bin/mate-network-properties

# Adiciona dtic ao sudoers caso não exista
if ! grep -w "dtic" /etc/sudoers; then
	sed -i '/%sudo/a%dtic\tALL=(ALL:ALL) ALL' /etc/sudoers
fi

# Adiciona o suporte ao sudoers caso não exista
if ! grep -w "suporte" /etc/sudoers; then
	echo 'suporte   ALL=(ALL:ALL) ALL' >> /etc/sudoers
fi
