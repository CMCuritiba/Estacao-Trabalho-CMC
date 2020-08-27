#!/bin/bash

# Script deve ser rodado como root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    logger "Este script deve ser executado como root"
    exit 1
fi

# Desativa PSI
rm -f /etc/xdg/autostart/psi.desktop
sed -i -E 's/^sed.+psi.+//g' /etc/skel/.profile
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
fi

# Instala atalho gerenciado no Google Chrome
# TODO: Aparentemente não é possível a edição/inserção programática de atalhos
# nos perfis do Firefox.
# Referencia para policies do Chrome:
# https://cloud.google.com/docs/chrome-enterprise/policies/
favsChrome="/etc/opt/chrome/policies/managed/cmc.json"
if ! grep -q "ManagedBookmarks" "$favsChrome"; then
    echo '{
  "DownloadDirectory": "/home/${user_name}/Downloads",
  "DefaultBrowserSettingEnabled": false,
  "DisablePrintPreview": true,
  "ManagedBookmarks": [
  {
    "url": "https://www.cmc.pr.gov.br",
    "name": "Câmara Municipal de Curitiba"
  },
  {
    "url": "https://intranet.cmc.pr.gov.br",
    "name": "Intranet"
  },
  {
    "url": "https://correio.cmc.pr.gov.br",
    "name": "Correio"
  },
  {
    "url": "https://www.cmc.pr.gov.br/spl",
    "name": "SPL II"
  },      
  {
    "url": "https://intranet.cmc.pr.gov.br/spa",
    "name": "SPA"
  },      
  {       
    "url": "https://nuvem.cmc.pr.gov.br",
    "name": "Nuvem"
  },
  {
    "url": "https://intranet.cmc.pr.gov.br/apl",
    "name": "APL"
  },
  {
    "url": "https://chamados.cmc.pr.gov.br",
    "name": "Chamados"
  },
  {
    "url": "https://suporte.cmc.pr.gov.br",
    "name": "Suporte"
  },
  {
    "url": "https://www.curitiba.pr.gov.br",
    "name": "Prefeitura Municipal de Curitiba"
  },
  {
    "url": "https://web.openrainbow.com/",
    "name": "Rainbow"
  }
  ]
}' > "$favsChrome"
fi
