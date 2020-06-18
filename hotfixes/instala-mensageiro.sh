#!/bin/bash

# Script deve ser rodado como root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    logger "Este script deve ser executado como root"
    exit 1
fi

# Desativa PSI
rm -f /etc/xdg/autostart/psi.desktop
if command -v psi >/dev/null 2>&1; then
    apt-get -q -y remove psi
fi

icone="/usr/share/pixmaps/Rainbow.png"
iconeRemoto="/mnt/suporte/etv4/scripts/resources/Rainbow.png"
atalhoSkel="/etc/skel/Desktop/Rainbow.desktop"

if [ ! -f "$icone" ]; then
    cp -f "$iconeRemoto" "$icone"
    chmod 644 "$icone"
fi

# Instala atalho no skel
if [ ! -f "$atalhoSkel" ]; then
    echo -e "#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Name=Rainbow
Exec=google-chrome --app=https://web.openrainbow.com/
Name[pt_BR]=Rainbow
Icon=$icone" > "$atalhoSkel"
    chmod +x "$atalhoSkel"
fi

for userHome in /home/*; do
    user=$(echo "$userHome" | grep -P "(?<=/home/).+" -o)
    if [ ! -f "$userHome/Desktop/Rainbow.desktop" ] && id -u "$user" &> /dev/null && [ -d "/home/$user/Desktop/" ]; then
        if cp -f "$atalhoSkel" "$userHome/Desktop/"; then
            chown "$user:nogroup" "$userHome/Desktop/Rainbow.desktop"
            chmod +x "$userHome/Desktop/Rainbow.desktop"
            chattr -f +i "$userHome/Desktop/Rainbow.desktop"
        fi
    fi
done

# Instala atalho gerenciado no Google Chrome
# Aparentemente não é possível a edição/inserção programática de atalhos nos
# perfis do Firefox. TODO
favsChrome="/etc/opt/chrome/policies/managed/cmc.json"
if ! grep -q "Rainbow" "$favsChrome"; then
    sed -i 's|]|,\n   {\n      "url": "https://web.openrainbow.com/",\n      "name": "Rainbow"\n   }\n   ]|g' "$favsChrome"
fi
