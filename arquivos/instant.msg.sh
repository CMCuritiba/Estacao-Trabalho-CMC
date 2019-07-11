#!/bin/bash
# -----------------------------------------------------------------
# Mostra mensagem instantanea na tela - Aviso de rede
# Deve ser executado em background, no cron do usuario
# -----------------------------------------------------------------

# TODO
# Uma vez instalado no crontab do usuario, o CRON ira recriar a pasta home do
# usuario se ela for deletada manualmente do /home
# Verificar como corrigir isto.

# Arquivo de mensagem remoto, no servidor
MNT=/mnt/suporte/instant.msg

# Arquivo de mensagem local, copiado
VAR=$HOME/.instant.msg
ARQ=$VAR/instant.msg

#Usuário logado
WHO=$( who | grep 'tty' | cut -d ' ' -f 1 )

# Funcao para mostrar a mensagem na tela
MostraMsg()
{
	if ! pgrep -f "zenity.*instant.msg" >/dev/null; then
		if zenity --text-info --height=500 --width=500 --display=:0 --filename="$MNT" --title "Diretoria de Informática:" --checkbox="Estou ciente do aviso" 2>/dev/null; then
			cp "$MNT" "$VAR"
			logger "[$0] Mensagem exibida. Usuario ciente."
		else
			logger "[$0] Mensagem exibida. Usuario cancelou."
		fi
	fi
}

if [ -z "$LOGNAME" ] || [ -z "$WHO" ]; then
        exit 0;
fi

if [ "$WHO" != "$LOGNAME" ]; then
        exit 0;
elif [ -f "$MNT" ]; then
  if [ ! -d "$VAR" ]; then
    mkdir "$VAR"
  fi

  if [ -f "$ARQ" ]; then
    if ! diff "$MNT" "$ARQ" >/dev/null; then
      MostraMsg &
    fi
  else
    MostraMsg &
  fi
fi



