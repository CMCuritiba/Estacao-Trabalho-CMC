#!/bin/bash

# Cria grupo suporte se não existe
groupadd -f suporte

# Cria usuário suporte se não existe
if ! id -u suporte &>/dev/null; then
    useradd --create-home --gid suporte --shell /bin/bash suporte
else
    # Seta grupo principal de suporte
    usermod suporte --gid suporte
fi

# Atualiza senhas de suporte e root
echo "suporte:$SUPORTE_PASS" | chpasswd
echo "root:$ROOT_PASS" | chpasswd

# Tira suporte de grupos de admin
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
