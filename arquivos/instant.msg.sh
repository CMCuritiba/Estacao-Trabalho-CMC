#!/bin/bash
# -----------------------------------------------------------------
# Mostra mensagem instantanea na tela - Aviso de rede
# Deve ser executado em background, no cron do usuario
# -----------------------------------------------------------------

# TODO
# Uma vez instalado no crontab do usuario, o CRON ira recriar a pasta home do
# usuario se ela for deletada manualmente do /home
# Verificar como corrigir isto.

# Arquivo de mensagem deve ser passado por parâmetro
if [ -z "$1" ]; then
  logger "[$0] Arquivo de mensagem esperado, mas nenhum fornecido."
  exit 1
fi
MSG="$1"

# Arquivo de mensagem local, copiado
MSGDIR=$HOME/.instant.msg
ARQ=$MSGDIR/instant.msg

# Usuário logado
WHO=$(id -un)
WHOSDISPLAY=$(w -h "$WHO" | awk '{print $3}')

# Funcao para mostrar a mensagem na tela
MostraMsg()
{
  if ! pgrep -f "zenity.*instant.msg" >/dev/null; then
    if zenity --text-info --height=500 --width=500 --display="$WHOSDISPLAY" --filename="$MSG" --title "Diretoria de Informática:" --checkbox="Estou ciente do aviso" 2>/dev/null; then
      'cp' -u "$MSG" "$MSGDIR" # as plicas garantem que o comando cp seja executado independente de alias no bashrc
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
elif [ -f "$MSG" ]; then
  if [ ! -d "$MSGDIR" ]; then
    mkdir "$MSGDIR"
  fi

  if [ -f "$ARQ" ]; then
    if ! diff "$MSG" "$ARQ" >/dev/null; then
      MostraMsg &
    fi
  else
    MostraMsg &
  fi
fi



