# Repositório para os scripts da imagem Mint/Cinnamon (ETv6)

## Diretrizes

1. Devem ser criados _scripts_ para todas as operações possíveis.
1. De preferência, evitar a necessidade de _input_ enquanto o _script_ roda.
1. _Scripts_ devem ser [idempotentes](https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html#term-idempotency) (seguros para múltiplas execuções).
1. _Scripts_ devem ser verificados com o `shellcheck`.

## Requisitos

1. Os _scripts_ foram testados no **Mint 21.1 Cinnamon**.

## Instalação/configuração

Procedimento:

1. Instalar o Mint normalmente;
   - Crie a conta padrão `suporte`.
2. É recomendado realizar a atualização do sistema operacional antes de configurar a ETv5;
3. Faça login com o usuário criado;
4. Baixe os _scripts_ do [repositório](https://github.com/CMCuritiba/Estacao-Trabalho-CMC).
5. Crie um arquivo na pasta raíz do projeto chamado `.env` e utilize o arquivo `.env.example` como base para preencher todas as variáveis necessárias para a execução dos scripts. As variáveis são:

   - PASS_SUPPORT: senha do usuário suporte
   - PASS_ROOT: senha do usuário root
   - PASS_VNC: senha do login remoto (VNC)
   - AD_ADDRESS: IP do servidor AD
   - AD_DOMAIN: dominio do AD
   - AD_JOIN: nome do usuário de join
   - AD_JOIN_PWD: password de usuário de join
   - NFS_SERV: servidor nfs

6. Execute os _scripts_ com permissão de `root`:
   - `sudo ./principal.sh`
7. Reinicie e faça login com seu usuário do domínio.
