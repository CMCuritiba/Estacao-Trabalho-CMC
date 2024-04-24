#!/bin/bash

# Assegura permissão de dispositivos bluetooth
blueman_policy="/usr/share/polkit-1/actions/org.blueman.policy"
for fsm in {network.setup,rfkill.setstate}; do
    for defaul_acl in {allow_inactive,allow_active}; do
        xmlstarlet edit --inplace \
            --update "//policyconfig/action[@id='org.blueman.$fsm']/defaults/$defaul_acl" \
            --value 'yes' \
            "$blueman_policy"
    done
done