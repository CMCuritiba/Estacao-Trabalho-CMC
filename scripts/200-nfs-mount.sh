#!/bin/bash

FSTAB="/etc/fstab"

if [ ! -f "$FSTAB" ]; then
    exit 1
fi

mkdir -p /mnt/suporte

# Backup do antigo
cp -af --backup=t "$FSTAB" "$FSTAB-old"

SERVIDOR=$(echo "$NFS_SERV" | cut -d ":" -f 1)
if [ -z "$SERVIDOR" ]; then
    logger "Servidor NFS incorreto: \"$NFS_SERV\""
    exit 1
elif ! grep -q "^$SERVIDOR" "$FSTAB"; then
    # Monta o compartilhamento remoto garantindo idempotência adicionando a
    # linha apenas se ela não existir
    echo "$NFS_SERV" >>"$FSTAB"
fi
