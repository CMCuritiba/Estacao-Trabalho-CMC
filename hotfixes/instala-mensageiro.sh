#!/bin/bash

icone="/usr/share/pixmaps/Rainbow.png"
iconeRemoto="/mnt/suporte/etv4/scripts/resources/Rainbow.png"
atalhoSkel="/etc/skel/Desktop/Rainbow.desktop"

if [ ! -f "$icone" ]; then
    cp -f "$iconeRemoto" "$icone"
    chmod 644 "$icone"
fi

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
