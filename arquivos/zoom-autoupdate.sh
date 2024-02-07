#!/bin/bash

#verificar se usuário está como root
if [[ $UID != 0 ]]; then
  echo "Executar este script como root."
  exit 1
fi
mkdir /opt/zoom-updater
    cat <<'EOF' >/opt/zoom-updater/zoom-update.sh
#!/bin/bash
export LANG=pt
diretorio=/mnt/suporte/etv4/scripts/files/zoom_amd64.deb
if [ -f "$diretorio" ]; then
   ZOOM_VERSION_AVAILABLE=$(dpkg-deb -I $diretorio | grep Version)
   echo ultima versão disponível para download: $ZOOM_VERSION_AVAILABLE
else
   wget --quiet https://zoom.us/client/latest/zoom_amd64.deb -P /tmp
   ZOOM_VERSION_AVAILABLE=$(dpkg-deb -I /tmp/zoom_amd64.deb | grep Version)
   echo ultima versão disponível para download: $ZOOM_VERSION_AVAILABLE
fi
ZOOM_VERSION_INSTALLED=$(apt-cache policy zoom | grep "Installed:" | sed -e 's/.*Installed: \(.*\)/\1/')
echo versão do zoom instalada: $ZOOM_VERSION_INSTALLED
if [ -f "$diretorio" ] && [[ "$ZOOM_VERSION_INSTALLED" != *"$ZOOM_VERSION_AVAILABLE"* ]]; then
   echo pasta mnt/suporte encontrada
   export DEBIAN_FRONTEND=noninteractive
   apt-get install -y $diretorio
else
   echo pasta mnt/suporte não encontrada
   export DEBIAN_FRONTEND=noninteractive
   apt-get install -y $diretorio
fi

EOF
chmod +x /opt/zoom-updater/zoom-update.sh

  cat <<'EOF' >/etc/systemd/system/zoom-update.service
[Unit]
Description=zoom update service
After=network.target
After=network-online.target mnt-suporte.mount

[Service]
User=root
ExecStart=/opt/zoom-updater/zoom-update.sh

[Install]
WantedBy=multi-user.target
EOF

systemctl enable --now zoom-update.service
# execute zoom update immediately
systemctl start zoom-update.service
# output systemd status/logs
systemctl --no-pager status zoom-update.timer
systemctl --no-pager status zoom-update.service
