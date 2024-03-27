#!/bin/bash

CMCDOMAIN=""
INTERFACE="$(nmcli device status | grep -E "conectado|connected" | head -n1 | awk '{print $1}')"
IPATUAL=$(ip addr list "$INTERFACE" | grep -m1 -w "inet" | awk '{print $2}' | cut -d '/' -f 1)

if [ -n "$IPATUAL" ] && [ -n "$CMCDOMAIN" ]; then
    # Obtem nome do IP consultando o DNS
    FQDN="$(nslookup "$IPATUAL" "$CMCDOMAIN" | head -n1 | awk '{print $4}')"
    if grep -iq "$CMCDOMAIN" <<<"$FQDN"; then
        # obtem o shortname
        DNSNAME="$(cut -d '.' -f 1 <<<"$FQDN")"

        if [ -n "$DNSNAME" ] && ! grep -q "$DNSNAME" <<<"$(hostname)"; then
            # echo "$DNSNAME"
            # Atualiza hostname
            hostnamectl set-hostname "$DNSNAME"
        fi
    fi
fi

# Desabilita o IPv6, nao funciona via sysctl.conf, bug:
# https://bugs.launchpad.net/ubuntu/+source/linux/+bug/997605
sysctl -w net.ipv6.conf.all.disable_ipv6=1
