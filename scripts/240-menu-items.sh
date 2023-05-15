#!/bin/bash
# Renomeia os itens de /usr/share/applications para .disable

# Não importa se esse script falhar, pode prosseguir
set +e

mv /usr/share/applications/nm-connection-editor.desktop /usr/share/applications/nm-connection-editor.desktop.disable
mv /usr/share/applications/mintreport.desktop /usr/share/applications/mintreport.desktop.disable
mv /usr/share/applications/mintupdate.desktop /usr/share/applications/mintupdate.desktop.disable
mv /usr/share/applications/mintwelcome.desktop /usr/share/applications/mintwelcome.desktop.disable
mv /usr/share/applications/lightdm-settings.desktop /usr/share/applications/lightdm-settings.desktop.disable

# Não importa se um dos mvs falhar
exit 0
