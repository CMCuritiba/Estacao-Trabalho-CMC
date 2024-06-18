# Repositório para os scripts da imagem Mint/Cinnamon

## Diretrizes

1. Devem ser criadas _tasks_ para todas as operações possíveis.
2. De preferência, evitar a necessidade de _input_ enquanto a _task_ roda.
3. As _tasks_ devem ser [idempotentes](https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html#term-idempotency) (seguros para múltiplas execuções).
4. Buscar sempre seguir as [Ansible Best Practices](https://docs.ansible.com/ansible/2.8/user_guide/playbooks_best_practices.html)

## Requisitos

1. O _role_ foi testado no **Mint 21.3 Cinnamon**.

## Instalação/configuração

Procedimento:

1. Instale o Mint normalmente.
   - Crie a conta padrão `suporte`.
2. É recomendado realizar a atualização do sistema operacional antes de configurar a ET;
3. Faça login com o usuário criado;
4. Baixe o _codigo_ do [repositório](https://github.com/CMCuritiba/Estacao-Trabalho-CMC).
5. Utilize o arquivo [`all.yml.example`](./inventory/group_vars/all.yml.exemple)
   como exemplo para criar seu arquivo de configuração de acordo com o
   necessário. As variáveis são:

   - `estacao_suporte_user`: usuário local para suporte
   - `estacao_suporte_pass`: senha do usuário suporte
   - `estacao_root_pass`: senha do usuário root
   - `VNP_PASS`: senha do login remoto (VNC)
   - `estacao_dtic_group`: grupo do AD que irá gerenciar as estações
   - `estacao_dtic_network`: CIDR da rede que irá gerenciar as estações
   - `estacao_ad_ip_address`: IP do servidor AD (apenas para facilitar a configuração,
     não ficará _hard-coded_ na ET)
   - `estacao_ad_domain`: dominio do AD
   - `estacao_ad_join_user`: nome do usuário de join (apenas para permitir a
     configuração, não ficará _hard-coded_ na ET)
   - `estacao_ad_join_pass`: password de usuário de join (apenas para permitir a
     configuração, não ficará _hard-coded_ na ET)
   - `estacao_nfs_serv`: ip do servidor nfs
   - `estacao_nfs_src`: caminho do ponto de montagem remoto
   - `estacao_mnt_suporte`: **OPCIONAL**, ponto de montagem local
   - `estacao_ntp_servers`: **OPCIONAL**, lista de servidores NTP
   - `estacao_ad_fallback_ip`: **OPCIONAL**, lista de ips para fallback

6. <a name="ansible-install"></a>Garanta que ansible esteja instalado:

   ```shell
   pip install ansible
   ```

7. Aplique o _playbook_ :

   ```shell
   ansible-playbook -Kk playbook.yml --diff
   ```

   - `-k` : Requere a senha para sudo.
   - `-K` : Requere a senha para ssh.

8. Reinicie e faça login com seu usuário do domínio.

## Contribuindo

### Configurando seu ambiente de trabalho

1. Clone este repositório para sua máquina

   ```shell
   mkdir ~/workspace
   cd ~/workspace/
   git clone git@github.com:CMCuritiba/Estacao-Trabalho-CMC.git
   ```

2. Instale o ansible, molecule e vagrant:

   1. Instale o [ansible](#ansible-install)
   2. <a name="vagrant-install"></a>Instale o Vagrant de acordo com a [documentação oficial](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant#linux)
   3. Instale o molecule e seus plugins, de acordo com a [documentação oficial](https://ansible.readthedocs.io/projects/molecule/installation/):

      ```shell
      # Antes de instalar, crie e ative um virtualenv
      $ cd ~/workspace/
      $ python3 -m venv molecule
      $ source ~/workspace/molecule/bin/activate
      # Instale o molecule e os plugins
      (molecule) $ pip install molecule
      (molecule) $ pip install "molecule-plugins[vagrant]"
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

2. Utilize o arquivo [`all.yml.example`](./inventory/group_vars/all.yml.exemple)
   como exemplo para criar seu arquivo de configuração de acordo com o
   necessário

3. Teste o _converge_:

   ```shell
   cd ~/workspace/Estacao-Trabalho-CMC/roles/estacao/
   $ source ~/workspace/molecule/bin/activate
   (molecule) $ molecule converge -- --diff
   ```

4. Se for necessário testar apenas tasks específicas, é possível ser realizado com:

   ```shell
   (molecule) $ molecule converge -- --tags "<tag-desejada>" --diff
   ```

O molecule deve criar uma instância do Vagrant e testar o _role_ automaticamente.

Caso seja necessário realizar os testes manualmente sem utilizar o Molecule, é possível utilizar apenas o [Vagrant](https://www.vagrantup.com/) para os testes locais.

1. Instale o [VirtualBox](#virtualbox-install) e o [Vagrant](#vagrant-install), como descrito acima.
2. Utilize o [Vagrantfile](./Vagrantfile) na raiz do repositório para subir uma VM do Mint:

   ```shell
   vagrant up
   ```

3. Acesse a VM:

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
   ansible-playbook --diff playbook.yml -i inventory
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
