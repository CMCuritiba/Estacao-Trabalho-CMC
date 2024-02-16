#!/bin/bash

#verificar se usuário está como root
if [[ $UID != 0 ]]; then
  echo "Executar este script como root."
  exit 1
fi

#copia arquivo zoom-updater para seu respectivo diretorio
if [ -f "../arquivos/zoom-update.sh" ]; then
   cp "../arquivos/zoom-autoupdate.sh" /usr/local/cmc/zoom-updater.sh
   chmod +x /usr/local/cmc/zoom-updater.sh
else
   echo arquivo zoom updater não encontrado
   exit 1
fi

#copia arquivo de serviço para seu respectivo diretorio
if [ -f "../arquivos/zoom-update.service" ]; then
   cp ../arquivos/zoom-update.service /etc/systemd/system/zoom-update.service
else
   echo arquivo zoom-update.service não encontrado
   exit 1
fi

systemctl enable --now zoom-update.service
# execute zoom update immediately
systemctl start zoom-update.service
# output systemd status/logs
systemctl --no-pager status zoom-update.service
