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

1. Instalar o Mint normalmente;
   - Crie a conta padrão `suporte`.
2. É recomendado realizar a atualização do sistema operacional antes de configurar a ET;
3. Faça login com o usuário criado;
4. Baixe o _codigo_ do [repositório](https://github.com/CMCuritiba/Estacao-Trabalho-CMC).
5. Altere o valor das variáveis presentes em group_vars/all.yml, utilizando os já presentes como base. As variáveis são:

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
   - `estacao_nfs_serv`: servidor nfs

6. <a name="ansible-install"></a>Garanta que ansible esteja instalado:

   - `pip install ansible`

7. Aplique o _playbook_ :

      ```shell
      ansible-playbook -Kk playbook.yml --diff
      ```

      - `-k` : senha para sudo
      - `-K` : senha para ssh

8. Reinicie e faça login com seu usuário do domínio.

## Contribuindo

### Configurando seu ambiente de trabalho

1. Clone este repositório para sua máquina
2. Instale o ansible, molecule e vagrant:

   1. Instale o [ansible](#ansible-install)
   2. <a name="vagrant-install"></a>Instale o Vagrant de acordo com a [documentação oficial](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant#linux)
   3. Instale o molecule e seus plugins, conforme a seguir ou de acordo com a [documentação oficial](https://ansible.readthedocs.io/projects/molecule/installation/):

      ```shell
      pip install molecule
      pip install "molecule-plugins[vagrant]"
      pip install python-vagrant
      ```

3. Opcionalmente, ative o [commitlint](https://github.com/conventional-changelog/commitlint) e
   o [commitzen](https://github.com/commitizen/cz-cli) no repositório:

   1. Instale o [`yarn`](https://classic.yarnpkg.com/lang/en/docs/install/) e o
      [`node`](https://nodejs.org/en/download);
   2. Na pasta do repositório, rode:

      ```shell
      yarn
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

2. Edite o arquivo group_vars/all.yml de acordo com o necessário

3. Dentro de roles/estacao execute:

   ```shell
   molecule converge -- --diff
   ```

4. Se for necessário testar apenas tasks específicas, é possível ser realizado com:

   ```shell
   molecule converge -- --tags "<tag-desejada>" --diff
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
   nano group_vars/all.yml
   sed -i 's/et1/localhost/g' playbook.yml
   ansible-playbook --diff playbook.yml
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
