#!/bin/bash
# EM TESTE
# Variaveis
AD_DOMAIN="" # nome do dominio do AD
AD_ADMIN="" # usuario que remove ao dominio
HOST=$('hostname')

# Informa o nome do computador
echo "Deseja remover o computador '$HOST' do dominio $AD_DOMAIN ('yes' para sim, ESC para sair): "
read OPCAO

if [ $OPCAO == "yes"]; then
    # Verifica se o dominio esta configurado
    if [ "$(realm discover $AD_DOMAIN | grep -w 'configured: no')" ]; then
        # Se nao for vazio o retorno do computador na lista de grupos computers do AD
        if [ ! -z "$(getent group | grep -i $HOST &>/dev/null)" ]; then
            realm leave -U $AD_ADMIN $AD_DOMAIN
            echo "Computador removido do dominio"
        fi
    fi
fi
