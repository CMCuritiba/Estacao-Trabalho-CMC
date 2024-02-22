#!/bin/bash

CMCDOMAIN=""
INTERFACE="$(nmcli device status | grep -E "conectado|connected" | head -n1 | awk '{print $1}')"
IPATUAL=$(ip addr list "$INTERFACE" | grep -m1 -w "inet" | awk '{print $2}' | cut -d '/' -f 1)

if [ -n "$IPATUAL" ] && [ -n "$CMCDOMAIN" ]; then
    # Obtem nome do IP consultando o DNS
    FQDN="$(host "$IPATUAL" | head -n1 | awk '{print $5}')"
    if ! grep "$CMCDOMAIN" <<<"$FQDN"; then
        # Failback:
        # escreve nome da máquina como "ip-127.0.0.1"
        DNSNAME="ip-$(tr '.' '-' <<<"$IPATUAL")"
    else
        # obtem o shortname
        DNSNAME="$(cut -d '.' -f 1 <<<"$FQDN")"
    fi

    if [ -n "$DNSNAME" ] && ! grep -q "$DNSNAME" <<<"$(hostname)"; then
        # echo "$DNSNAME"
        hostnamectl set-hostname "$DNSNAME"
    fi
fi
