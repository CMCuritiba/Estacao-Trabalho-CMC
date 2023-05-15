#!/bin/bash

# Cria os diretórios de configuração
mkdir -p /etc/dconf/profile
mkdir -p /etc/dconf/db/local.d/

# Seta o local do arquivo de config (local, ou seja, ficará em /db/local.d)
echo "user-db:user
system-db:local" > /etc/dconf/profile/user

# Senha login remoto
VNCPASS64=$(echo -e "$PASS_VNC" | base64);

# Configurações em si. Cuidado com os escapes de "
echo -e "
[org/nemo/window-state]
start-with-sidebar=true
start-with-toolbar=true
start-with-status-bar=true

# Configurações de acesso remoto
[org/gnome/desktop/remote-access]
icon-visibility='client'
authentication-methods=['vnc']
enabled=true
vnc-password='$VNCPASS64'

# Habilita o screensaver para exibir data e hora
[org/cinnamon/desktop/screensaver]
use-custom-format=true
date-format='%a %e %b, %H:%M'

[org/cinnamon/desktop/interface]
clock-show-date=true

[org/gnome/terminal/legacy/profiles:/default]
background-color='#FFFFFFFFDDDD'
palette='#2E2E34343636:#CCCC00000000:#4E4E9A9A0606:#C4C4A0A00000:#34346565A4A4:#757550507B7B:#060698209A9A:#D3D3D7D7CFCF:#555557575353:#EFEF29292929:#8A8AE2E23434:#FCFCE9E94F4F:#72729F9FCFCF:#ADAD7F7FA8A8:#3434E2E2E2E2:#EEEEEEEEECEC'
bold-color='#000000000000'
foreground-color='#000000000000'
visible-name='Padrão'

# Updates não devem ser visíveis
[com/linuxmint/updates]
hide-kernel-update-warning=true
hide-systray=true
hide-window-after-update=true
#level1-is-visible=false
#level1-is-safe=true
#level2-is-visible=false
#level2-is-safe=true
#level3-is-visible=false
#level3-is-safe=false
#level4-is-visible=false
#level4-is-safe=false
#level5-is-safe=false
#level5-is-visible=false
#kernel-updates-are-visible=false
#kernel-updates-are-safe=false
#security-updates-are-safe=false
#security-updates-are-visible=true
#show-policy-configuration=false

[com/linuxmint/mintmenu/plugins/applications]
last-active-tab=1

# Desabilita linha de comando
[org/gnome/desktop/lockdown]
disable-command-line=true

# Numlock ativado
[org/cinnamon/settings-daemon/peripherals/keyboard]
numlock-state='on'

# Terminal de root
[org/cinnamon/desktop/keybindings/custom-keybindings/custom0]
binding=['<Primary><Shift><Alt>t']
command='/usr/local/cmc/scripts/root-terminal.sh'
name='Terminal de root'

[org/nemo/preferences]
show-open-in-terminal-toolbar=false

[org/cinnamon/desktop/keybindings]
custom-list=['custom0']

# Sons do Sistema
[org/cinnamon/desktop/sound]
volume-sound-enabled=false
event-sounds=false

[org/cinnamon/sounds]
login-enabled=false
logout-enabled=false
switch-enabled=false
plug-enabled=false
unplug-enabled=false
tile-enabled=false

[com/linuxmint/mintmenu]
plugins-list=['places', 'system_management', 'newpane', 'applications', 'newpane', 'recent']
applet-text='Menu'

# Lixeira no desktop
[org/nemo/desktop]
trash-icon-visible=true

# Atalhos do menu
[com/linuxmint/mintmenu/plugins/places]
show-gtk-bookmarks=false
show-network=false

# Atalho para usuário (Encerrar sessão, bloquear tela, trocar usuário)
[org/cinnamon]
enabled-applets=['panel1:left:0:menu@cinnamon.org:0', 'panel1:left:1:show-desktop@cinnamon.org:1', 'panel1:left:2:grouped-window-list@cinnamon.org:2', 'panel1:right:1:systray@cinnamon.org:3', 'panel1:right:2:xapp-status@cinnamon.org:4', 'panel1:right:3:notifications@cinnamon.org:5', 'panel1:right:4:printers@cinnamon.org:6', 'panel1:right:5:removable-drives@cinnamon.org:7', 'panel1:right:6:keyboard@cinnamon.org:8', 'panel1:right:7:network@cinnamon.org:9', 'panel1:right:8:sound@cinnamon.org:10', 'panel1:right:9:power@cinnamon.org:11', 'panel1:right:10:calendar@cinnamon.org:12', 'panel1:right:1:user@cinnamon.org:13', 'panel1:right:0:weather@mockturtl:14']
next-applet-id='15'

[com/linuxmint/mintmenu/plugins/system_management]
show-lock-screen=true
show-control-center=false
show-terminal=false
show-software-manager=false
show-package-manager=false

# Background padrão
[org/cinnamon/desktop/background]
picture-uri='file:///usr/share/backgrounds/cmc/desktop-bg.png'
#'file:///usr/share/backgrounds/linuxmint/default_background.jpg'

# 'Impressora Adicionada' aparece a todo momento, ainda não foi resolvido
[org/gnome/settings-daemon/plugins/print-notifications]
active=false

# Desabilita notificação de rede On/Off
[org/gnome/nm-applet]
disable-disconnected-notifications=true
disable-connected-notifications=true

# Num de desktops em 1 por padrão no Gnome
[org/gnome/desktop/wm/preferences]
num-workspaces=1" > /etc/dconf/db/local.d/01-cmc

# Applet de calendario
echo -e "{
    \"section1\": {
        \"type\": \"section\",
        \"description\": \"Display\"
    },
    \"show-week-numbers\" : {
        \"type\" : \"switch\",
        \"default\" : false,
        \"description\": \"Show week numbers in calendar\",
        \"tooltip\": \"Check this to show week numbers in the calendar.\"
    },
    \"use-custom-format\" : {
        \"type\" : \"switch\",
        \"default\" : true,
        \"description\": \"Use a custom date format\",
        \"tooltip\": \"Check this to define a custom format for the date in the calendar applet.\",
        \"value\": true
    },
    \"custom-format\" : {
        \"type\" : \"entry\",
        \"default\" : \"%a %e %b, %H:%M\",
        \"description\" : \"Date format\",
        \"indent\": true,
        \"dependency\" : \"use-custom-format\",
        \"tooltip\" : \"Set your custom format here.\",
        \"value\": \"%a %e %b, %H:%M\"
    },
    \"format-button\" : {
        \"type\" : \"button\",
        \"description\" : \"Show information on date format syntax\",
        \"indent\": true,
        \"dependency\" : \"use-custom-format\",
        \"callback\" : \"on_custom_format_button_pressed\",
        \"tooltip\" : \"Click this button to know more about the syntax for date formats.\"
    },
    \"section2\": {
        \"type\": \"section\",
        \"description\": \"Keyboard shortcuts\"
    },
    \"keyOpen\": {
        \"type\": \"keybinding\",
        \"description\": \"Show calendar\",
        \"default\": \"<Super>c\",
        \"tooltip\" : \"Set keybinding(s) to show the calendar.\"
    }
}" > /usr/share/cinnamon/applets/calendar@cinnamon.org/settings-schema.json

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
