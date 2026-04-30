# Guia de Testes - Estação de Trabalho CMC

Este arquivo define o fluxo oficial de testes do projeto.

## Objetivo

Padronizar como validar mudanças na role `estacao` antes de aplicar em produção.

## Documentos de apoio

1. `README.md`: setup do ambiente e troubleshooting.
2. `caderno-de-testes.md`: checklist operacional e correção de falhas.
3. `roles/estacao/ESTACAO-tasks-dependencies.md`: dependências entre tasks.

## Regras obrigatórias

1. Preencher `inventory/group_vars/all.yml` com dados reais do ambiente.
2. Não usar valores de exemplo para AD (domínio, IPs, credenciais de join).
3. Não commitar credenciais sensíveis no repositório.

## Estratégia de testes

O processo tem 2 níveis:

1. Testes automatizados (Molecule): validam rapidamente role/cenário.
2. Testes de validação (Ansible + checklist): validam comportamento real.

## Pré-requisitos mínimos

1. Python 3.
2. Ansible.
3. Para Molecule: Vagrant + VirtualBox + plugin vagrant.
4. Para aplicação remota do playbook: acesso SSH já funcional ao host de
   destino.

Exemplo de instalação local:

```bash
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

## Bootstrap inicial do SSH

Se a instalação base do Linux Mint não vier com `openssh-server`, o primeiro
acesso remoto não poderá ser feito apenas com `sshpass`. Nesse caso:

1. Acesse a máquina de destino localmente.
2. Instale e habilite o SSH:

```bash
sudo apt install -y openssh-server
sudo systemctl enable --now ssh
```

3. Valide o acesso remoto com um usuário local existente:

```bash
ssh oem@10.0.1.82
```

4. Depois disso, execute o playbook remoto via Ansible.

Observação:
- `sshpass` só automatiza senha de uma conexão SSH já disponível;
- ele não resolve o bootstrap inicial quando o `openssh-server` ainda não está
  instalado no host remoto.

## Fluxo recomendado (ordem)

1. Validar sintaxe e cenário Molecule.
2. Executar playbook completo no alvo de teste.
3. Executar checklist de aceite do `caderno-de-testes.md`.
4. Registrar evidências no PR/issue.

## Comandos principais

### Molecule

```bash
cd roles/estacao
export ANSIBLE_ROLES_PATH="$PWD/.."
molecule test
```

### Playbook completo

```bash
ansible-playbook -i inventory/inventory.yml playbook.yml --diff
```

Fluxo recomendado:

1. Na primeira execução, conecte com um usuário local já existente na máquina de
   destino e garanta que o `openssh-server` esteja instalado e ativo.
2. Depois que a task `140-integra-ad.yml` for aplicada com sucesso e o SSH com
   seu usuário do AD estiver funcional, passe a executar o playbook com o seu
   próprio usuário de domínio.

Exemplo de preparação inicial no destino:

```bash
sudo apt install -y openssh-server
sudo systemctl enable --now ssh
ssh oem@10.0.1.82
```

Para salvar a execução em arquivo local com a saída ANSI preservada, já usando o
seu usuário do AD após a integração:

```bash
script -qefc "ANSIBLE_FORCE_COLOR=1 PY_COLORS=1 ansible-playbook playbook.yml -i inventory/inventory.yml --diff -u tss2025 -k -K" ./LOG_ansible-playbook.typescript
```

Se precisar de mais detalhes para troubleshooting, adicione `-vvv` ao
`ansible-playbook`. Para visualizar o log:

```bash
less -R ./LOG_ansible-playbook.typescript
```

Antes da integração AD, substitua `tss2025` pelo usuário local inicial da
máquina de destino.

### Playbook parcial sem AD (laboratório)

```bash
ansible-playbook -i inventory/inventory.yml playbook.yml --diff --skip-tags ad,dns,boot
```

### Bloco AD somente

```bash
ansible-playbook -i inventory/inventory.yml playbook.yml --tags dns,boot,ad --diff
```

## Critérios mínimos de aprovação

1. Playbook finaliza com `failed=0` e `unreachable=0`.
2. `hostname -f` coerente com `estacao_ad_domain` (quando AD aplicável).
3. `realm list` válido (quando AD aplicável).
4. `sudo apt update` sem erro de Release/GPG/arquitetura.
5. Apps e serviços essenciais validados (Chrome, Edge, SSH, dconf).
6. Evidências anexadas na issue/PR.

## Falhas comuns e ação rápida

1. `Hostname não configurado, abortando`
- revisar `estacao_ad_domain`, `estacao_ad_ip_addresses`, DNS reverso e `hostname -f`.

2. Molecule não encontra role `estacao`
- executar dentro de `roles/estacao` com `ANSIBLE_ROLES_PATH="$PWD/.."`.

3. Erro de permissão em `~/.ansible/tmp`
- usar `ANSIBLE_HOME` e temporários em `/tmp`.

4. Erros de APT (NO_PUBKEY, Release file, i386)
- corrigir repositórios de terceiros (suite correta, signed-by, arquitetura).

## Evidências obrigatórias para fechamento

1. Recap do playbook.
2. Saída de `hostname -f`, `realm list`, `resolvectl status` (quando AD).
3. Saída de `sudo apt update`.
4. Resultado do Molecule (quando aplicável).
5. Pendências conhecidas e plano de correção (se houver).
