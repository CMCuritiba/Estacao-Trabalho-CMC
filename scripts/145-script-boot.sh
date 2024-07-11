#!/bin/bash
# After network-online pode ser usado para que o serviço rode apenas após as interfaces de rede estarem prontas
# After mount pode ser usado para que o serviço rode apenas após um mount no fstab
# o nome do mnt-[coisa].mount pode ser descoberto com o seguinte comando:
# systemctl list-units | grep '/path/to/mount' | awk '{ print $1 }'

BOOTSH="/usr/local/cmc/scripts/cmc-boot.sh"

cp ../arquivos/cmc-boot.sh "$BOOTSH"
sed -i "s/^CMCDOMAIN=.*$/CMCDOMAIN=${AD_DOMAIN,,}/" "$BOOTSH"

echo "[Unit]
Description=Script de boot do CMC
Wants=network-online.target
After=network-online.target

[Service]
Restart=on-failure
RestartSec=60
ExecStart=/bin/bash $BOOTSH

[Install]
WantedBy=multi-user.target" >/etc/systemd/system/cmc-boot.service

echo "[Unit]
Description=Script de boot do CMC

[Timer]
OnBootSec=4h
OnUnitActiveSec=12h

[Install]
WantedBy=timers.target" >/etc/systemd/system/cmc-boot.timer

# Habilita o serviço e roda o script imediatamente
systemctl daemon-reload
systemctl --now enable cmc-boot.service
systemctl --now enable cmc-boot.timer
