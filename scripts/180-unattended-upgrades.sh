#!/bin/bash

# Automatiza o processo de atualizações de segurança

# Necessário para carregar o source list do Chrome :/
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
sed -i '/^\/\/Unattended-Upgrade::MinimalSteps/c\Unattended-Upgrade::MinimalSteps "true";' "$UNATTENDEDCONF"

if apt-cache policy | grep -qE "release.+Google.+amd64"; then
    GOOGLEORIGIN=$(apt-cache policy | grep -E "release.+Google.+amd64" | cut -d ',' -f 2 | cut -d '=' -f 2)

    if [[ -n "$GOOGLEORIGIN" ]]; then
        sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"'"${GOOGLEORIGIN}"':stable\";' "$UNATTENDEDCONF"
    fi
else
    echo "Source list do Chrome não encontrado, abortando."
    exit 1
fi

if apt-cache policy | grep -qE "release.+edge.+stable"; then
    EDGEORIGIN=$(apt-cache policy | grep -E "release.+edge.+stable" | cut -d ',' -f 1 | cut -d '=' -f 2)

    if [[ -n "$EDGEORIGIN" ]]; then
        sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"'"${EDGEORIGIN}"':stable\";' "$UNATTENDEDCONF"
    fi
fi

# Permite a atualização automática do FireFox
# A linha nativa do arquivo é LinuxMint:virginia
# Necessário incluir linuxmint:virginia
if [ -f /etc/lsb-release ]; then
    source "/etc/lsb-release"
    if ! grep -q "${DISTRIB_ID,,}:${DISTRIB_CODENAME,,}"; then
        sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"'"${DISTRIB_ID,,}"':'"${DISTRIB_CODENAME,,}"'\";' "$UNATTENDEDCONF"
    fi
else
    echo "Versão base do Mint não encontrada"
    exit 1
fi

