#!/bin/bash

# Automatiza o processo de atualizações de segurança

apt-get update

# Instala o unattended-upgrades
apt-get -qyf install unattended-upgrades

if [ -f "/etc/upstream-release/lsb-release" ]; then
    source "/etc/upstream-release/lsb-release"
else
    echo "Versão base do Mint não encontrada"
    exit 1
fi

UNATTENDEDCONF="/etc/apt/apt.conf.d/50unattended-upgrades"

# Adiciona os repositório relevantes ao arquivo de configuração
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"${distro_id}:${distro_codename}-updates\";' "$UNATTENDEDCONF"
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"'"${DISTRIB_ID}"':'"${DISTRIB_CODENAME}"'-security\";' "$UNATTENDEDCONF"
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"'"${DISTRIB_ID}"':'"${DISTRIB_CODENAME}"'\";' "$UNATTENDEDCONF"
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"'"${DISTRIB_ID}"':'"${DISTRIB_CODENAME}"'-updates\";' "$UNATTENDEDCONF"
sed -i '/^\/\/Unattended-Upgrade::MinimalSteps/c\Unattended-Upgrade::MinimalSteps "true";' "$UNATTENDEDCONF"

if apt-cache policy | grep -E "release.+Google.+amd64"; then
    GOOGLEPPA=$(apt-cache policy | grep -E "release.+Google.+amd64" | cut -d ',' -f 2 | cut -d '=' -f 2)

    if [[ -n "$GOOGLEPPA" ]]; then
        sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"'"${GOOGLEPPA}"':stable\";' "$UNATTENDEDCONF"
    fi
else
    echo "Source list do Chrome não encontrado, abortando."
    exit 1
fi
