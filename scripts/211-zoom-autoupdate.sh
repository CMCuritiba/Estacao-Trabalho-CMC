#!/bin/bash

# Verifica se usuário está como root
if [[ $UID != 0 ]]; then
    echo "Executar este script como root."
    exit 1
fi

# Copia arquivo zoom-updater para seu respectivo diretorio
if [ -f "../arquivos/zoom-update.sh" ]; then
    cp "../arquivos/zoom-update.sh" /usr/local/cmc/zoom-update.sh
    chmod +x /usr/local/cmc/zoom-update.sh
else
    echo "Arquivo zoom updater não encontrado"
    exit 1
fi

# Instala serviço no systemd
if [ -f "../arquivos/zoom-update.service" ]; then
    cp ../arquivos/zoom-update.service /etc/systemd/system/zoom-update.service
else
    echo "Arquivo zoom-update.service não encontrado"
    exit 1
fi

# Cria timer de serviço no systemd
if [ -f "../arquivos/zoom-update.timer" ]; then
    cp ../arquivos/zoom-update.timer /etc/systemd/system/zoom-update.timer
else
    echo "Arquivo zoom-update.timer não encontrado"
    exit 1
fi

systemctl daemon-reload
systemctl enable zoom-update.service
systemctl enable zoom-update.timer
# execute zoom update immediately
systemctl start zoom-update.service
# output systemd status/logs
# systemctl --no-pager status zoom-update.service
# systemctl list-timers --all
