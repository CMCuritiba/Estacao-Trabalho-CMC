#!/bin/bash

# Cria uma ACL para que dtic possa abrir terminal
setfacl -m g:dtic:rx /usr/bin/mate-terminal
setfacl -m g:dtic:rx /usr/bin/mate-desktop-item-edit
setfacl -m g:dtic:rx /usr/bin/nm-connection-editor
setfacl -m g:dtic:rx /usr/bin/ccsm
setfacl -m g:dtic:rx /usr/bin/mate-network-properties

# Se houver dif no grupo sudoers atualiza para dtic
	if grep -w "dif" /etc/sudoers; then
	sed -i 's/dif/dtic/g' /etc/sudoers

# Adiciona dtic ao sudoers caso não exista
elif ! grep -w "dtic" /etc/sudoers; then
	sed -i '/%sudo/a%dtic\tALL=(ALL:ALL) ALL' /etc/sudoers
fi

# Adiciona o suporte ao sudoers caso não exista
if ! grep -w "suporte" /etc/sudoers; then
	echo 'suporte   ALL=(ALL:ALL) ALL' >> /etc/sudoers
fi
