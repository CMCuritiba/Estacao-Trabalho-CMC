#!/bin/bash
# Configura as políticas do pkexec para abrir o gnome-terminal como usuário root
#Fontes: https://unix.stackexchange.com/questions/203136/how-do-i-run-gui-applications-as-root-by-using-pkexec
#Como abrir o gedit com o pkexec em modo root

echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policyconfig PUBLIC
 "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd">
<policyconfig>
    <action id="org.freedesktop.policykit.pkexec.terminal">
    <description>Run terminal program</description>
    <message>Authentication is required to run the terminal</message>
    <icon_name>accessories-text-editor</icon_name>
    <defaults>
        <allow_any>auth_admin</allow_any>
        <allow_inactive>auth_admin</allow_inactive>
        <allow_active>auth_admin</allow_active>
    </defaults>
    <annotate key="org.freedesktop.policykit.exec.path">/usr/bin/gnome-terminal</annotate>
    <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
    </action>
</policyconfig>' > /usr/share/polkit-1/actions/org.freedesktop.policykit.terminal.policy
