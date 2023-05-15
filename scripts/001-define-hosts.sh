#!/bin/bash
# Define manualmente o nome do computador
# (ativado para testes, desabilitado para pegar pela variável de sistema $HOSTNAME)

#echo "Informe o novo nome do computador (ENTER para manter o nome atual '$('hostname')'): "
#read HOST

# Verifica se variavel HOST está vazia ou com valor indefinido
if [ -z $HOST ] || [ $HOST == "3NXDOMAIN" ]; then
    HOST=$HOSTNAME
fi

# Altera o hostname do computador
hostnamectl set-hostname $HOST

# Altera arquivo 'hostname' para o novo nome
echo $HOST > /etc/hostname

# Altera arquivo 'hosts' para o novo nome com a extensão do domínio
sed -i "/^127.0.1.1/c\127.0.1.1\t"$HOST.${AD_DOMAIN,,} "/etc/hosts"
