#!/bin/bash
# Configura DNS

RESOLVED="/etc/systemd/resolved.conf"

if [ -f "$RESOLVED" ]; then
    # Habilita cache de DNS
    if ! grep -q '^Cache=no-negative' "$RESOLVED"; then
        echo "Cache=no-negative" >>"$RESOLVED"
    fi

    # Habilita dominio de busca
    if ! grep -q '^Domains=cmc.pr.gov.br' "$RESOLVED"; then
        echo "Domains=cmc.pr.gov.br" >>"$RESOLVED"
    fi

    # Habilita DNS de fallback para navegação
    if ! grep -q "^FallbackDNS=8.8.8.8 9.9.9.9" "$RESOLVED"; then
        echo "FallbackDNS=8.8.8.8 9.9.9.9" >>"$RESOLVED"
    fi
fi
