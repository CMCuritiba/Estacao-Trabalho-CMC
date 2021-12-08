#!/bin/bash
# Script devem rodados como root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    printf "\033[1;31m----------------- Erro ---------------------\033[0m\n"
    printf "\033[1;31mEstes scripts devem ser executados como root\033[0m\n"
    exit 1
fi

scriptsDir=$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")
# O arquivo de configuração precisa existir
if [ -f "$scriptsDir/.env" ]; then

    if [[ "$(stat --printf="%a" "$scriptsDir/.env")" != "600" ]]; then
        echo "Arquivo de configuração possui permissões inválidas (veja o README para mais informações)"
        exit 1
    fi

    if [ -f "/usr/local/cmc/script-completo" ]; then
        echo "Todos os scripts já foram rodados, delete a flag /usr/local/cmc/script-completo se deseja rodá-los novamente. Aviso, rodar alguns dos scripts mais de uma vez pode sobreescrever mudanças feitas após a execução."
        exit 1
    fi

    if ! cd "$scriptsDir/scripts"; then
        echo "Pasta scripts não encontrada."
        exit 2
    fi

    # Atentar a ordem dos scripts a serem rodados
    # Coloca arquivo executado em /usr/local/cmc/script-andamento
    # Cria arquivo script-completo se terminar e deleta script-andamento
    if [ ! -f "/usr/local/cmc/script-andamento" ]; then
        touch /usr/local/cmc/script-andamento
    fi

    mkdir -p /usr/local/cmc

    # O "read -d ''" é necessário para casar com o resultado do find utilizando
    # o parâmetro -print0. Isto garante o tratamento correto de qualquer nome
    # que os scripts .sh possam ter.
    # O "sort -z" ordena considerando '' como o separador de strings.
    # Não é possivel executar comandos interativos dentro do while
    files=()
    while read -r -d '' file; do
        files+=("$file")
    done < <(find "$scriptsDir/scripts" -mindepth 1 -maxdepth 1 -name "*.sh" -print0 | sort -z)

    # Carrega o arquivo de configuração
    # shellcheck source=.env.example
    source "$scriptsDir/.env"

    for file in "${files[@]}"; do
        if grep -q "$file" "/usr/local/cmc/script-andamento"; then
            logger "Script $file já executado de acordo com histórico, pulando"
            continue
        fi
        logger "Executando arquivo $file"

        if ! bash -e "$file"; then
            logger "Erro ao rodar o script $file, abortando"
            printf "\033[1;31m----------------- Erro ---------------------\033[0m\n"
            printf "\033[1;31mErro ao rodar o script %s, abortando\033[0m\n" "$file"
            exit 2
        fi
        echo "$file" >>/usr/local/cmc/script-andamento
    done

    rm /usr/local/cmc/script-andamento
    touch /usr/local/cmc/script-completo
    logger "Scripts executados com sucesso"
    exit 0

else
    echo "Arquivo de configuração não encontrado (veja o README para mais informações)"
    exit 1
fi
