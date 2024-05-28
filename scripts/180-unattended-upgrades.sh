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

# FIXME: Não vai funcionar, pq o firefox não é instalado como o Chrome e edge, ele vem com o mint
# NOTE: Colocar no unattended-upgrades seco ou instalar o firefox a mão?
if apt-cache policy | grep -qE "release.+firefox.+stable"; then
    FIREFOXORIGIN=$(apt-cache policy | grep -E "release.+firefox.+stable" | cut -d ',' -f 1 | cut -d '=' -f 2)

    if [[ -n "$FIREFOXORIGIN" ]]; then
        sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"'"${FIREFOXORIGIN}"':stable\";' "$UNATTENDEDCONF"
    fi
fi
