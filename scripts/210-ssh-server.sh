#!/bin/bash
# Desabilita login SSH para root:
SSHD="/etc/ssh/sshd_config"
logger "Desabilitando login SSH para root"
if grep -q "^PermitRootLogin yes" "$SSHD"; then
    sed -i '/^PermitRootLogin/c\#PermitRootLogin no' "$SSHD"
fi

# Restringe SSH apenas para usuários da DTIC:
logger "Restringindo SSH apenas para usuários da DTIC"
if grep -q "^AllowGroups" "$SSHD"; then
    # replace
    sed -i '/^AllowGroups/c\AllowGroups dtic' "$SSHD"
else
    # add
    echo "AllowGroups dtic" >>"$SSHD"
fi

# Reinicia serviço para aplicar
service ssh restart
