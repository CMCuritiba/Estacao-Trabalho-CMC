#!/bin/bash
# Bloqueia a execução do gnome-terminal pelos demais usuários
chmod 700 /usr/bin/gnome-terminal

#Remove execução do Mintupdate
#chmod 700 /usr/bin/mintupdate #update automatico

#Remove execução do Mintreport
chmod 700 /usr/bin/mintreport #reporta problemas e atualizações de versão

# Remove execução do editor de permissões usuário dconf-editor
#chmod 700 /usr/bin/dconf-editor #editor de permissões usuário
# Não vem instalado por padrão

# Remove execução do programa editor de itens do menu, menulibre
#chmod 700 /usr/bin/menulibre

# Remove execução do editor de cada item do menu, cinnamon-desktop-item-edit
chmod 700 /usr/bin/cinnamon-desktop-editor

# Remove execução do compiz --> Cinnamon é um fork do Gnome-Shell e ainda não suporta o Compiz.
#Fonte: https://plus.diolinux.com.br/t/compiz-nao-roda-no-linux-mint-19-1-cinnamon/619
#chmod 700 /usr/bin/ccsm

# Desabilita edição de conexão:
chmod 700 /usr/bin/nm-connection-editor

# Desabilita editor de proxy/rede
#chmod 700 /usr/bin/mate-network-properties
chmod 700 /usr/bin/nm-applet

#desabilita gnome-keyring - fica pedindo senha de root para usuários
chmod 700 /usr/bin/gnome-keyring
chmod 700 /usr/bin/gnome-keyring-3
chmod 700 /usr/bin/gnome-keyring-daemon

# Adiciona dtic ao sudoers caso não exista
if ! grep -w "dtic" /etc/sudoers; then
    sed -i '/%sudo/a%dtic\tALL=(ALL:ALL) ALL' /etc/sudoers
fi

# Cria uma ACL para ajustar as permissões do usuário suporte
setfacl -m u:suporte:rwx /usr/bin/gnome-terminal
setfacl -m u:suporte:rx /usr/bin/cinnamon-desktop-editor
setfacl -m u:suporte:rx /usr/bin/nm-connection-editor
setfacl -m u:suporte:rx /usr/bin/nm-applet

# Cria uma ACL para ajustar as permissões do grupo dtic
setfacl -m g:dtic:rx /usr/bin/gnome-terminal
setfacl -m g:dtic:rx /usr/bin/cinnamon-desktop-editor
setfacl -m g:dtic:rx /usr/bin/nm-connection-editor
setfacl -m g:dtic:rx /usr/bin/nm-applet

if ! command -v xmlstarlet >/dev/null 2>&1; then
    apt-get -qyf install xmlstarlet
fi

# Assegura permissão de montagem de dispositivos externos (pendrives, HDs, etc)
udisks_policy="/usr/share/polkit-1/actions/org.freedesktop.UDisks2.policy"
for fsm in {filesystem-mount,filesystem-unmount-others,filesystem-mount-system}; do
    for defaul_acl in {allow_any,allow_inactive,allow_active}; do
        xmlstarlet edit --inplace \
            --update "//policyconfig/action[@id='org.freedesktop.udisks2.$fsm']/defaults/$defaul_acl" \
            --value 'yes' \
            "$udisks_policy"
    done
done
