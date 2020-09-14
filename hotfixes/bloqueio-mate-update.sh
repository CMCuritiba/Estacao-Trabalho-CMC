#!/bin/bash

# Se houver dif no grupo sudoers atualiza para dtic
if grep -w "dif" /etc/sudoers; then
	sed -i 's/dif/dtic/g' /etc/sudoers

	# Cria uma ACL para que dtic possa abrir terminal (executado dentro do IF para evitar que seja executado toda vez que o PC seja inicializado.)
	setfacl -m g:dtic:rx /usr/bin/mate-terminal
	setfacl -m g:dtic:rx /usr/bin/mate-desktop-item-edit
	setfacl -m g:dtic:rx /usr/bin/nm-connection-editor
	setfacl -m g:dtic:rx /usr/bin/ccsm
	setfacl -m g:dtic:rx /usr/bin/mate-network-properties
fi