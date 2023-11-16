#!/bin/bash

# Atualiza repositórios
apt update
# Instala virtualbox e seus ajustes
apt install -qy virtualbox virtualbox-dkms virtualbox-ext-pack virtualbox-guest-additions-iso virtualbox-guest-dkms virtualbox-guest-source virtualbox-guest-utils virtualbox-guest-x11
# Instala mokutil
apt install mokutil
# Ajustando assinatura dos móduos para SecureBoot
openssl req -new -x509 -newkey rsa:2048 -keyout CORRIGE_VIRTUALBOX.priv -outform DER -out CORRIGE_VIRTUALBOX.der -nodes -days 36500 -subj "/CN=VirtualBox/"
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./CORRIGE_VIRTUALBOX.priv ./CORRIGE_VIRTUALBOX.der $(modinfo -n vboxdrv)
# Aviso adição de senha
zenity --info --width=280 --height=150 --text "O próximo passo pede a criação de uma senha \n\n Sugestão: Utilize a senha da BIOS"
sudo mokutil --import CORRIGE_VIRTUALBOX.der
# Aviso para reiniciar e instruções
zenity --question --width=280 --height=150 \
--text "Instalação quase Completa, falta reiniciar! \
\n                Mas ATENÇÂO \n\nApós o reboot \
será exibida uma tela azul. \nselecione a 2ª opção chamada: \
\n\n-Enroll MOK \n\nDepois selecione na sequência:\n\n-Continue\n-Yes\\
-Password (Mesma senha definida Anteriormente) \n-OK \
\n\n\n                             Deseja reiniciar Agora?" \
echo $?

case $? in
0)sudo /sbin/shutdown -r now;;
1) exit;;
esac
;;