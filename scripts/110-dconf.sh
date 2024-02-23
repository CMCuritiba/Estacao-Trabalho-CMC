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
echo -e '{
    "section1": {
        "type": "section",
        "description": "Display"
    },
    "show-week-numbers" : {
        "type" : "switch",
        "default" : false,
        "description": "Show week numbers in calendar",
        "tooltip": "Check this to show week numbers in the calendar."
    },
    "use-custom-format" : {
        "type" : "switch",
        "default" : true,
        "description": "Use a custom date format",
        "tooltip": "Check this to define a custom format for the date in the calendar applet.",
        "value": true
    },
    "custom-format" : {
        "type" : "entry",
        "default" : "%a %e %b, %H:%M",
        "description" : "Date format",
        "indent": true,
        "dependency" : "use-custom-format",
        "tooltip" : "Set your custom format here.",
        "value": "%a %e %b, %H:%M"
    },
    "format-button" : {
        "type" : "button",
        "description" : "Show information on date format syntax",
        "indent": true,
        "dependency" : "use-custom-format",
        "callback" : "on_custom_format_button_pressed",
        "tooltip" : "Click this button to know more about the syntax for date formats."
    },
    "section2": {
        "type": "section",
        "description": "Keyboard shortcuts"
    },
    "keyOpen": {
        "type": "keybinding",
        "description": "Show calendar",
        "default": "<Super>c",
        "tooltip" : "Set keybinding(s) to show the calendar."
    }
}' | jq . >/usr/share/cinnamon/applets/calendar@cinnamon.org/settings-schema.json

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
