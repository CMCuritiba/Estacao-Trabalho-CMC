#!/bin/bash
# Desabilita login SSH para root:

SSHD="/etc/ssh/sshd_config"

logger "Desabilitando login SSH para root"

# Ajuste o servico SSH para permitir autenticacao de senha
sed -i "/#PasswordAuthentication yes/c\PasswordAuthentication yes" "$SSHD"

if grep -q "^PermitRootLogin" "$SSHD"; then
    # replace
    sed -i '/^PermitRootLogin/c\PermitRootLogin no' "$SSHD"
else
    # add
    echo "PermitRootLogin no" >>"$SSHD"
fi

# Restringe SSH apenas para usuários da DTIC:
logger "Restringindo SSH apenas para usuários da DTIC"
if grep -q "^AllowGroups" "$SSHD"; then
    # replace
    sed -i "/^AllowGroups/c\AllowGroups $DTIC_GID" "$SSHD"
else
    # add
    echo "AllowGroups dtic" >>"$SSHD"
fi

# Reinicia serviço para aplicar
systemctl restart sshd


