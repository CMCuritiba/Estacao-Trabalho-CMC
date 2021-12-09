#!/bin/bash

sed -i 's/^alias ll/#alias ll/g' /root/.bashrc
sed -i 's/^alias la/#alias la/g' /root/.bashrc
sed -i 's/^alias l/#alias l/g' /root/.bashrc

echo "# Aliases e funcoes locais
alias ll='ls -lh'
alias la='ls -a'
alias l='ls'
alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -iv'

# Faz backup local
function bkp() {
	if [ -z \"\$1\" ]; then
		echo \"Uso: bkp [arquivo]\";
	else
		mkdir -p ./bkp
		'cp' -Lv --preserve=all \"\$1\" \"./bkp/\$1-\$(date +%F-%H-%M-%S)\"
	fi
}" >/root/.bash_aliases

cp /root/.bash_aliases /etc/skel/.bash_aliases
chmod +r /etc/skel/.bash_aliases
