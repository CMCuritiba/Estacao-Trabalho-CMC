#!/bin/sh
if [ $(id -u) = 0 ]
then
    /usr/bin/chattr -f +i /home/*/Desktop/Suporte.desktop
    /usr/bin/chattr -f +i /home/*/Desktop/firefox.desktop
    /usr/bin/chattr -f +i /home/*/Desktop/google-chrome.desktop
fi
