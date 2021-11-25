# Repositório para os scripts da imagem Mint/Cinnamon

## Diretrizes

1. Devem ser criados _scripts_ para todas as operações possíveis.
1. De preferência, evitar a necessidade de _input_ enquanto o _script_ roda.
1. _Scripts_ devem ser [idempotentes](https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html#term-idempotency) (seguros para múltiplas execuções).
1. _Scripts_ devem ser verificados com o `shellcheck`.

## Requisitos

1. Os _scripts_ foram testados no **Mint 20 Cinnamon**.

## Instalação/configuração

Procedimento:

1. Instalar o Mint normalmente;
   - Crie a conta padrão `suporte`.
2. É recomendado realizar a atualização do sistema operacional antes de configurar a ETv4;
3. Faça login com o usuário criado;
4. Baixe os _scripts_ do [repositório](https://github.com/CMCuritiba/ETv4/).
5. Crie um arquivo na pasta raíz do projeto chamado `vars.env` e utilize o arquivo `.env.example` como base para preencher todas as variáveis necessárias para a execução dos scripts. As variáveis são:

   - PASS_SUPPORT: senha do usuário suporte
   - PASS_ROOT: senha do usuário root
   - PASS_VNC: senha do login remoto (VNC)
   - SERV_LDAP: IP do servidor LDAP (pode ser passado dois)
   - LDAP_USERS_DN: nome distinto base de usuarios
   - LDAP_GROUPS_DN: nome distinto base de grupos
   - BIND_DN: nome distinto de bind
   - BIND_PW: password de bind
   - NFS_SERV: servidor nfs

6. Execute os _scripts_ com permissão de `root`:
   - `sudo ./principal.sh`
7. Reinicie e faça login com seu usuário do domínio.
