#!/bin/bash
# ----------------------------------------------------------------------
# Arquivo: instala-programas.sh
# Funcao:  Instalar e pre configurar automaticamente programas padrao de cada area
# Autor:   Diego - 09/2019
# Versao:  Lucas de Lima - 09/11/2020 v.1
# ----------------------------------------------------------------------

# normaliza o nome da maquina (gabinete ou setor)
maq=$( ( (echo "$HOSTNAME" | grep -Eq "^g[0-9]{1,2}[a-e]$") && (echo "$HOSTNAME" | tr -d "a-e") || ( (echo "$HOSTNAME" | grep -Eq "^[a-z]+[0-9]+$") && (echo "$HOSTNAME" | tr -d "0-9") || echo "ERRO")))

# Variaveis
RDESKTOP="/usr/local/cmc/rds"
TAQ="/etc/skel/.config/libreoffice/4/user/template"

#if [ -d "$RDESKTOP" ]; then
##	if [ "$HOSTNAME" != "licitacoes6" ] && [ "$HOSTNAME" != "licitacoes13" ] && [ "$HOSTNAME" != "licitacoes7" ] && [ "$maq" != "contab" ] && [ "$maq" != "darh" ]; then
#	'cp' -f /mnt/suporte/cmc-setor/rds/rdsapp.sh /usr/local/cmc/rds/rdsapp.sh
#	fi
#fi

# Forca atualizacao do owncloud:
#logger "[$0] Forcando atualizacao do owncloud-client."
#apt-get update
#apt-get -qyf --reinstall install owncloud-client
#apt-get -qy autoremove

case "$maq" in
almox)
	if [ ! -d "$RDESKTOP" ]; then
		#wget -O install.rdesktop.tar.gz https://nuvem.cmc.pr.gov.br/index.php/s/Z2F0qDyNUaieBEY/download
		tar -C /tmp/ -zxvf install.rdesktop.tar.gz
		cd /tmp || return
		./install.rdesktop.sh Elotech
		'cp' -f /mnt/suporte/cmc-setor/rds/rdsapp.sh /usr/local/cmc/rds/rdsapp.sh
	fi
	;;
cerimonial)
	if ! hash inkscape 2>/dev/null; then
		apt-get install -qyf inkscape && logger "[$0] Instalado inkscape em: $maq"
	fi
	if ! hash scribus 2>/dev/null; then
		apt-get install -qyf scribus && logger "[$0] Instalado scribus em: $maq"
	fi
	;;
contab)
	if [ ! -d "$RDESKTOP" ]; then
		#wget -O install.rdesktop.tar.gz https://nuvem.cmc.pr.gov.br/index.php/s/Z2F0qDyNUaieBEY/download
		tar -C /tmp/ -zxvf install.rdesktop.tar.gz
		cd /tmp || return
		if [ "$HOSTNAME" = "contab1" ]; then
			./install.rdesktop.sh Elotech Elotech2 SiteTCEPR
			'cp' -f /mnt/suporte/cmc-setor/rds/rdsapp.sh /usr/local/cmc/rds/rdsapp.sh

			#Assinador Serpro (--no-check-certificate  pra não dar erro ao baixar)
			dpkg -i /mnt/suporte/cmc-setor/assinador-serpro/assinador-serpro_2.3.1_all.deb
			cp /usr/share/applications/serpro-signer.desktop /etc/skel/Desktop/serpro-signer.desktop

			#Driver para token
			apt install libccid libpcsclite1 pcscd opensc
			dpkg -i /mnt/suporte/cmc-setor/driver-token/SafenetAuthenticationClient-core-9.1.7-0_amd64.deb
			apt-get -f install
		fi
		if [ "$HOSTNAME" = "contab2" ]; then
			./install.rdesktop.sh Elotech Elotech2
			'cp' -f /mnt/suporte/cmc-setor/rds/rdsapp.sh /usr/local/cmc/rds/rdsapp.sh

			#Assinador Serpro (--no-check-certificate  pra não dar erro ao baixar)
			dpkg -i /mnt/suporte/cmc-setor/assinador-serpro/assinador-serpro_2.3.1_all.deb
			cp /usr/share/applications/serpro-signer.desktop /etc/skel/Desktop/serpro-signer.desktop

			#Driver para token
			apt install libccid libpcsclite1 pcscd opensc
			dpkg -i /mnt/suporte/cmc-setor/driver-token/SafenetAuthenticationClient-core-9.1.7-0_amd64.deb
			apt-get -f install
		else
			./install.rdesktop.sh Elotech Elotech2
			'cp' -f /mnt/suporte/cmc-setor/rds/rdsapp.sh /usr/local/cmc/rds/rdsapp.sh
		fi
	fi

	if ! hash inkscape 2>/dev/null; then
		apt-get install -qyf inkscape && logger "[$0] Instalado inkscape em: $maq"
	fi

	if ! hash warsaw 2>/dev/null; then
		dpkg -i /mnt/suporte/cmc-setor/BB/warsaw_setup64.deb
	fi
	;;
darh)
	if [ ! -d "$RDESKTOP" ]; then
		#wget -O install.rdesktop.tar.gz https://nuvem.cmc.pr.gov.br/index.php/s/Z2F0qDyNUaieBEY/download
		tar -C /tmp/ -zxvf install.rdesktop.tar.gz
		cd /tmp || return
		if [ "$HOSTNAME" = "darh1" ]; then
			./install.rdesktop.sh ServComNET DmpLight AISE TopAcesso SUP
		fi
		if [ "$HOSTNAME" = "darh12" ]; then
			./install.rdesktop.sh ServComNET DmpLight AISE TopAcesso
		fi
		if [ "$HOSTNAME" = "darh14" ]; then
			./install.rdesktop.sh TopAcesso AISE SUP
		fi
		if [ "$HOSTNAME" = "darh3" ] && [ "$HOSTNAME" = "darh6" ] && [ "$HOSTNAME" = "darh8" ]; then
			./install.rdesktop.sh TopAcesso AISE
		fi
		if [ "$HOSTNAME" = "darh9" ] && [ "$HOSTNAME" = "darh11" ] && [ "$HOSTNAME" = "darh2" ]; then
			./install.rdesktop.sh SUP AISE
		else
			./install.rdesktop.sh AISE
		fi
		'cp' -f /mnt/suporte/cmc-setor/rds/rdsapp.sh /usr/local/cmc/rds/rdsapp.sh
	fi
	;;
dg | projuris)
	if ! hash virtualbox 2>/dev/null; then
		apt-get install -qyf virtualbox virtualbox-dkms virtualbox-ext-pack virtualbox-guest-additions-iso virtualbox-guest-utils virtualbox-qt && logger "[$0] Instalado virtualbox virtualbox-dkms virtualbox-ext-pack virtualbox-guest-additions-iso virtualbox-guest-utils virtualbox-q em: $maq"
	fi
	;;
imprensa)
	if ! hash scribus 2>/dev/null; then
		apt-get install -qyf scribus && logger "[$0] Instalado scribus em: $maq"
	fi
	if ! hash openshot 2>/dev/null; then
		apt-get install -qyf openshot && logger "[$0] Instalado openshot em: $maq"
	fi
	if ! hash shotcut 2>/dev/null; then
		apt-get install -qyf shotcut && logger "[$0] Instalado shotcut em: $maq"
	fi
	if ! hash darktable 2>/dev/null; then
		apt-get install -qyf darktable && logger "[$0] Instalado darktable em: $maq"
	fi
	if ! hash inkscape 2>/dev/null; then
		apt-get install -qyf inkscape && logger "[$0] Instalado inkscape em: $maq"
	fi
	if ! hash kdenlive 2>/dev/null; then
		apt-get install -qyf kdenlive && logger "[$0] Instalado kdenlive em: $maq"
	fi
	;;
licitacoes)
	if [ ! -d "$RDESKTOP" ]; then
		#wget -O install.rdesktop.tar.gz https://nuvem.cmc.pr.gov.br/index.php/s/Z2F0qDyNUaieBEY/download
		tar -C /tmp/ -zxvf install.rdesktop.tar.gz
		cd /tmp || return
		./install.rdesktop.sh Elotech Elotech2
		'cp' -f /mnt/suporte/cmc-setor/rds/rdsapp.sh /usr/local/cmc/rds/rdsapp.sh
	fi
	if ! hash warsaw 2>/dev/null; then
		dpkg -i /mnt/suporte/cmc-setor/BB/warsaw_setup64.deb
	fi
	;;
saude) #modelo instala RDESKTOP
	if [ ! -d "$RDESKTOP" ]; then
		#wget -O install.rdesktop.tar.gz https://nuvem.cmc.pr.gov.br/index.php/s/Z2F0qDyNUaieBEY/download
		tar -C /tmp/ -zxvf install.rdesktop.tar.gz
		cd /tmp || return
		./install.rdesktop.sh AISE
	fi
	'cp' -f /mnt/suporte/cmc-setor/rds/rdsapp.sh /usr/local/cmc/rds/rdsapp.sh
	;;
taq)
	if [ ! -d "$TAQ" ]; then
		/mnt/suporte/cmc-setor/taquigrafia/configuracao-taq.sh
	fi
	;;
*)
	logger "[$0] Nenhuma configuracao especifica para: $maq"
	#exit 1
	;;
esac
