# Repositório para os scripts da imagem Mint/Mate

## Diretrizes

1. Devem ser criados _scripts_ para todas as operações possíveis.
1. De preferência, evitar a necessidade de _input_ enquanto o _script_ roda.
1. _Scripts_ devem ser [idempotentes](https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html#term-idempotency) (seguros para múltiplas execuções).
1. _Scripts_ devem ser verificados com o `shellcheck`.

## Requisitos

1. Os _scripts_ foram testados no **Mint 19.3**.

## Instalação/configuração

Procedimento:

1. Instalar o Mint normalmente;
   - Crie a conta padrão `suporte`.
2. É recomendado realizar a atualização do sistema operacional antes de configurar a ETv4;
3. Faça login com o usuário criado;
4. Baixe os _scripts_ do [repositório](https://github.com/CMCuritiba/ETv4/).
5. Execute os _scripts_ com permissão de `root` (será necessário _input_ em alguns momentos):
   - `sudo ./principal.sh`
6. Reinicie e faça login com seu usuário do domínio.
