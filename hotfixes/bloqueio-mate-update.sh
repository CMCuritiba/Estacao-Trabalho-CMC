#!/bin/bash

# Se houver dif no grupo sudoers atualiza para dtic
if grep -w "dif" /etc/sudoers; then
    sed -i 's/%dif/%dtic/g' /etc/sudoers
fi

# Assegura permissão de montagem de dispositivos externos (pendrives, HDs, etc)
udisks_policy="/usr/share/polkit-1/actions/org.freedesktop.UDisks2.policy"
for fsm in {filesystem-mount,filesystem-unmount-others,filesystem-mount-system}; do
    for defaul_acl in {allow_any,allow_inactive,allow_active}; do
        xmlstarlet edit -L \
            --update "//policyconfig/action[@id='org.freedesktop.udisks2.$fsm']/defaults/$defaul_acl" \
            --value 'yes' \
            "$udisks_policy"
    done
done
