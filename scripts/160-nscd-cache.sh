#!/bin/bash

######################################################################################################################################################################################################
# Autora: Renata Carvalho
# Data: 28/11/17
# Versão: 1.0
# Descrição: Esse script modifica as configurações do NSCD para que este guarde o cache corretamente e funcione offline, impedindo o linux mint de travar quando a rede cair. Está configurado para guardar o cache por 64.800 segundos, ou 18 horas. 
######################################################################################################################################################################################################


if [ ! -f  "/etc/nscd.conf" ] || [ ! -f "/etc/nsswitch.conf" ]; then
	exit 1;
fi

cp /etc/nscd.conf /etc/nscd.conf-old
cp /etc/nsswitch.conf /etc/nsswitch.conf-old

echo "$(date) $HOSTNAME: Criando novos arquivos de configuração..."
echo "#       logfile                 /var/log/nscd.log
#       threads                 4
#       max-threads             32
#       server-user             nobody
#       stat-user               somebody
        debug-level             0
        reload-count            unlimited
        paranoia                no
#       restart-interval        3600

        enable-cache            passwd          yes
        positive-time-to-live   passwd          64800
        negative-time-to-live   passwd          20
        suggested-size          passwd          211
        check-files             passwd          yes
        persistent              passwd          yes
        shared                  passwd          yes
        max-db-size             passwd          33554432
        auto-propagate          passwd          yes

        enable-cache            group           yes
        positive-time-to-live   group           64800
        negative-time-to-live   group           60
        suggested-size          group           211
        check-files             group           yes
        persistent              group           yes
        shared                  group           yes
        max-db-size             group           33554432
        auto-propagate          group           yes

        enable-cache            hosts           no
        positive-time-to-live   hosts           64800
        negative-time-to-live   hosts           20
        suggested-size          hosts           211
        check-files             hosts           yes
        persistent              hosts           yes
        shared                  hosts           yes
        max-db-size             hosts           33554432

        enable-cache            services        yes
        positive-time-to-live   services        64800
        negative-time-to-live   services        20
        suggested-size          services        211
        check-files             services        yes
        persistent              services        yes
        shared                  services        yes
        max-db-size             services        33554432

# netgroup caching is known-broken, so disable it in the default config,
# see: https://bugs.launchpad.net/ubuntu/+source/eglibc/+bug/1068889
        enable-cache            netgroup        no
        positive-time-to-live   netgroup        28800
        negative-time-to-live   netgroup        20
        suggested-size          netgroup        211
        check-files             netgroup        yes
        persistent              netgroup        yes
        shared                  netgroup        yes
        max-db-size             netgroup        33554432" > /etc/nscd.conf

if [ ! -f  "/etc/nscd.conf" ]; then
	exit 1;
fi

echo "passwd: compat files ldap
group: compat files ldap
shadow: compat files ldap
gshadow: files

hosts:          dns files
networks:       files

protocols:      db files
services:       db files
ethers:         db files
rpc:            db files

netgroup:  files nis ldap" > /etc/nsswitch.conf

if [ ! -f  "/etc/nsswitch.conf" ]; then
	exit 1;
fi
