#!/bin/bash

if [ ! -f "/etc/fstab" ]; then
	exit 1
fi

mkdir -p /mnt/suporte

# Monta o servidor tauari
if ! grep -q "tauari" /etc/fstab; then
	# Backup do antigo
	cp /etc/fstab /etc/fstab-old

	echo "$TAUARI" >>/etc/fstab
fi
