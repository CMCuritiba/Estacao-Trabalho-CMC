#!/bin/bash

FSTAB=/etc/fstab # type: string path (caminho do fstab no Mint)

if [ ! -f  "$FSTAB" ]; then
	exit 1;
fi

mkdir -p /mnt/suporte

# Backup do antigo
cp -a "$FSTAB" "$FSTAB-$(date +%F)"

# Monta o compartilhamento remoto
if grep -q "tauari" "$FSTAB"; then
	sed -i '/^tauari/c\10.0.0.5:\/data\/suporte \/mnt\/suporte nfs timeo=5,retrans=3,retry=10,ro,fg,intr,_netdev,soft,nofail   0   0' "$FSTAB"
elif ! grep -q "10\.0\.0\.5" "$FSTAB"; then
	echo "10.0.0.5:/data/suporte /mnt/suporte nfs timeo=5,retrans=3,retry=10,ro,fg,intr,_netdev,soft,nofail   0   0" >> "$FSTAB"
fi
