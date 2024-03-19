#!/bin/bash

# Cria os diretórios de configuração
mkdir -p /etc/dconf/profile
mkdir -p /etc/dconf/db/local.d/

# Seta o local do arquivo de config (local, ou seja, ficará em /db/local.d)
echo "user-db:user
system-db:local" > /etc/dconf/profile/user

# Senha login remoto
VNCPASS64="\'$(echo -e "$VNP_PASS" | base64 -w0)\'"

cp -f ../arquivos/dconf.template /etc/dconf/db/local.d/01-cmc
sed -i 's/^vnc-password=.*$/vnc-password='"$VNCPASS64"'/' \
    /etc/dconf/db/local.d/01-cmc

# Applet de calendario
CALJSON="/usr/share/cinnamon/applets/calendar@cinnamon.org/settings-schema.json"
if [ -f "$CALJSON" ]; then
    cp -a "$CALJSON" "$CALJSON-$(date +%F%R)"
    # jq '."use-custom-format".default = true' "$CALJSON" >calendar.tmp && mv calendar.tmp "$CALJSON"
    # jq '."custom-format".default = "%A, %e %B %Y, %H:%M"' "$CALJSON" >calendar.tmp && mv calendar.tmp "$CALJSON"
    jq '."use-custom-format" += {"value": true}' "$CALJSON" >calendar.tmp && mv calendar.tmp "$CALJSON"
    jq '."custom-format" += {"value": "%A, %e %B %Y, %H:%M"}' "$CALJSON" >calendar.tmp && mv calendar.tmp "$CALJSON"
fi

# Trava as configs do Vino
mkdir -p /etc/dconf/db/local.d/locks
echo "/org/gnome/desktop/remote-access/icon-visibility
/org/gnome/desktop/remote-access/authentication-methods
/org/gnome/desktop/remote-access/enabled
/org/gnome/desktop/remote-access/vnc-password" > /etc/dconf/db/local.d/locks/01-cmc

# Copia o script necessario para iniciar o terminal como root
mkdir -p /usr/local/cmc/scripts
cp ../arquivos/root-terminal.sh /usr/local/cmc/scripts/root-terminal.sh
chmod +rx /usr/local/cmc/scripts/root-terminal.sh

# Finalmente, atualiza dconf
dconf update
