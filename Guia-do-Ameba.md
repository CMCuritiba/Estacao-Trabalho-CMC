# Preparo da estacao de trabalho - Ansible

sudo apt install python3 pip git
python3 -m pip install --user ansible

## Com seu usuário:
mkdir ~/workspace
cd ~/workspace
ssh-keygen [enter] [enter] [enter]
cat ~/.ssh/id_rsa.pub {copiar todo o conteúdo desse arquivo}

1. abrir o github e fazer login
2. acessar settings > SSH and GPG keys > New SSH key
3. escolher um título para a chave e depois colar o conteúdo copiado anteriormente em Key

## Voltando para o terminal do linux:
1. git clone git@github.com:CMCuritiba/Estacao-Trabalho-CMC.git
2. wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O /tmp/vscode.deb
3. sudo dpkg -i --force-depends /tmp/vscode.deb
4. code ~/workspace/Estacao-Trabalho-CMC
5. sudo apt install docker.io
6. sudo adduser [seu usuario] docker
7. python3 -m pip install --user ansible ansible-lint
8. sudo apt install python3-venv
9. python3 -m venv molecule
10. source ~/workspace/molecule/bin/activate
11. pip install molecule
12. pip install "molecule-docker" 
13. mkdir roles
14. cd roles/
15. molecule init role -d docker cmcuritiba.estacao
16. cd estacao/
17. mv molecule/ /home/breno/workspace/

# Para usar sua estacao de trabalho:
Abra o VSCode, no canto inferior esquerdo escolha a branch
No canto superior esquerdo selecione "Extensions" e procure por Ansible. Instale a primeira recomendacao.
Veja os arquivos em Explorer no canto superior esquerdo

No terminal do VSCode, para utilizar o molecule use:
source ~/workspace/molecule/bin/activate

# Instalando o vagrant
1. wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
2. echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
3. sudo apt update && sudo apt install vagrant
4. #link: https://developer.hashicorp.com/vagrant/downloads

5. python3 -m pip install --user python-vagrant molecule-vagrant
6. molecule init scenario --role-name estacao --driver-name vagrant vagrant
7. molecule check -s vagrant

# Alterar o arquivo > roles/estacao/vagrant/molecule.yml:
---
dependency:
  name: galaxy
driver:
  name: vagrant
  provider:
    name: virtualbox
platforms:
  - name: estacao
    box: aaronvonawesome/linux-mint-21-cinnamon
    #   instance_raw_config_args:
    #   - "vm.network 'forwarded_port', guest: 80, host: 8088"
provisioner:
  name: ansible
  lint:
    name: ansible-lint
verifier:
  name: ansible

#alterar o arquivo > roles/estacao/vagrant/molecule.yml:
---
dependency:
  name: galaxy
driver:
  name: vagrant
  provider:
    name: virtualbox
platforms:
  - name: estacao
    box: aaronvonawesome/linux-mint-21-cinnamon
    #   instance_raw_config_args:
    #   - "vm.network 'forwarded_port', guest: 80, host: 8088"
provisioner:
  name: ansible
  lint:
    name: ansible-lint
verifier:
  name: ansible
