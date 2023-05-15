#!/bin/bash

# Locka os icones do desktop
echo "#!/bin/sh
if [ \$(id -u) = 0 ]
then
    /usr/bin/chattr -f +i /home/*/Desktop/Suporte.desktop
    /usr/bin/chattr -f +i /home/*/Desktop/Firefox.desktop
    /usr/bin/chattr -f +i /home/*/Desktop/google-chrome.desktop
fi" > /usr/local/cmc/scripts/on-login.sh

chmod +x /usr/local/cmc/scripts/on-login.sh

# Adiciona para rodar no PAM Session se não estiver
if ! grep "session optional pam_exec.so /usr/local/cmc/scripts/on-login.sh" /etc/pam.d/common-session; then
    echo "session optional pam_exec.so /usr/local/cmc/scripts/on-login.sh" >> /etc/pam.d/common-session
fi
