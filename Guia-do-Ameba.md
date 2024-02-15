# Preparo da estacao de trabalho - Ansible

## Instalação de pacotes necessários e recomendados

1. Ansible:

   ```shell
   sudo apt install python3 python3-venv pip git
   python3 -m pip install --user ansible ansible-lint
   ```

2. Visual Studio Code

   ```shell
   wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O /tmp/vscode.deb
   sudo dpkg -i --force-depends /tmp/vscode.deb
   ```

3. Docker:

   ```shell
   sudo apt install docker.io
   sudo adduser [seu usuario] docker
   ```

   Reinicie o linux, logue novamente e teste o docker com o comando: `docker container ls`

4. VirtualBox:

   ```shell
   sudo apt install virtualbox virtualbox-dkms virtualbox-ext-pack virtualbox-qt
   ```

## Inicialização do ambiente de desenvolvimento

Na sua estação de trabalho, com seu usuário (**não use root**), siga os comandos
a seguir:

1. Opcionalmente, crie uma pasta para seu workspace

   ```shell
   mkdir ~/workspace
   cd ~/workspace
   ```

2. Gere uma chave para uso no github:

   ```shell
   # informe uma senha para a chave a ser criada no comando a seguir:
   ssh-keygen -t rsa -b 2048
   # para exibir a chave gerada:
   cat ~/.ssh/id_rsa.pub
   ```

3. abrir o github e fazer login
4. acessar settings > SSH and GPG keys > New SSH key
5. escolher um título para a chave e depois colar o conteúdo copiado
   anteriormente em Key

Voltando para o terminal do linux:

1. Inicie o repo local:

   ```shell
   git clone git@github.com:CMCuritiba/Estacao-Trabalho-CMC.git
   ```

2. Abra o repo no VSCode: `code ~/workspace/Estacao-Trabalho-CMC`
3. Crie e inicialize o _virtual env_ para o molecule:

   ```shell
   python3 -m venv ~/workspace/molecule
   source ~/workspace/molecule/bin/activate
   ```

4. Já no _virtual env_, instale o molecule:
   1. `pip install molecule`
   2. `pip install "molecule-docker"`
5. A partir daqui, você já pode trabalhar no código e realizar testes com o
   molecule;
6. **Atenção, este etapa é opcional.** Se as pastas `roles/estacao` já tiverem
   sido criadas, você pode pular esta etapa. Caso contrário, no início do
   desenvolvimento ou para [criar uma nova role](https://galaxy.ansible.com/docs/contributing/creating_role.html),
   na pasta raiz do repositório, faça:

   ```shell
   mkdir roles
   cd roles/
   ansible-galaxy role init estacao
   molecule init scenario -d vagrant
   cd estacao/
   ```

   Observação: comandos validados com o molecule versão 6.
7. Para testar o código (já criando a VM se ela não existir), use os comandos:

   ```shell
   molecule converge
   molecule verify
   ```

8. Para limpar o ambiente de teste (exclui a VM):

   ```shell
   molecule destroy
   ```

## Para usar sua estacao de trabalho

Abra o VSCode, no canto inferior esquerdo escolha a branch

No canto superior esquerdo selecione "Extensions" e procure por Ansible. Instale
a [publicada e verificada por **redhat.com**](https://marketplace.visualstudio.com/items?itemName=redhat.ansible).

Veja os arquivos em Explorer no canto superior esquerdo

## Usando o molecule

**TODO**: Adicionar comandos úteis aqui

## Instalando o vagrant

1. Instale o vagrant de acordo com a [documentação oficial](https://developer.hashicorp.com/vagrant/downloads):

   ```shell
   wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com jammy main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install vagrant
   ```

   obs: caso aconteça algum erro durante a instalação, altere a versao do repositorio do comando conforme a versao base do seu ubuntu.

2. Inicie o virtualenv do molecule:
   `source ~/workspace/molecule/bin/activate`
3. Instale o [plugin vagrant](https://github.com/ansible-community/molecule-plugins):

   ```shell
   pip install "molecule-plugins[vagrant]"
   pip install python-vagrant
   ```

4. Com o ambiente configurado, a role pode ser criada. **Atenção**: a role
   precisa ser criada apenas uma vez:

   ```shell
   molecule init role --driver-name vagrant cmcuritiba.estacao
   ```

5. Agora as tasks já podem ser testadas com o molecule:

   ```shell
   molecule converge
   # ou
   molecule check
   ```
