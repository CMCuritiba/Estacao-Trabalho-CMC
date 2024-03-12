#!/bin/bash

# Configuração do nsswitch
if ! cmp -s /etc/nsswitch.conf ../arquivos/nsswitch.conf.template; then
    cp -f --backup=t ../arquivos/nsswitch.conf.template /etc/nsswitch.conf
fi

# Automatiza a criação do diretório HOME após o login
# Por default, utiliza:
#   umask=0022
#   skel=/etc/skel
pam-auth-update --force --enable mkhomedir
