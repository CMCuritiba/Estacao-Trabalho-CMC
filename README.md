# Repositório para os scripts da imagem Mint/Cinnamon (ETv6)

## Diretrizes

1. Devem ser criados _scripts_ para todas as operações possíveis.
1. De preferência, evitar a necessidade de _input_ enquanto o _script_ roda.
1. _Scripts_ devem ser [idempotentes](https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html#term-idempotency) (seguros para múltiplas execuções).
1. _Scripts_ devem ser verificados com o `shellcheck`.

## Requisitos

1. Os _scripts_ foram testados no **Mint 21.3 Cinnamon**.

## Instalação/configuração

Procedimento:

1. Instalar o Mint normalmente;
   - Crie a conta padrão `suporte`.
2. É recomendado realizar a atualização do sistema operacional antes de configurar a ET;
3. Faça login com o usuário criado;
4. Baixe os _scripts_ do [repositório](https://github.com/CMCuritiba/Estacao-Trabalho-CMC).
5. Crie um arquivo na pasta raíz do projeto chamado `.env` e utilize o arquivo `.env.example` como base para preencher todas as variáveis necessárias para a execução dos scripts. As variáveis são:

   - `SUPORTE_PASS`: senha do usuário suporte
   - `ROOT_PASS`: senha do usuário root
   - `VNP_PASS`: senha do login remoto (VNC)
   - `DTIC_GROUP`: grupo do AD que irá gerenciar as estações
   - `DTIC_NETWORK`: CIDR da rede que irá gerenciar as estações
   - `AD_IP_ADDRESS`: IP do servidor AD (apenas para facilitar a configuração,
     não ficará _hard-coded_ na ET)
   - `AD_DOMAIN`: dominio do AD
   - `AD_JOIN_USER`: nome do usuário de join (apenas para permitir a
     configuração, não ficará _hard-coded_ na ET)
   - `AD_JOIN_PASS`: password de usuário de join (apenas para permitir a
     configuração, não ficará _hard-coded_ na ET)
   - `NFS_SERV`: servidor nfs

6. Execute os _scripts_ com permissão de `root`:
   - `sudo ./principal.sh`
7. Reinicie e faça login com seu usuário do domínio.

## Contribuindo

### Configurando seu ambiente de trabalho

1. Clone este repositório para sua máquina;
2. Opcionalmente, ative o [commitlint](https://github.com/conventional-changelog/commitlint) e
   o [commitzen](https://github.com/commitizen/cz-cli) no repositório:

   1. Instale [`npm e node`](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm);
   2. Na pasta do repositório, rode:

      ```shell
      npm install
      ```

   3. Esta configuração não é obrigatória, mas **fortemente** recomendada;
   4. O commitzen não integra com o VS Code, para uso no editor considere
      [instalar uma extensão](https://github.com/commitizen/cz-cli#adapters).

[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)

### Testando

É possível utilizar o [Vagrant](https://www.vagrantup.com/) para testes locais.

1. Instale o VirtualBox:

   ```shell
   sudo apt install virtualbox virtualbox-dkms virtualbox-ext-pack virtualbox-qt
   ```

2. Instale o Vagrant de acordo com a [documentação oficial](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant#linux);
3. Utilize o [Vagrantfile](./Vagrantfile) na raiz do repositório para subir uma VM do Mint:

   ```shell
   vagrant up
   ```

4. Acesse a VM:

   ```shell
   vagrant ssh
   ```

5. Já dentro da VM, baixe o fonte (neste exemplo, do branch **develop**) e
   execute o código:

   ```shell
   wget https://github.com/CMCuritiba/Estacao-Trabalho-CMC/archive/refs/heads/develop.zip
   unzip develop.zip
   cd Estacao-Trabalho-CMC-develop/
   cp .env.example .env
   chmod 600 .env
   # edite o .env de acordo com o necessário:
   nano .env
   sudo ./principal.sh
   ```

6. Depois de executados os scripts da estação de trabalho, de volta no seu
   computador, você pode dar SSH na VM usando o usuário `suporte` ou com seu
   usuário do AD:

   ```shell
   # Para descobrir a porta para conexão:
   vagrant ssh-config
   # Para acessar a VM:
   ssh -p 2222 suporte@localhost
   # ou
   ssh -p 2222 nome.sobrenome@localhost
   ```
