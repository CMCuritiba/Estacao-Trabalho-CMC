#!/bin/bash

# Configuração do nsswitch
# Substitui linha 'hosts:.*'' e cria um backup
sed -i"-$(date +%F-%T)" 's/^hosts:.*/hosts:\t\tfiles dns/' /etc/nsswitch.conf

# Automatiza a criação do diretório HOME após o login
# Por default, utiliza:
#   umask=0022
#   skel=/etc/skel
pam-auth-update --force --enable mkhomedir
