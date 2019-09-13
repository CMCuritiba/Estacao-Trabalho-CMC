#!/bin/bash
# Bloqueia a execução do mate-terminal pelos demais usuários
chmod 700 /usr/bin/mate-terminal

#Remove execução do Mintupdate
chmod 700 /usr/bin/mintupdate #update automatico

# Remove execução do editor de permissões usuário dconf-editor
#chmod 700 /usr/bin/dconf-editor #editor de permissões usuário
# Não vem instalado por padrão

# Remove execução do programa editor de itens do menu, menulibre
chmod 700 /usr/bin/menulibre

# Remove execução do editor de cada item do menu, mate-desktop-item-edit
chmod 700 /usr/bin/mate-desktop-item-edit

# Remove execução do compiz
chmod 700 /usr/bin/ccsm

# Desabilita edição de conexão:
chmod 700 /usr/bin/nm-connection-editor 

# Desabilita editor de proxy
chmod 700 /usr/bin/mate-network-properties

# Cria uma ACL para que suporte possa abrir terminal
setfacl -m u:suporte:rwx /usr/bin/mate-terminal
setfacl -m g:dif:rx /usr/bin/mate-terminal
setfacl -m g:dif:rx /usr/bin/menulibre
setfacl -m g:dif:rx /usr/bin/mate-desktop-item-edit
setfacl -m g:dif:rx /usr/bin/nm-connection-editor
setfacl -m g:dif:rx /usr/bin/ccsm
setfacl -m g:dif:rx /usr/bin/mate-network-properties

# Adiciona grupo dif ao sudoers
if ! grep "%dif" /etc/sudoers; then
	sed -i '/%sudo/a%dif\tALL=(ALL:ALL) ALL' /etc/sudoers
fi
