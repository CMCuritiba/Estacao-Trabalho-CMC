#!/bin/bash
# ----------------------------------------------------------------------
# Arquivo: configura-boot.sh
# Funcao:  Instalar programas, corrigir erros e ajustar as configurações da máquina para aquele ponto de rede
# Autor:   ?
# Versao:  Lucas de Lima - 09/11/2020 v.1
# ----------------------------------------------------------------------

logger "[$0] Iniciando script de configuracoes."

# Instala impressoras por hostname
/mnt/suporte/cmc-setor/instala-impressora.sh

# Instala programas e configura programas padrão por hostname
/mnt/suporte/cmc-setor/instala-programas.sh

# Instala atalho para o Rainbow
/mnt/suporte/etv4/scripts/instala-mensageiro.sh

# Desativa popups
/mnt/suporte/etv4/scripts/desativa-popup.sh

# Desabilita o IPv6, nao funciona via sysctl.conf, bug:
# https://bugs.launchpad.net/ubuntu/+source/linux/+bug/997605
sysctl -w net.ipv6.conf.all.disable_ipv6=1

IPATUAL=$(ip addr list | grep "/16" | grep "inet 10.0." | awk '{print $2}' | cut -d '/' -f 1)

if [[ "$IPATUAL" != "" ]]; then
       NOVOHOSTNAME=$(host "$IPATUAL" | cut -d ' ' -f 5 | cut -d '.' -f 1)
       hostname "$NOVOHOSTNAME"
       if [[ ! -z "$NOVOHOSTNAME" ]]; then
              echo "$NOVOHOSTNAME" >/etc/hostname
       fi
fi

if [ -f "/usr/local/cmc/scripts/root-terminal.sh" ]; then
       if ! grep -q "/usr/bin/gnome-terminal" "/usr/local/cmc/scripts/root-terminal.sh"; then
              sed -i '/^pkexec/c\pkexec /usr/bin/gnome-terminal' "/usr/local/cmc/scripts/root-terminal.sh"
       fi
else
       echo "#!/bin/bash
pkexec /usr/bin/gnome-terminal" >"/usr/local/cmc/scripts/root-terminal.sh"
       chmod +x "/usr/local/cmc/scripts/root-terminal.sh"
       sed -i 's/gksu -w gnome-terminal/\/usr\/local\/cmc\/scripts\/root-terminal.sh/' "/etc/dconf/db/local.d/01-cmc"
       dconf update
fi

if ! grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config; then
       sed -i 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
fi

#sed -i 's/xenial/bionic/g' /etc/apt/apt.conf.d/50unattended-upgrades

# corrige problema de espaço em disco  criado pelo flatpak
! pgrep -x flatpak && rm -rf /var/tmp/flatpak-cache-*
