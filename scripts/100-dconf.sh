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
object-id-list=['menu-bar', 'show-desktop', 'separator', 'launcher-firefox-esr', 'launcher-gnome', 'window-list', 'notification-area', 'temperature-clock', 'lock-button']
toplevel-id-list=['bottom']

# Coisinha bunita de temperatura com o relógio
[org/mate/panel/objects/temperature-clock]
applet-iid='ClockAppletFactory::ClockApplet'
toplevel-id='bottom'
position=1
object-type='external-applet'
panel-right-stick=true

# Coisinha bunita de temperatura
[org/mate/panel/objects/temperature-clock/prefs]
show-temperature=true
expand-locations=false
format='24-hour'
cities=['<location name=\"\" city=\"Curitiba\" timezone=\"America/Sao_Paulo\" latitude=\"-25.433332\" longitude=\"-49.266666\" code=\"SBBI\" current=\"true\"/>']
custom-format=''
show-seconds=false
speed-unit='km/h'

[org/mate/panel/toplevels/bottom]
expand=true
orientation='bottom'
screen=0
y-bottom=0
size=24
y=637

# Trocado para ser firefox-esr
[org/mate/panel/objects/launcher-firefox-esr]
locked=true
launcher-location='/usr/share/applications/firefox-esr.desktop'
menu-path='applications:/'
position=50
object-type='launcher-object'
toplevel-id='bottom'

# Botão para travar a tela
[org/cinnamon]
enabled-applets=['panel1:left:0:menu@cinnamon.org:0', 'panel1:left:1:show-desktop@cinnamon.org:1', 'panel1:left:2:grouped-window-list@cinnamon.org:2', 'panel1:right:1:systray@cinnamon.org:3', 'panel1:right:2:xapp-status@cinnamon.org:4', 'panel1:right:3:notifications@cinnamon.org:5', 'panel1:right:4:printers@cinnamon.org:6', 'panel1:right:5:removable-drives@cinnamon.org:7', 'panel1:right:6:keyboard@cinnamon.org:8', 'panel1:right:7:network@cinnamon.org:9', 'panel1:right:8:sound@cinnamon.org:10', 'panel1:right:9:power@cinnamon.org:11', 'panel1:right:10:calendar@cinnamon.org:12', 'panel1:right:0:ScreenLocker@tuuxx:13']
applet-cache-updated=1603119128
next-applet-id=14

# Botão para travar a tela
[org/mate/panel/objects/lock-button]
toplevel-id='bottom'
action-type='lock'
position=223
object-type='action-applet'
panel-right-stick=true

[org/mate/panel/objects/clock/prefs]
format='24-hour'
custom-format=''

[org/mate/panel/objects/separator]
locked=true
toplevel-id='bottom'
position=20
object-type='separator'

[org/mate/panel/objects/launcher-terminal]
locked=true
launcher-location='/usr/share/applications/gnome-terminal.desktop'
menu-path='applications:/'
position=40
object-type='launcher'
toplevel-id='bottom'

[org/mate/panel/objects/menu-bar]
applet-iid='MintMenuAppletFactory::MintMenuApplet'
locked=true
toplevel-id='bottom'
position=0
object-type='applet'

[org/mate/panel/objects/launcher-gnome]
locked=true
launcher-location='/usr/share/applications/gnome-home.desktop'
menu-path='applications:/'
position=30
object-type='launcher'
toplevel-id='bottom'

[org/mate/panel/objects/window-list]
applet-iid='WnckletFactory::WindowListApplet'
locked=true
toplevel-id='bottom'
position=60
object-type='applet'

[org/mate/panel/objects/notification-area]
applet-iid='NotificationAreaAppletFactory::NotificationArea'
locked=true
toplevel-id='bottom'
position=10
object-type='applet'
panel-right-stick=true

[org/mate/panel/objects/show-desktop]
applet-iid='WnckletFactory::ShowDesktopApplet'
locked=true
toplevel-id='bottom'
position=10
object-type='applet'

[org/gnome/terminal/legacy/profiles:/default]
background-color='#FFFFFFFFDDDD'
palette='#2E2E34343636:#CCCC00000000:#4E4E9A9A0606:#C4C4A0A00000:#34346565A4A4:#757550507B7B:#060698209A9A:#D3D3D7D7CFCF:#555557575353:#EFEF29292929:#8A8AE2E23434:#FCFCE9E94F4F:#72729F9FCFCF:#ADAD7F7FA8A8:#3434E2E2E2E2:#EEEEEEEEECEC'
bold-color='#000000000000'
foreground-color='#000000000000'
visible-name='Padrão'

[org/gnome/desktop/applications/terminal]
exec='gnome-terminal'

[org/cinnamon/desktop/applications/terminal]
exec='gnome-terminal'

[org/gnome/desktop/applications/at/visual]
exec='orca'

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
[org/gnome/desktop/lockdown]
disable-command-line=true

# Numlock ativado
[org/gnome/settings-daemon/peripherals/keyboard]
numlock-state=true

# Terminal de root
[org/cinnamon/desktop/keybindings/custom-keybindings/custom0]
binding=['<Primary><Shift><Alt>t']
command='/usr/local/cmc/s/root-terminal.sh'
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
applet-text='Menu'

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
[org/cinnamon/desktop/background]
picture-uri='file:///usr/share/backgrounds/cmc/desktop-bg.png'
#'file:///usr/share/backgrounds/linuxmint/default_background.jpg'

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

# Copia o  necessario para iniciar o terminal como root
mkdir -p /usr/local/cmc/s
cp ../arquivos/root-terminal.sh /usr/local/cmc/s/root-terminal.sh
chmod +x /usr/local/cmc/s/root-terminal.sh

# Finalmente, atualiza dconf
dconf update