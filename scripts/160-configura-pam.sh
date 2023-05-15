#!/bin/bash

# Configuração do nsswitch
if ! cmp -s /etc/nsswitch.conf ../arquivos/nsswitch.conf.template; then
    cp -f --backup=t ../arquivos/nsswitch.conf.template /etc/nsswitch.conf
fi

# Automatiza a criação do diretório HOME após o login
pam-auth-update --force --enable mkhomedir

# Configuração do PAM para trabalhar com SSSD
if ! cmp -s /etc/pam.d/common-auth ../arquivos/common-auth.template; then
    cp -f --backup=t ../arquivos/common-auth.template /etc/pam.d/common-auth
fi
if ! cmp -s /etc/pam.d/common-account ../arquivos/common-account.template; then
    cp -f --backup=t ../arquivos/common-account.template /etc/pam.d/common-account
fi
if ! cmp -s /etc/pam.d/common-session ../arquivos/common-session.template; then
    cp -f --backup=t ../arquivos/common-session.template /etc/pam.d/common-session
fi
