#!/bin/bash
# Renomeia os itens de /usr/share/applications para .disable

# Não importa se esse script falhar, pode prosseguir
set +e

mv /usr/share/applications/mate-user-guide.desktop /usr/share/applications/mate-user-guide.desktop.disable
mv /usr/share/applications/blueberry.desktop /usr/share/applications/blueberry.desktop.disable
mv /usr/share/applications/bluetooth-sendto.desktop /usr/share/applications/bluetooth-sendto.desktop.disable
mv /usr/share/applications/nm-connection-editor.desktop /usr/share/applications/nm-connection-editor.desktop.disable
mv /usr/share/applications/mintupdate.desktop /usr/share/applications/mintupdate.desktop.disable
mv /usr/share/applications/lightdm-settings.desktop /usr/share/applications/lightdm-settings.desktop.disable
mv /usr/share/applications/menulibre.desktop /usr/share/applications/menulibre.desktop.disable
#mv /usr/share/applications/JB-controlpanel-jdk8.desktop /usr/share/applications/JB-controlpanel-jdk8.desktop.disable
#mv /usr/share/applications/JB-java-jdk8.desktop /usr/share/applications/JB-java-jdk8.desktop.disable
#mv /usr/share/applications/JB-mission-control-jdk8.desktop /usr/share/applications/JB-mission-control-jdk8.desktop.disable
#mv /usr/share/applications/JB-javaws-jdk8.desktop /usr/share/applications/JB-javaws-jdk8.desktop.disable
#mv /usr/share/applications/JB-jconsole-jdk8.desktop /usr/share/applications/JB-jconsole-jdk8.desktop.disable
#mv /usr/share/applications/JB-policytool-jdk8.desktop /usr/share/applications/JB-policytool-jdk8.desktop.disable
#mv /usr/share/applications/JB-jvisualvm-jdk8.desktop /usr/share/applications/JB-jvisualvm-jdk8.desktop.disable
mv /usr/share/applications/mate-network-properties.desktop /usr/share/applications/mate-network-properties.desktop.disable
mv /usr/share/applications/mintwelcome.desktop /usr/share/applications/mintwelcome.desktop.disable
mv /usr/share/applications/users.desktop /usr/share/applications/users.desktop.disable

# Não importa se um dos mvs falhar
exit 0
