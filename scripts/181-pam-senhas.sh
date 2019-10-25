#!/bin/bash

################################################################################
# Habilita restrições e verificações das senhas utilizadas pelos usuários.
################################################################################

# Instala pacote de controle de senhas
apt-get install -qyf libpam-pwquality

PWQCONF="/etc/security/pwquality.conf"

cp -an "$PWQCONF" "$PWQCONF-old"

# Configura a qualidade de senha para o seguinte cenario:
# - 3 classes de caracteres;
# - Número mínimo de caracteres igual a 8 (8 é o default);
# - Não utilizar verificações de dicionário. É melhor uma senha grande com
#   palavras e fácil de lembrar do que senhas absurdas e difíceis;
# - Não possuir palavras chave como camara, curitiba, senha, segredo, 123456.

sed -i '/minclass/c\minclass = 3' "$PWQCONF"
#sed -i '/minlen/c\minlen = 8' "$PWQCONF"
sed -i '/dictcheck/c\dictcheck = 0' "$PWQCONF"

if ! grep -q "badwords" "$PWQCONF"; then
	echo "
# Space separated list of words that must not be contained in the password.
badwords = curitiba camara senha segredo 123456" >> "$PWQCONF"
fi

