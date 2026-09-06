# Estação de Trabalho (ET) - CMC

[![Versão](https://img.shields.io/badge/vers%C3%A3o-6.1.1-0A7B83)](./package.json)
[![Licença](https://img.shields.io/badge/licen%C3%A7a-GPL--3.0--or--later-2E8B57)](./.github/LICENSE.md)
[![Linux Mint](https://img.shields.io/badge/Linux%20Mint-22.2%20Cinnamon-86BE43)](#ambiente-validado)
[![Ansible](https://img.shields.io/badge/Ansible-role-EE0000?logo=ansible&logoColor=white)](#diretrizes)
[![Conventional Commits](https://img.shields.io/badge/Commits-Conventional-FE5196)](https://www.conventionalcommits.org/pt-br/)
[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)

Automação em [Ansible](https://docs.ansible.com/) para provisionar e padronizar a imagem Linux Mint/Cinnamon das estações de trabalho da CMC.

O repositório concentra a _role_ principal `estacao`, o _playbook_ de aplicação, arquivos de apoio para teste e a documentação operacional usada na implantação e validação do ambiente.

<p align="center">
  <img src="./roles/estacao/files/imagens/login-bg.jpg" alt="Tela de login padronizada da estação de trabalho CMC" width="48%" height="320" style="object-fit: cover;" />
  <img src="./roles/estacao/files/imagens/desktop-bg.jpg" alt="Área de trabalho padronizada da estação de trabalho CMC" width="48%" height="320" style="object-fit: cover;" />
</p>

<p align="center"><em>Wallpapers para a tela de login e desktop, versão 2026.</em></p>

<a id="diretrizes"></a>
<details>
  <summary><strong>Diretrizes</strong></summary>

1. Devem ser criadas _tasks_ para todas as operações possíveis.
2. As _tasks_ devem ser [idempotentes](https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html#term-idempotency) (seguras para múltiplas execuções).
3. Buscar sempre seguir as [Ansible Best Practices](https://docs.ansible.com/ansible/2.8/user_guide/playbooks_best_practices.html)

</details>

<a id="ambiente-validado"></a>
## Ambiente validado

O código foi testado no **Mint 22.2 Cinnamon (Zara)**.

---

<a id="arquitetura-do-projeto"></a>
<details>
  <summary><strong>Arquitetura do projeto</strong></summary>

<details>
  <summary><strong>Simplificada</strong></summary>

```text
.
├── .github/        # templates, políticas do repositório e automações do GitHub
├── .husky/         # hooks locais de commit
├── docs/           # guias de uso, testes e migração
├── inventory/      # inventário e variáveis por ambiente
├── roles/          # roles Ansible do projeto
│   └── estacao/    # role principal que configura a estação de trabalho
├── vagrant/        # ambiente local de testes com Vagrant
└── node_modules/   # dependências locais de tooling JavaScript
```

</details>

<details>
  <summary><strong>Completa</strong></summary>

```text
.
├── README.md
├── CHANGELOG.md
├── playbook.yml
├── playbook.local.yml
├── package.json
├── package-lock.json
├── commitlint.config.js
├── docs/
│   ├── README.md
│   ├── TESTING.md
│   ├── caderno-de-testes.md
│   └── migracao-mint22.md
├── inventory/
│   ├── inventory.yml
│   ├── vault.yml
│   └── group_vars/
│       ├── all.yml
│       └── all.yml.example
├── roles/
│   └── estacao/
│       ├── defaults/
│       ├── files/
│       ├── handlers/
│       ├── meta/
│       ├── molecule/
│       ├── tasks/
│       ├── templates/
│       ├── tests/
│       ├── vars/
│       ├── ESTACAO-tasks-dependencies.md
│       └── PR-CHANGELOG.md
└── vagrant/
    └── Vagrantfile
```

</details>

</details>

---

<a id="documentação-relacionada"></a>
<details>
  <summary><strong>Documentação relacionada</strong></summary>

- [README da pasta `docs`](./docs/README.md): índice da documentação do projeto.
- [Guia de testes](./docs/TESTING.md): fluxo resumido de validação.
- [Caderno de testes](./docs/caderno-de-testes.md): checklist operacional com evidências.
- [Guia da migração para Mint 22](./docs/migracao-mint22.md): contexto e impactos da atualização da base.
- [Dependências entre tasks](./roles/estacao/ESTACAO-tasks-dependencies.md): mapa técnico da role.
- [Referência das tasks](./roles/estacao/tasks/README.md): verificação funcional por etapa.

</details>

---

<a id="instalaçãoconfiguração-para-produção"></a>
<details>
  <summary><strong>Instalação/configuração para produção</strong></summary>

$$
\color{red}\Large{\textsf{LEIA\ ATENTAMENTE\ O\ GUIA\ ANTES\ DE\ EXECUTAR\ OS\ COMANDOS!}}
$$

A configuração da Estação de Trabalho em uma máquina é realizada de forma
remota, por SSH. Para rodar este código, você precisa configurar a sua estação
de trabalho, instalando os pacotes necessários listados a seguir.

### Pré-requisitos

Antes de executar o playbook, garanta o seguinte:

- Na máquina de controle:
  - Python 3 instalado
  - Ansible instalado
  - dependência `passlib` disponível no ambiente do Ansible
  - `sshpass` instalado para autenticação por senha, quando necessário
  - acesso ao repositório e ao arquivo `inventory/group_vars/all.yml`
- Na máquina alvo:
  - Linux Mint instalado
  - conta inicial de administração disponível para SSH
  - serviço SSH ativo e acessível pela rede
  - IP ou nome DNS resolvível a partir da máquina de controle
- No inventário e variáveis:
  - `inventory/inventory.yml` apontando para o host correto
  - `inventory/group_vars/all.yml` preenchido com valores reais do ambiente
  - credenciais e parâmetros de AD/S3 revisados antes da execução

### Procedimento:

1. Instale o Mint em um novo computador:
   1. Instale o SO com idioma Português do Brasil;
   2. <a id="user_suporte"></a>Crie a conta padrão `suporte`.
2. Faça login com o usuário criado;
3. É recomendado realizar a atualização do sistema operacional antes de
   configurar a ET;
4. Certifique-se de que o serviço SSH esteja funcionando e que você consiga
   acessar este computador por SSH com o usuário criado;
5. Certifique-se de que o IP deste computador esteja cadastrado no DNS.

   Na primeira vez, pode ser necessário instalar e habilitar o servidor SSH na
   máquina de destino. Esse bootstrap inicial é necessário porque a task da role
   que instala `openssh-server` só consegue rodar depois que já existe acesso
   remoto por SSH:

   ```shell
   sudo apt install -y openssh-server
   sudo systemctl enable --now ssh
   ```

   Depois disso, valide o acesso inicial com o usuário local criado na
   instalação do Mint. Exemplo:

   ```shell
   ssh oem@10.0.1.82
   ```

   Resumo do bootstrap mínimo da primeira execução:
   1. acessar a máquina localmente;
   2. instalar `openssh-server`;
   3. habilitar e iniciar o serviço `ssh`;
   4. validar o acesso remoto com um usuário local existente;
   5. só então executar o playbook por Ansible a partir da sua estação.

---

A configuração da estação é realizada de forma remota por SSH com o Ansible.
Configure o **seu** computador:

1. <a name="ansible-install"></a>Para começar, instale o Ansible de acordo com a
   [documentação oficial](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
   (recomendamos o [pipx](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pipx), conforme orientação oficial para ambientes gerenciados como Ubuntu 24.04 / Linux Mint 22):

   ```shell
   sudo apt install -y pipx
   pipx ensurepath
   pipx install --include-deps ansible
   ```

   Instale as dependências da _role_:

   ```shell
   pipx inject ansible passlib
   ```

   Para acessar o computador remoto, será necessário o `sshpass`:

   ```shell
   sudo apt install -y sshpass
   ```

   Observação importante:
   - o `sshpass` apenas automatiza a senha de uma conexão SSH já disponível;
   - ele não substitui a instalação inicial do `openssh-server` na máquina de
     destino;
   - se a instalação padrão do Linux Mint não vier com `openssh-server`, será
     necessário um bootstrap inicial no host remoto antes da primeira execução
     do Ansible por SSH.

2. Baixe o código do [repositório](https://github.com/CMCuritiba/Estacao-Trabalho-CMC)
   via `git` ou baixando o zip.
3. Utilize o arquivo [`all.yml.example`](./inventory/group_vars/all.yml.example)
   como exemplo para criar um novo arquivo de configuração `inventory/group_vars/all.yml`,
   de acordo com o necessário. 
   **Pré-requisito obrigatório**

   - Os valores do arquivo de exemplo (`all.yml.example`) são apenas referência.
   - Antes de executar o playbook, substitua todos os campos obrigatórios por dados reais do seu ambiente.
   - Se valores fictícios forem mantidos (ex.: domínio, IPs de AD, usuário/senha de join), o playbook poderá falhar nas etapas de DNS/hostname/integração AD.
   As variáveis são:
   - `estacao_suporte_user`: usuário local para suporte
   - `estacao_suporte_pass`: senha do usuário suporte
   - `estacao_root_pass`: senha do usuário root
   - `estacao_vnc_pass`: senha do login remoto (VNC)
   - `estacao_dtic_group`: grupo do AD que irá gerenciar as estações
   - `estacao_dtic_network`: CIDR da rede que irá gerenciar as estações
   - `estacao_ad_ip_addresses`: lista de endereços IP do servidor AD
   - `estacao_ad_domain`: domínio do AD
   - `estacao_ad_join_user`: nome do usuário de join (apenas para permitir a
     configuração, não ficará _hard-coded_ na ET)
   - `estacao_ad_join_pass`: password de usuário de join (apenas para permitir a
     configuração, não ficará _hard-coded_ na ET)
   - `estacao_s3fs_bucket_name`: nome do aws s3 bucket para o mount
   - `estacao_s3fs_access_key`: access key para acesso ao bucket de mount
   - `estacao_s3fs_secret_access_key`: secret access key para acesso ao bucket de mount
   - `estacao_s3fs_endpoint`: **OPCIONAL**, região do bucket
   - `estacao_mnt_suporte`: **OPCIONAL**, ponto de montagem local
   - `estacao_ad_fallback_ips`: **OPCIONAL**, lista de IPs para fallback de DNS

   **Importante (AD e credenciais de join):**

     - Preencha `estacao_ad_ip_addresses` com os IPs reais dos controladores de domínio em produção.
     - Se você não souber esses IPs, peça para a equipe responsável por AD/rede.
     - `estacao_ad_join_user` e `estacao_ad_join_pass` são confidenciais: solicite a quem administra o AD.
     - Não commite credenciais reais no repositório (`all.yml`, `vault.yml` ou qualquer outro arquivo versionado).

4. Adicione o nome ou o endereço IP do computador onde será configurada a
   estação no [inventário](./inventory/inventory.yml). Você poderá aplicar a
   configuração em mais de um computador ao mesmo tempo, configurando os hosts
   no inventário. Por exemplo, para aplicar em dois computadores ao mesmo tempo,
   um utilizando o nome DNS e o outro utilizando seu endereço IP, configure o
   inventário como a seguir:

   ```yaml
   ---
   all:
   hosts:
     pc-dtic-199:
     et2:
       ansible_host: 10.0.199.200
   ```

   Neste exemplo, a conexão com o host `pc-dtic-199` usará o IP obtido via DNS.
   Já para `et2`, a conexão usará o IP informado em `ansible_host`. Se você
   informar o IP, o nome utilizado no host não importa (`et2`, no exemplo).

   Para mais informações sobre como configurar o inventário,
   [leia a documentação](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html).

5. Verifique se é possível alcançar a(s) máquina(s) via ansible (veja parâmetros
   adicionais no próximo item):

   ```shell
   ansible all -m ping -i inventory/inventory.yml
   ansible pc-dtic-199 -m ping -i inventory/inventory.yml
   ansible et2 -m ping -u suporte -k -i inventory/inventory.yml
   ```

6. Para aplicar o _playbook_, você utilizará o usuário/senha informados na
   instalação do Mint no novo computador ([definido aqui](#user_suporte)).
   Aplique o _playbook_ com o comando:

   ```shell
   ansible-playbook -u suporte -Kk playbook.yml -i inventory/inventory.yml --diff
   ```

   - `-u`: Usuário criado no novo computador a ser configurado
   - `-K`: Solicita a senha para sudo
   - `-k`: Solicita a senha para ssh
   - `-i`: Inventário a ser utilizado
   - `--diff`: Mostra o resultado de cada operação (opcional)
   - Opcionalmente, você também pode utilizar o parâmetro `--check` para apenas
     verificar o que será feito, sem alterar nada efetivamente (modo _dry-run_).

   Fluxo recomendado de acesso:
   - na primeira execução, use um usuário local já existente na máquina de
     destino, como o usuário criado durante a instalação do Mint;
   - após a task `140-integra-ad.yml` ser aplicada com sucesso e o acesso por SSH
     com seu usuário de domínio funcionar, passe a executar o playbook com o seu
     próprio usuário do AD.

   Se quiser gravar a execução em um arquivo local preservando a saída ANSI do
   terminal, use `script`. Esse comando deve ser executado com o seu usuário do
   AD e faz mais sentido depois que a task de integração ao domínio já tiver sido
   aplicada com sucesso:

   ```shell
   script -qefc "ANSIBLE_FORCE_COLOR=1 PY_COLORS=1 ansible-playbook playbook.yml -i inventory/inventory.yml --diff -u <seu-usuario-ad> -k -K" ./LOG_ansible-playbook.typescript
   ```

   Para executar em modo verboso, adicione `-vvv` ao comando do
   `ansible-playbook`:

   ```shell
   script -qefc "ANSIBLE_FORCE_COLOR=1 PY_COLORS=1 ansible-playbook playbook.yml -i inventory/inventory.yml --diff -u <seu-usuario-ad> -k -K -vvv" ./LOG_ansible-playbook.typescript
   ```

   Para visualizar o arquivo preservando as cores no terminal:

   ```shell
   less -R ./LOG_ansible-playbook.typescript
   ```

   Observações:
   - o arquivo `.typescript` é um log de terminal, não um `.txt` comum;
   - abrir o arquivo em editores simples pode mostrar sequências ANSI em vez de
     cores;
   - antes da integração AD, substitua `<seu-usuario-ad>` pelo usuário local inicial da
     máquina de destino;
   - use `-vvv` apenas quando precisar investigar falhas com mais detalhe.

O playbook deve terminar sem erros.

Reinicie a nova estação de trabalho e faça login com seu usuário do domínio.

</details>

---

<a id="trabalhando-no-código"></a>
<details>
  <summary><strong>Trabalhando no código</strong></summary>

Nesta seção você encontrará informações essenciais para configurar o ambiente de desenvolvimento **no seu computador pessoal**, entender a estrutura do código e contribuir de forma eficiente. Seja você um desenvolvedor experiente ou um colaborador iniciante, esta seção foi criada para guiá-lo no processo de trabalho com o código-fonte do projeto, diretamente na sua máquina.

Antes de começar, certifique-se de que seu computador atende aos requisitos necessários e de que você possui as ferramentas adequadas instaladas. Vamos cobrir desde a configuração inicial até as práticas recomendadas para garantir uma experiência de desenvolvimento fluida e produtiva. Siga as instruções abaixo para preparar seu ambiente local e começar a contribuir!

---

<a id="configurando-seu-ambiente-de-trabalho"></a>
<details>
  <summary><strong>Configurando seu ambiente de trabalho</strong></summary>

1. Clone este repositório para a sua máquina

   ```shell
   mkdir ~/workspace
   cd ~/workspace/
   git clone git@github.com:CMCuritiba/Estacao-Trabalho-CMC.git
   ```

2. Instale o Ansible, Molecule e Vagrant:

   1. Instale o [Ansible](#ansible-install);
      1. Para aplicar o ansible nas máquinas de destino, você poderá precisar do
         `sshpass`. Instale-o com:

         ```shell
         sudo apt install sshpass
         ```

   2. Instale o Molecule e seus plugins, de acordo com a [documentação oficial](https://ansible.readthedocs.io/projects/molecule/installation/):

      ```shell
      # Antes de instalar, crie e ative um virtualenv
      $ cd ~/workspace/
      $ python3 -m venv molecule
      $ source ~/workspace/molecule/bin/activate
      # Instale o molecule e os plugins
      (molecule) $ pip install molecule
      (molecule) $ pip install "molecule-plugins[vagrant]"
      # Por alguma razão o molecule se perde ao buscar os módulos instalados:
      (molecule) $ pip install ansible
      # Instale as dependências da role:
      (molecule) $ pip install passlib
      ```

   3. <a name="vagrant-install"></a>Instale o Vagrant de acordo com a
      [documentação oficial](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant#linux).

      **Atenção**: se o seu sistema operacional for o Linux Mint, durante a
      instalação certifique-se de utilizar a versão base do ubuntu no
      _source list_ do vagrant a ser criado. O comando `lsb_release -cs` retorna
      a versão do Mint e não irá funcionar para a instalação do vagrant. A
      versão base do seu Mint pode ser verificada nos arquivos:

      - `/etc/apt/sources.list.d/official-package-repositories.list`
      - `/etc/upstream-release/lsb-release`

3. Opcionalmente, ative o [commitlint](https://github.com/conventional-changelog/commitlint) e
   o [commitzen](https://github.com/commitizen/cz-cli) no repositório:

   1. Instale [`npm e node`](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm);
   2. Na pasta do repositório, rode:

      ```shell
      cd ~/workspace/Estacao-Trabalho-CMC/
      npm install
      ```

   3. Esta configuração não é obrigatória, mas se você não utilizar
      [_Conventional Commits_](https://www.conventionalcommits.org/pt-br/),
      iremos julgar os seus commits :stuck_out_tongue_winking_eye:
   4. O commitzen não integra com o VS Code, para uso no editor considere
      [instalar uma extensão](https://github.com/commitizen/cz-cli#adapters).

   [![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)

</details>

---

<a id="testando"></a>
<details>
  <summary><strong>Testando</strong></summary>

É possível utilizar o [Molecule](https://ansible.readthedocs.io/projects/molecule/) para automatizar testes com o [Vagrant](https://www.vagrantup.com/) para testes locais.

1. <a name="virtualbox-install"></a>Instale o VirtualBox:

   ```shell
   sudo apt install virtualbox virtualbox-dkms virtualbox-ext-pack virtualbox-qt
   ```

2. Utilize o arquivo [`all.yml.example`](./inventory/group_vars/all.yml.example)
   como exemplo para criar um novo arquivo de configuração `all.yml`, de acordo
   com o necessário;

3. Teste o _converge_:

   ```shell
   cd ~/workspace/Estacao-Trabalho-CMC/roles/estacao/
   $ source ~/workspace/molecule/bin/activate
   (molecule) $ molecule converge -- --diff
   # Ou, em um único comando: 
   (molecule) $ molecule test
   ```

Obs: Se for necessário testar apenas tasks específicas, é possível ser utilizar o
parâmetro `--tags "tag-desejada"` informando as tags definidas na [role](./roles/estacao/tasks/main.yml). 

Para, por exemplo, aplicar apenas as tasks relacionadas ao DNS:

   ```shell
   (molecule) $ molecule converge -- --tags "dns" --diff
   ```

O molecule criará, por meio do Vagrant, uma instância no VirtualBox utilizando a
versão do Mint especificada no [molecule](./roles/estacao/molecule/default/molecule.yml)
e aplicará a _role_ automaticamente na VM.

A primeira execução irá demorar um pouco porque será necessário baixar a imagem
do Mint (~3,5 GB).

Para testar com outras versões do Mint ou outros sistemas operacionais, basta
alterar ou adicionar instâncias no [molecule](./roles/estacao/molecule/default/molecule.yml).

---

Caso seja necessário realizar os testes manualmente sem utilizar o Molecule, é possível utilizar apenas o [Vagrant](https://www.vagrantup.com/) para os testes locais.

1. Instale o [VirtualBox](#virtualbox-install) e o [Vagrant](#vagrant-install), como descrito acima.
2. Utilize o [Vagrantfile](./vagrant/Vagrantfile) para subir uma VM do Mint:

   ```shell
   cd vagrant
   vagrant up
   ```

3. Acesse a VM (com o usuário `vagrant`):

   ```shell
   vagrant ssh
   ```

4. Já dentro da VM, baixe o fonte (neste exemplo, do branch **develop**) e
   execute o código:

   ```shell
   wget https://github.com/CMCuritiba/Estacao-Trabalho-CMC/archive/refs/heads/develop.zip
   unzip develop.zip
   cd Estacao-Trabalho-CMC-develop/
   sudo apt update
   sudo apt install pip -y
   pip install --user ansible
   source ~/.profile # Necessário apenas na primeira vez
   nano inventory/group_vars/all.yml # Edite de acordo com o necessário
   sed -i 's/et1/localhost/g' playbook.yml
   ansible-playbook --diff playbook.yml -i inventory/inventory.yml
   ```

5. Depois de executadas as tasks, de volta no seu computador, você pode dar SSH na VM usuário `suporte` ou com seu
   usuário do AD:

   ```shell
   # Para descobrir a porta para conexão:
   vagrant ssh-config
   # Para acessar a VM:
   ssh -p 2222 suporte@localhost
   # ou
   ssh -p 2222 nome.sobrenome@localhost
   ```

</details>

</details>

---

<a id="solução-de-problemas"></a>
<details>
  <summary><strong>Solução de problemas</strong></summary>

### Erro de hostname/AD no playbook

Se o playbook falhar com mensagem parecida com `Hostname não configurado, abortando`:

> Importante: as variáveis de `inventory/group_vars/all.yml` sobrescrevem os defaults da role.
> Se `estacao_ad_domain` estiver incorreto (ex.: `example.com` em vez de `cmc.local`),
> o bloco de integração AD irá falhar nessa validação.

1. Revise as variáveis de domínio e DNS em `inventory/group_vars/all.yml`:
   - `estacao_ad_domain`
   - `estacao_ad_ip_addresses`
   - `estacao_ad_fallback_ips`
   - `estacao_ad_join_user`
   - `estacao_ad_join_pass`
2. Confirme consistência entre inventário e host-alvo:
   - `estacao_ad_domain` deve aparecer em `hostname -f`
   - exemplo: se `hostname -f` retorna `pc-dtic-12.cmc.local`, use `estacao_ad_domain: cmc.local`
   - `estacao_ad_ip_addresses` deve conter IPs reais dos controladores de domínio
3. Se não souber os dados corretos de join, pare aqui e solicite ao responsável:
   - usuário real de join (`estacao_ad_join_user`)
   - senha real de join (`estacao_ad_join_pass`)
   - IPs reais do AD (`estacao_ad_ip_addresses`)
   - **não** registrar essas credenciais em commit
4. Reaplique primeiro os blocos de DNS/boot/AD:

   ```shell
   ansible-playbook -i inventory/inventory.yml playbook.yml --tags dns,boot,ad --diff
   ```

5. Valide no host-alvo:

   ```shell
   hostname -f
   resolvectl status
   realm list
   ```

### Erros do Molecule com permissão em `~/.ansible/tmp`

Em ambientes com diretório HOME restrito, execute com `ANSIBLE_HOME` e temporários em `/tmp`:

```shell
export ANSIBLE_HOME=/tmp/.ansible
export ANSIBLE_LOCAL_TEMP=/tmp/ansible-local
export ANSIBLE_REMOTE_TEMP=/tmp/ansible-remote
mkdir -p /tmp/.ansible/tmp /tmp/ansible-local /tmp/ansible-remote
```

### Erro no Molecule: role `estacao` não encontrada

Se aparecer `the role 'estacao' was not found`, execute dentro da pasta da role e defina `ANSIBLE_ROLES_PATH`:

```shell
cd ~/workspace/Estacao-Trabalho-CMC/roles/estacao
export ANSIBLE_ROLES_PATH="$PWD/.."
molecule test
```

### Erro do Vagrant/VirtualBox (`NS_ERROR_SOCKET_FAIL`)

Se o `vagrant up` falhar com erro de `VBoxManage`:

1. Verifique se o VirtualBox abriu corretamente no host.
2. Reinicie os serviços do VirtualBox (ou reinicie o computador).
3. Tente novamente:

   ```shell
   cd vagrant
   vagrant up
   ```

### Erros de APT com repositórios de terceiros

Problemas comuns observados:

- HashiCorp em suíte errada (`wilma`): use `noble`.
- Spotify com `NO_PUBKEY`: renovar chave GPG e usar `signed-by`.
- Serpro com aviso de `binary-i386`: restringir para `arch=amd64`.
- Wine com suítes duplicadas (`noble` e `questing`): manter somente a suíte correta da base Ubuntu.

</details>

---

<a id="como-contribuir"></a>
## Como contribuir

Toda contribuição é bem vinda!

Para ajudar-nos a manter o bom trabalho, por favor leia nossas
[diretrizes](.github/CONTRIBUTING.md) e
[código de conduta](.github/CODE_OF_CONDUCT.md).
