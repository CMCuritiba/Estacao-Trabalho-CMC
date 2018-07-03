#!/bin/bash

mkdir -p /usr/local/cmc/scripts

echo '#!/bin/bash
if [ -f "$HOME/.forcelogout" ]; then
	rm "$HOME/.forcelogout";
	pkill -9 -u "$USER"
fi' > /usr/local/cmc/scripts/forcelogout.sh

chmod +x /usr/local/cmc/scripts/forcelogout.sh

cp ../arquivos/politica-informatica.txt /usr/local/cmc/politica-informatica.txt
