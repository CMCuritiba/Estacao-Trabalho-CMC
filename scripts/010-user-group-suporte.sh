#!/bin/bash

# Cria usuário suporte se não existe
if ! id -u suporte &>/dev/null; then
    useradd -m suporte
fi

# Atualiza senhas de suporte e root
echo "suporte:$PASS_SUPPORT" | chpasswd
echo "root:$PASS_ROOT" | chpasswd

# Seta grupo principal de suporte para users e deleta grupo suporte se existe
# Também tira suporte de grupos de admin
usermod suporte -g users
if grep -q "suporte:" /etc/group; then
    groupdel suporte
fi
if id -nG suporte | grep -qw adm; then
    deluser suporte adm
fi
if id -nG suporte | grep -qw lpadmin; then
    deluser suporte lpadmin
fi

# Garante que o usuário suporte esteja no sudo
if ! id -Gn suporte | grep -qw "sudo"; then
    adduser --quiet suporte sudo
fi
