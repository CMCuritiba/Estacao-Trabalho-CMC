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

   Encerre a sessão no linux e logue novamente.

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

2. code ~/workspace/Estacao-Trabalho-CMC
3. Crie e inicialize o _virtual env_ para o molecule:

   ```shell
   python3 -m venv ~/workspace/molecule
   source ~/workspace/molecule/bin/activate
   ```

4. Já no _virtual env_:
   1. pip install molecule
   2. pip install "molecule-docker"
   3. mkdir roles
   4. cd roles/
   5. molecule init role -d docker cmcuritiba.estacao
   6. cd estacao/

## Para usar sua estacao de trabalho

Abra o VSCode, no canto inferior esquerdo escolha a branch

No canto superior esquerdo selecione "Extensions" e procure por Ansible. Instale
a [publicada e verificada por **redhat.com**](https://marketplace.visualstudio.com/items?itemName=redhat.ansible).

Veja os arquivos em Explorer no canto superior esquerdo

No terminal do VSCode, para utilizar o molecule use:

```shell
source ~/workspace/molecule/bin/activate
```

## Usando o molecule

**TODO**: Adicionar comandos úteis aqui

## Instalando o vagrant

1. wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
2. echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
3. sudo apt update && sudo apt install vagrant
4. link: https://developer.hashicorp.com/vagrant/downloads

5. python3 -m pip install --user python-vagrant molecule-vagrant
6. molecule init scenario --role-name estacao --driver-name vagrant vagrant
7. molecule check -s vagrant
