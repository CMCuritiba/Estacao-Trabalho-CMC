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
   apt-get install -y /tmp/zoom_amd64.deb
fi