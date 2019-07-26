# /etc/profile.d/cmc-profile.sh - Exibe mensagem no login do usuario
# Atencao: para ser exibido, o arquivo 'login.msg' deve ser diferente do
# 'instant.msg'

if [ "$(id -u)" -ne 0 ]; then
	MSG="/mnt/suporte/login.msg"
	if [ -f "$MSG" ]; then
		/usr/local/cmc/scripts/instant.msg.sh "$MSG"
	fi
fi

