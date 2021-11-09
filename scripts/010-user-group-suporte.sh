#!/bin/bash

# Cria usuário suporte se não existe
if ! id -u suporte &>/dev/null; then
	useradd -m suporte
    echo -e 'suporte:'"$PASS_SUPPORT" | sudo chpasswd
fi

# Atualiza a senha de root
echo -e 'root:'"$PASS_ROOT" | sudo chpasswd

# Seta grupo principal de suporte para users e deleta grupo suporte se existe
# Também tira suporte de grupos de admin
usermod suporte -g users
if grep -q "suporte:" /etc/group; then
    groupdel suporte
fi
if id -nG suporte | grep -qw adm; then
    deluser suporte adm
fi
if id -nG suporte | grep -qw sudo; then
    deluser suporte sudo
fi
if id -nG suporte | grep -qw lpadmin; then
    deluser suporte lpadmin
fi
