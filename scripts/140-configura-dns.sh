#!/bin/bash
# Configura DNS

RESOLVED="/etc/systemd/resolved.conf"

if [ -f "$RESOLVED" ]; then
    # Habilita cache de DNS
    sed -i -e '/^Cache/d' -e '$aCache=no-negative' "$RESOLVED"

    # Habilita dominio de busca
    sed -i -e '/^Domains/d' -e "\$aDomains=${AD_DOMAIN,,}" "$RESOLVED"

    # Habilita DNS de fallback para navegação
    sed -i -e '/^FallbackDNS/d' -e '$aFallbackDNS=8.8.8.8 9.9.9.9' "$RESOLVED"

    if [ -n "$AD_IP_ADDRESS" ]; then
        # Força DNS para garantir que JOIN funcione
        sed -i -e '/^DNS/d' -e "\$aDNS=$AD_IP_ADDRESS" "$RESOLVED"
    fi

    systemctl restart systemd-resolved.service
fi

# Rationale dos comandos sed acima:
# sed -i -e '/^Cache/d' -e '$aCache=nn' file
# Remove a linha que contém o padrão '^Cache', se existir, e adiciona a linha
# 'Cache=nn' no fim do arquivo
