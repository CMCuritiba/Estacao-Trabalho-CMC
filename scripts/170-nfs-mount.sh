#!/bin/bash

######################################################################################################################################################################################################
# Autora: Renata Carvalho
# Data: 28/11/17
# Versão: 1.0
# Descrição: Esse script configura o /etc/fstab para fazer a montagem de arquivos da rede.
######################################################################################################################################################################################################

if [ ! -f  "/etc/fstab" ]; then
	exit 1;
fi

mkdir -p /mnt/suporte

# Monta o servidor tauari
if ! grep -q "tauari" /etc/fstab; then
	# Backup do antigo
	cp /etc/fstab /etc/fstab-old

	echo "tauari:/dados/aplcmc/suporte /mnt/suporte nfs timeo=5,retrans=1,retry=0,rw,bg,intr,_netdev,soft   0   0" >> /etc/fstab
fi
