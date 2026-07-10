# PR: Migração Vino → GNOME Remote Desktop, verificação de swap e hardening

## Resumo

Este PR agrupa mudanças na role `roles/estacao` para:

- migrar a configuração de VNC/RDP de `vino` para `gnome-remote-desktop` (compatível com Linux Mint 22.2);
- adicionar uma task Ansible idempotente para verificação/criação de swap (suporte a hibernação);
- hardenizar ordem e criação de artefatos para permitir execução parcial de tasks sem falhas (producer → consumer).

## Principais arquivos modificados / adicionados

- `roles/estacao/defaults/main.yml`

  Adicionadas variáveis para swap/hibernação: `estacao_swap_enable`, `estacao_swap_ensure`, `estacao_swap_size`, `estacao_swap_min_margin`, `estacao_swapfile_path`.

- `roles/estacao/tasks/125-check-swap.yml` (novo)

  Task Ansible idempotente que checa RAM/swap, calcula swap recomendado e opcionalmente cria/ativa um swapfile e registra em `/etc/fstab` quando solicitado.

- `roles/estacao/tasks/999-hibernacao.yml`

  Substituído o wrapper antigo que executava o script shell por um import para `125-check-swap.yml`, mantendo compatibilidade de variáveis (`ensure_size`, `min_margin`).

- `roles/estacao/tasks/main.yml`

  Import estático adicionado para `125-check-swap.yml` (condicional por `estacao_swap_enable`) posicionado antes do bloco de boot.

- `roles/estacao/templates/dconf-cmc-config.j2`

  Template dconf atualizado para incluir seções compatíveis com diferentes schemas de Remote Desktop (`remote-access`, `remote-desktop`, `org.gnome.remote-desktop`).

- `roles/estacao/tasks/100-dconf.yml`

  Reorganizado/limpo; locks dconf agora incluem caminhos alternativos para compatibilidade com Mint/Ubuntu/GNOME.

  Comentários históricos adicionados explicando que antes as chaves eram relacionadas ao `vino`.

- `roles/estacao/tasks/220-vnc.yml`

  Comentário histórico do que fazia o Vino e agora garante que o pacote `gnome-remote-desktop` esteja instalado (idempotente).

- `roles/estacao/vars/main.yml`

  Variável de caminho renomeada/clarificada: `estacao_remote_desktop` (comentário preservando `estacao_vino`).

- `roles/estacao/tasks/060-configura-browsers.yml`

  Criação de `/etc/firefox/policies` antes de escrever `policies.json` para evitar erro quando a task rodar isoladamente.

- `roles/estacao/tasks/070-autostart.yml` e `roles/estacao/tasks/080-politica-informatica.yml`

  Ordem e comentários ajustados para garantir que `forcelogout.sh` (produtor) exista antes do `.desktop` (consumidor). Também adicionamos referências no README de tasks para orientar testes.

- `roles/estacao/tasks/999-arquivos-modificados.yml`

  Atualizado para refletir remoção/alteração do link ao autostart do `vino`; adicionado comentário histórico.

- `roles/estacao/ESTACAO-tasks-dependencies.md` (novo)

  Documento gerado com mapa de dependências, diagrama mermaid e ordem segura recomendada para testes parciais.

## Motivação

- `vino` estava obsoleto/inadequado para Mint 22.2; `gnome-remote-desktop` é a implementação atual do GNOME para RDP/VNC e deve ser usada.

- A verificação/garantia de swap via Ansible permite habilitar hibernação de forma controlada (idempotente e audível nos logs do playbook).

- Reordenação e hardening evitam falhas quando executamos tasks individualmente (ex.: template que grava arquivo referenciando imagens/políticas que ainda não existem).

## Testes e validação rápida

1. Testar swap (modo manual): rodar a task `125-check-swap.yml` com `estacao_swap_ensure: true` em uma VM de teste e confirmar `/proc/swaps` e `/etc/fstab`.

2. Testar dconf: executar `roles/estacao/tasks/100-dconf.yml` em uma sessão X (ou com dbus-launch/su) e validar chaves com `dconf read` e a existência de arquivos em `/etc/dconf/db/local.d/` e `/etc/dconf/db/local.d/locks`.

3. Testar browser policies: executar `060-configura-browsers.yml` e confirmar que `/etc/firefox/policies/policies.json` existe e é um JSON válido.

4. Testar autostart: executar `080-politica-informatica.yml` + `070-autostart.yml` e confirmar que `forcelogout.sh` existe antes do `.desktop`.

## Observações e próximos passos

- Remoção do arquivo legado `files/vino-server.desktop` está pendente; mantenho como histórico - aguardo confirmação para exclusão.

- Sugestão: adicionar testes Molecule rápidos para as tasks de swap e dconf para evitar regressões.

- Opcional: automatizar verificação/ajuste do parâmetro `resume=` no kernel cmdline e regenerar initramfs quando hibernação for requerida (mudança invasiva que exige reboot).

## Resumo de verificação de qualidade

- Build: N/A (role Ansible, sem build)

- Lint YAML: verificado localmente após várias correções de indentação.

- Tests: manuais descritos acima. Recomenda-se integrar Molecule.

-- fim
