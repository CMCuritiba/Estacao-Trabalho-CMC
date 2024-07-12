# Repositório para os scripts da imagem Mint/Cinnamon

## Diretrizes

1. Devem ser criadas _tasks_ para todas as operações possíveis.
2. As _tasks_ devem ser [idempotentes](https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html#term-idempotency) (seguras para múltiplas execuções).
3. Buscar sempre seguir as [Ansible Best Practices](https://docs.ansible.com/ansible/2.8/user_guide/playbooks_best_practices.html)

## Requisitos

O código foi testado no **Mint 21.3 Cinnamon**.

## Instalação/configuração para produção

$$
\color{red}\Large{\textsf{LEIA\ ATENTAMENTE\ TODO\ O\ GUIA\ ANTES\ DE\ EXECUTAR\ OS\ COMANDOS}}
$$

A configuração da Estação de Trabalho em uma máquina é realizada de forma
remota, por SSH. Para rodar este código, você precisa configurar a sua estação
de trabalho, instalando os pacotes necessários listados a seguir.

Procedimento:

1. Instale o Mint em um novo computador:
   1. Instale o SO com idioma Português do Brasil;
   2. <a id="user_suporte"></a>Crie a conta padrão `suporte`.
2. Faça login com o usuário criado;
3. É recomendado realizar a atualização do sistema operacional antes de
   configurar a ET;
4. Certifique-se de que o serviço SSH esteja funcionando e que você consiga
   acessar este computador por SSH com o usuário criado;
5. Certifique-se de que o IP deste computador esteja cadastrado no DNS.

A configuração da estação é realizada de forma remota por SSH com o Ansible.
Configure o **seu** computador:

1. <a name="ansible-install"></a>Para começar, instale o Ansible de acordo com a
   [documentação oficial](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
   (sugerimos [fazer a instalação usando o pip](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pip)):

   ```shell
   curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
   python3 get-pip.py --user
   python3 -m pip install --user ansible
   ```

   Instale as dependências da _role_:

   ```shell
   python3 -m pip install --user passlib
   ```

   Para acessar o computador remoto, será necessário o `sshpass`:

   ```shell
   sudo apt install -y sshpass
   ```

2. Baixe o código do [repositório](https://github.com/CMCuritiba/Estacao-Trabalho-CMC)
   via `git` ou baixando o zip.
3. Utilize o arquivo [`all.yml.example`](./inventory/group_vars/all.yml.example)
   como exemplo para criar um novo arquivo de configuração `inventory/group_vars/all.yml`,
   de acordo com o necessário. As variáveis são:

   - `estacao_suporte_user`: usuário local para suporte
   - `estacao_suporte_pass`: senha do usuário suporte
   - `estacao_root_pass`: senha do usuário root
   - `estacao_vnc_pass`: senha do login remoto (VNC)
   - `estacao_dtic_group`: grupo do AD que irá gerenciar as estações
   - `estacao_dtic_network`: CIDR da rede que irá gerenciar as estações
   - `estacao_ad_ip_addresses`: lista de endereços IP do servidor AD
   - `estacao_ad_domain`: dominio do AD
   - `estacao_ad_join_user`: nome do usuário de join (apenas para permitir a
     configuração, não ficará _hard-coded_ na ET)
   - `estacao_ad_join_pass`: password de usuário de join (apenas para permitir a
     configuração, não ficará _hard-coded_ na ET)
   - `estacao_s3fs_bucket_name`: nome do aws s3 bucket para o mount
   - `estacao_s3fs_access_key`: access key para acesso ao bucket de mount
   - `estacao_s3fs_secret_access_key`: secret access key para acesso ao bucket de mount
   - `estacao_s3fs_endpoint`: **OPCIONAL**, região do bucket
   - `estacao_mnt_suporte`: **OPCIONAL**, ponto de montagem local
   - `estacao_ntp_servers`: **OPCIONAL**, lista de servidores NTP
   - `estacao_ad_fallback_ips`: **OPCIONAL**, lista de IPs para fallback de DNS

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

6. Para aplicar o _playbook_, você utilizará o usuário/senha utilizados na
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

O playbook deve terminar sem erros.

Reinicie a nova estação de trabalho e faça login com seu usuário do domínio.

## Contribuindo

### Configurando seu ambiente de trabalho

1. Clone este repositório para sua máquina

   ```shell
   mkdir ~/workspace
   cd ~/workspace/
   git clone git@github.com:CMCuritiba/Estacao-Trabalho-CMC.git
   ```

2. Instale o Ansible, Molecule e Vagrant:

   1. Instale o [Ansible](#ansible-install) o `sshpass`;
   2. <a name="vagrant-install"></a>Instale o Vagrant de acordo com a
      [documentação oficial](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant#linux).

      **Atenção**: se o seu sistema operacional for o Linux Mint, durante a
      instalação certifique-se de utilizar a versão base do ubuntu no
      _source list_ do vagrant a ser criado. O comando `lsb_release -cs` retorna
      a versão do Mint e não irá funcionar para a instalação do vagrant. A
      versão base do seu Mint pode ser verificada nos arquivos:

      - `/etc/apt/sources.list.d/official-package-repositories.list`
      - `/etc/upstream-release/lsb-release`

   3. Instale o Molecule e seus plugins, de acordo com a [documentação oficial](https://ansible.readthedocs.io/projects/molecule/installation/):

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

3. Opcionalmente, ative o [commitlint](https://github.com/conventional-changelog/commitlint) e
   o [commitzen](https://github.com/commitizen/cz-cli) no repositório:

   1. Instale [`npm e node`](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm);
   2. Na pasta do repositório, rode:

      ```shell
      cd ~/workspace/Estacao-Trabalho-CMC/
      npm install
      ```

   3. Esta configuração não é obrigatória, mas **fortemente** recomendada;
   4. O commitzen não integra com o VS Code, para uso no editor considere
      [instalar uma extensão](https://github.com/commitizen/cz-cli#adapters).

   [![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)

### Testando

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
   ```

4. Se for necessário testar apenas tasks específicas, é possível ser utilizar o
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
2. Utilize o [Vagrantfile](./Vagrantfile) na raiz do repositório para subir uma VM do Mint:

   ```shell
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
