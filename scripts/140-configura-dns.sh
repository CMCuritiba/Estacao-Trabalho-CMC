#!/bin/bash
# Configura DNS

RESOLVED="/etc/systemd/resolved.conf"

# Remove resolv.conf para usar configuracao local e apontar para o IP do DNS do AD
rm -rf /etc/resolv.conf
echo "nameserver $AD_ADDRESS" > /etc/resolv.conf

if [ -f "$RESOLVED" ]; then
    # Habilita cache de DNS
    if ! grep -q '^Cache=no-negative' "$RESOLVED"; then
        echo "Cache=no-negative" >>"$RESOLVED"
    fi

    # Habilita dominio de busca
    if ! grep -q "^Domains=${AD_DOMAIN,,}" "$RESOLVED"; then
        echo "Domains=${AD_DOMAIN,,}" >>"$RESOLVED"
    fi

    # Habilita DNS de fallback para navegação
    if ! grep -q "^FallbackDNS=8.8.8.8 9.9.9.9" "$RESOLVED"; then
        echo "FallbackDNS=8.8.8.8 9.9.9.9" >>"$RESOLVED"
    fi
fi
