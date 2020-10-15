#!/bin/bash
# Cria os diretórios de configuração
mkdir -p /etc/dconf/profile
mkdir -p /etc/dconf/db/local.d/

# Seta o local do arquivo de config (local, ou seja, ficará em /db/local.d)
echo "user-db:user
system-db:local" > /etc/dconf/profile/user

# Senha login remoto
echo -en "Digite a senha para acesso remoto\nSenha:"
read -s VNCPASS
echo ""

VNCPASS64=$(echo -e "$VNCPASS" | base64);

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

# Pequenas alterações
[org/mate/panel/general]
object-id-list=['menu-bar', 'show-desktop', 'separator', 'launcher-firefox-esr', 'launcher-nemo', 'window-list', 'notification-area', 'temperature-clock', 'lock-button']
toplevel-id-list=['bottom']

[org/cinnamon/desktop/applications/terminal]
exec='gnome-terminal'

[org/cinnamon/desktop/applications/at/visual]
exec='orca'

[org/mate/desktop/accessibility/keyboard]
slowkeys-beep-press=true
mousekeys-accel-time=1200
bouncekeys-beep-reject=true
slowkeys-beep-reject=false
togglekeys-enable=false
enable=false
bouncekeys-enable=false
stickykeys-enable=false
feature-state-change-beep=false
slowkeys-beep-accept=true
bouncekeys-delay=300
mousekeys-max-speed=750
mousekeys-enable=false
timeout-enable=false
slowkeys-delay=300
stickykeys-modifier-beep=true
stickykeys-two-key-off=true
mousekeys-init-delay=160
timeout=120
slowkeys-enable=false

# Updates não devem ser visíveis
[com/linuxmint/updates]
level1-is-visible=false
level1-is-safe=true
level2-is-visible=false
level2-is-safe=true
level3-is-visible=false
level3-is-safe=false
level4-is-visible=false
level4-is-safe=false
level5-is-safe=false
level5-is-visible=false
kernel-updates-are-visible=false
kernel-updates-are-safe=false
security-updates-are-safe=false
security-updates-are-visible=true
show-policy-configuration=false

[com/linuxmint/mintmenu/plugins/applications]
last-active-tab=1

# Desabilita linha de comando
[org/cinnamon/desktop/lockdown]
disable-command-line=true

[org/mate/desktop/lockdown]
disable-command-line=true

[org/gnome/desktop/lockdown]
disable-command-line=true

# Numlock ativado
[/org/cinnamon/settings-daemon/peripherals/keyboard]
numlock-state='on'

# Terminal de root
[org/cinnamon/desktop/keybindings/custom-keybindings/custom0]
binding=['<Primary><Shift><Alt>t']
command='/usr/local/cmc/scripts/root-terminal.sh'
name='Terminal de root'

[org/cinnamon/desktop/keybindings]
custom-list=['custom0']

# Abrir no terminal
#[org/nemo/preferences/menu-config]
#background-menu-open-in-terminal=false
#selection-menu-open-in-terminal=false

[org/nemo/preferences]
show-open-in-terminal-toolbar=false

[com/linuxmint/mintmenu]
plugins-list=['places', 'system_management', 'newpane', 'applications', 'newpane', 'recent']
applet-text='Menu '

# Lixeira no desktop
[org/nemo/desktop]
trash-icon-visible=true

# Atalhos do menu
[com/linuxmint/mintmenu/plugins/places]
show-gtk-bookmarks=false
minimized=false
show-network=false

[com/linuxmint/mintmenu/plugins/system_management]
sticky=false
show-lock-screen=true
show-control-center=false
show-terminal=false
show-software-manager=false
show-package-manager=false 

# Background padrão
[org/mate/desktop/background]
picture-filename='/usr/share/backgrounds/cmc/desktop-bg.png'

#Existe Gnome e Cinnamon de opções pelo aplicativo dconf-editor
# Num de desktops em 1 por padrão no Gnome
[org/gnome/desktop/wm/preferences]
num-workspaces=1

# Num de desktops em 1 por padrão no Cinnamon
[org/cinnamon/desktop/wm/preferences]
num-workspaces=1"> /etc/dconf/db/local.d/01-cmc

# Trava as configs do Vino
mkdir -p /etc/dconf/db/local.d/locks
echo "/org/gnome/desktop/remote-access/icon-visibility
/org/gnome/desktop/remote-access/authentication-methods
/org/gnome/desktop/remote-access/enabled
/org/gnome/desktop/remote-access/vnc-password" > /etc/dconf/db/local.d/locks/01-cmc

# Copia o script necessario para iniciar o terminal como root
mkdir -p /usr/local/cmc/scripts
cp ../arquivos/root-terminal.sh /usr/local/cmc/scripts/root-terminal.sh
chmod +x /usr/local/cmc/scripts/root-terminal.sh

# Finalmente, atualiza dconf
dconf update
