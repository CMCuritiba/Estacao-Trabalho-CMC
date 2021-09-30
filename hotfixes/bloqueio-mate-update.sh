#!/bin/bash

# Se houver dif no grupo sudoers atualiza para dtic
if grep -wq "dif" /etc/sudoers; then
    sed -i 's/%dif/%dtic/g' /etc/sudoers
fi

if ! command -v xmlstarlet >/dev/null 2>&1; then
    apt-get -qyf install xmlstarlet
fi

# Assegura permissão de montagem de dispositivos externos (pendrives, HDs, etc)
udisks_policy="/usr/share/polkit-1/actions/org.freedesktop.UDisks2.policy"
for fsm in {filesystem-mount,filesystem-unmount-others,filesystem-mount-system}; do
    for defaul_acl in {allow_any,allow_inactive,allow_active}; do
        xmlstarlet edit --inplace \
            --update "//policyconfig/action[@id='org.freedesktop.udisks2.$fsm']/defaults/$defaul_acl" \
            --value 'yes' \
            "$udisks_policy"
    done
done
