#!/bin/bash

zenity --text-info --title="Política de informatica" --checkbox="Eu li e aceito as condições estipuladas acima" --filename="/usr/local/cmc/politica-informatica.txt" --height=600 --width=800 2>/dev/null
if [ $? != 0 ]; then
        touch "$HOME/.forcelogout"
else
        rm "$HOME/.politicainformatica.sh"
fi