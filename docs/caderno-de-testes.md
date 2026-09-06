# Caderno de Testes - Estação de Trabalho CMC

Guia objetivo para validar a role `estacao` e corrigir os problemas mais comuns.

## Escopo

Este caderno cobre:

1. Validação funcional mínima da estação.
2. Validação de execução do playbook.
3. Troubleshooting para falhas recorrentes (AD/hostname, Molecule, Vagrant/VirtualBox e APT).

## Fluxo Rápido (recomendado)

1. Preparar variáveis em `inventory/group_vars/all.yml`.
2. Subir ambiente de teste (host local ou Vagrant).
3. Executar playbook completo.
4. Executar checklist de aceite.
5. Se falhar, usar a matriz de correção deste documento.

---

## 1) Preparação

### Regra obrigatória antes dos testes

- O arquivo `inventory/group_vars/all.yml` deve conter dados reais do ambiente.
- Não use valores de exemplo para domínio, IPs de AD e credenciais de join.
- Com valores fictícios, os testes de DNS/hostname/AD não são válidos e podem falhar.

### 1.1 Variáveis obrigatórias

Revise no `all.yml` pelo menos:

- `estacao_ad_domain`
- `estacao_ad_ip_addresses`
- `estacao_ad_fallback_ips`
- `estacao_dtic_group`
- `estacao_dtic_network`

### 1.2 Dependências de teste

```bash
# ambiente de desenvolvimento para testes locais
cd ~/workspace
python3 -m venv molecule
source ~/workspace/molecule/bin/activate
pip install molecule "molecule-plugins[vagrant]" ansible passlib
```

Se houver erro de permissão em `~/.ansible/tmp`:

```bash
export ANSIBLE_HOME=/tmp/.ansible
export ANSIBLE_LOCAL_TEMP=/tmp/ansible-local
export ANSIBLE_REMOTE_TEMP=/tmp/ansible-remote
mkdir -p /tmp/.ansible/tmp /tmp/ansible-local /tmp/ansible-remote
```

### 1.3 Bootstrap inicial do SSH

Se a máquina de destino ainda não tiver `openssh-server`, a primeira execução do
playbook remoto não poderá usar apenas `sshpass`. Antes do primeiro teste:

1. acesse a máquina localmente;
2. instale e habilite o SSH:

```bash
sudo apt install -y openssh-server
sudo systemctl enable --now ssh
```

3. valide o acesso remoto com um usuário local existente:

```bash
ssh oem@10.0.1.82
```

4. só depois execute o playbook por Ansible a partir da estação de trabalho.

Observação:
- `sshpass` automatiza a senha de uma conexão SSH já existente;
- ele não substitui a necessidade de `openssh-server` no primeiro acesso remoto.

---

## 2) Execução dos testes

### 2.1 Teste principal (obrigatório)

```bash
ansible-playbook -i inventory/inventory.yml playbook.yml --diff
```

Fluxo recomendado:

1. Na primeira execução, use um usuário local já existente na máquina de
   destino.
2. Garanta que o servidor SSH esteja instalado e ativo no host remoto.
3. Depois que a task `140-integra-ad.yml` rodar com sucesso e o acesso SSH com
   seu usuário do AD funcionar, passe a usar o seu próprio usuário de domínio.

Exemplo da preparação inicial:

```bash
sudo apt install -y openssh-server
sudo systemctl enable --now ssh
ssh oem@10.0.1.82
```

Se quiser registrar a execução completa em arquivo local mantendo as sequências
ANSI do terminal, use o comando abaixo já com o seu usuário do AD, após a etapa
de integração ao domínio:

```bash
script -qefc "ANSIBLE_FORCE_COLOR=1 PY_COLORS=1 ansible-playbook playbook.yml -i inventory/inventory.yml --diff -u tss2025 -k -K" ./LOG_ansible-playbook.typescript
```

Quando precisar de mais detalhes na investigação, adicione `-vvv` ao comando do
`ansible-playbook`. Para abrir o log preservando as cores:

```bash
less -R ./LOG_ansible-playbook.typescript
```

Antes da integração AD, substitua `tss2025` pelo usuário local inicial da
máquina de destino.

### 2.2 Teste parcial sem AD (quando necessário)

Use para validar o restante da role sem bloquear em integração de domínio:

```bash
ansible-playbook -i inventory/inventory.yml playbook.yml --diff --skip-tags ad,dns,boot
```

### 2.3 Teste com Molecule (quando aplicável)

```bash
cd roles/estacao
export ANSIBLE_ROLES_PATH="$PWD/.."
molecule test
```

### 2.4 Teste com Vagrant (manual)

```bash
cd vagrant
vagrant up
vagrant ssh
```

---

## 3) Checklist de aceite (mínimo para aprovação)

Marque OK apenas com evidência (saída de comando, print ou log):

- [ ] Playbook finaliza com `failed=0` e `unreachable=0`.
- [ ] `hostname -f` retorna FQDN contendo `estacao_ad_domain`.
- [ ] `realm list` mostra o domínio esperado (quando AD for exigido).
- [ ] `google-chrome --version` e `microsoft-edge --version` retornam versão.
- [ ] `dpkg -l | grep openssh-server` confirma SSH instalado.
- [ ] `ls -la /etc/dconf/db/local.d/01-cmc /etc/dconf/db/local.d/locks/01-cmc`.
- [ ] `systemctl status ssh` sem erro.
- [ ] `sudo apt update` sem erro de Release/GPG/arquitetura.
- [ ] Remote Desktop/VNC validado no modelo definido para o projeto.
- [ ] README atualizado quando houver mudança de fluxo.

---

## 4) Matriz de correção de problemas

## Erro: "Hostname não configurado, abortando"

- Causa comum: domínio/DNS incorretos nas variáveis.
- Como corrigir:

```bash
ansible-playbook -i inventory/inventory.yml playbook.yml --tags dns,boot,ad --diff
hostname -f
resolvectl status
realm list
```

---

## Erro no Molecule: `the role 'estacao' was not found`

- Causa comum: `ANSIBLE_ROLES_PATH` ausente.
- Como corrigir:

```bash
cd roles/estacao
export ANSIBLE_ROLES_PATH="$PWD/.."
molecule test
```

---

## Erro no Molecule/Ansible: permissão em `~/.ansible/tmp`

- Causa comum: ambiente com HOME restrito.
- Como corrigir:

```bash
export ANSIBLE_HOME=/tmp/.ansible
export ANSIBLE_LOCAL_TEMP=/tmp/ansible-local
export ANSIBLE_REMOTE_TEMP=/tmp/ansible-remote
mkdir -p /tmp/.ansible/tmp /tmp/ansible-local /tmp/ansible-remote
```

---

## Erro do Vagrant/VirtualBox: `NS_ERROR_SOCKET_FAIL`

- Causa comum: VirtualBox/serviço não inicializado.
- Como corrigir:

1. Abrir o VirtualBox manualmente.
2. Reiniciar serviço/host.
3. Rodar novamente:

```bash
cd vagrant
vagrant up
```

---

## `apt update` com erro de repositório/assinatura

- Sintomas comuns:
  - `NO_PUBKEY` (Spotify)
  - `Release file not found` (suite errada, ex.: HashiCorp em `wilma`)
  - aviso `binary-i386` (Serpro sem `arch=amd64`)
  - suites Wine duplicadas (`noble` + `questing`)

- Como corrigir (resumo):
  - alinhar suite com base Ubuntu correta (`noble` no Mint 22.x),
  - renovar chave GPG e usar `signed-by`,
  - restringir repositório third-party para `arch=amd64` quando apropriado,
  - remover suite indevida duplicada.

---

## 5) Evidências que devem ir para a issue/PR

Inclua no fechamento:

1. Recap final do playbook.
2. Saída dos comandos de AD/hostname (`hostname -f`, `realm list`).
3. Saída do `apt update`.
4. Versões dos apps principais (Chrome/Edge).
5. Resultado do Molecule (quando aplicado).
6. Pendências conhecidas e plano de correção.

---

## 6) Formulário de validação

- [ ] Usuários e grupos
- [ ] Pacotes principais
- [ ] DNS/AD/hostname
- [ ] dconf e interface
- [ ] Serviços (ssh, boot, timers)
- [ ] APT sem erros
- [ ] Remote desktop validado
- [ ] Evidências anexadas

Status da estação: [ ] Aprovada [ ] Reprovada

Data: ___________

Responsável: ___________
