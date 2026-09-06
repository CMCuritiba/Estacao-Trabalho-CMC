# PR: Scaffold da role estacao-windows

Issue relacionada: CMCuritiba/Estacao-Trabalho-CMC#160

## Resumo

Este PR cria o scaffold completo da role `estacao-windows` — equivalente Windows da
role `estacao` (Linux Mint) — para provisionamento de estações Windows 10/11 da CMC.

## Estrutura criada

- `roles/estacao-windows/` — role Ansible com 22 task files numerados sequencialmente
- `windows/bootstrap-winrm.ps1` — script PowerShell para habilitar WinRM antes do primeiro uso
- `vagrant/windows/Vagrantfile` — ambiente de teste local com Windows 10 (VirtualBox)
- `playbook-windows.yml` — playbook de produção (grupo `[windows]`)
- `playbook-windows-local.yml` — playbook para teste local sem vault
- `requirements.yml` — coleções `ansible.windows` 2.2.0 e `community.windows` 2.1.0
- `inventory/group_vars/windows.yml.example` — template de variáveis de conexão WinRM
- `docs/referencias-windows.md` — referências de documentação offline e online

## Decisões técnicas

| Decisão | Escolha | Motivação |
|---|---|---|
| Repositório | Mesmo repo (`roles/estacao-windows/`) | Inventário e variáveis compartilhados |
| Automação | Ansible + `ansible.windows` via WinRM | Consistência com a role Linux |
| Gerenciador de pacotes | winget | Nativo no Windows 10/11, sem bootstrap |
| OS alvo | Windows 10 22H2 + Windows 11 | Frota atual da DTIC |

## Status de implementação por fase

| Fase | Status | Tasks |
|---|---|---|
| 1 — Scaffold | Concluído | Toda a estrutura de arquivos |
| 2 — Core | Concluído | 010, 030, 120, 140, 160 (usuário, winget, DNS, AD, admins) |
| 3 — Configuração | Parcial | 060, 080, 090, 100 implementados; 040, 050 aguardam arquivos de imagem |
| 4 — Serviços | Parcial | 210 (RDP+SSH) implementado; 070, 170, 180, 250 estruturados |
| 5 — Hardening | Stub | 270, 290 estruturados; AppLocker pendente de validação de edição Windows |

## Como testar

```bash
# 1. Instalar coleções necessárias
ansible-galaxy collection install -r requirements.yml

# 2. Subir VM Windows 10
cd vagrant/windows
vagrant up

# 3. Reaplicar após alterações
vagrant provision

# 4. Validação manual via RDP
# localhost:33389 — vagrant / vagrant
```

## Próximos PRs sugeridos

- `feat/windows-imagens` — adicionar wallpaper e lockscreen (task 040)
- `feat/windows-skel` — atalhos de desktop no perfil padrão (task 050)
- `feat/windows-autostart` — tarefas agendadas de boot (task 070)
- `feat/windows-applocker` — controle de aplicativos via AppLocker (task 270)
