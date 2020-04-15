#!/bin/bash
# Configura DNS

RESOLVED="/etc/systemd/resolved.conf"
RESOLVTAIL="/etc/resolvconf/resolv.conf.d/tail"

if [ -f "$RESOLVED" ]; then
	# Habilita cache de DNS
	sed -i 's|^Cache=no|Cache=yes|g' "$RESOLVED"

	if ! grep -q '^Cache=yes' "$RESOLVED"; then
		echo "Cache=yes" >> "$RESOLVED";
	fi

	# Habilita dominio de busca
	sed -i '/^Domains=/c\Domains=cmc.pr.gov.br/' "$RESOLVED"

	if ! grep -q '^Domains=cmc.pr.gov.br' "$RESOLVED"; then
		echo "Domains=cmc.pr.gov.br" >> "$RESOLVED";
	fi
fi

if [ -f "$RESOLVTAIL" ]; then
	# Otimiza timeout, rotacao e tentativas
	sed -i '/^options/c\options timeout:1 attempts:1 rotate' "$RESOLVTAIL"

	if ! grep -q '^options' "$RESOLVTAIL"; then
		echo "options timeout:1 attempts:1 rotate" >> "$RESOLVTAIL";
	fi

fi
