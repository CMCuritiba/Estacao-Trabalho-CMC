## Critérios de aceite para fechar a issue "Atualizar para Mint 22"

1. Molecule em Mint 22
- Critério: cenário default sobe e converge em box Mint 22.
- Evidência: `molecule test` sem erro.
- Comando: `cd roles/estacao && molecule test`

2. Playbook completo em VM limpa
- Critério: execução completa do playbook sem failed.
- Evidência: recap final com `failed=0`.
- Comando: `ansible-playbook -i inventory/inventory.yml playbook.yml --diff`

3. Aplicativos principais instalados
- Critério: Chrome, Edge, PDFSam, VLC, GIMP, Inkscape e SSH presentes.
- Evidência: versões/comandos retornam sucesso.
- Comandos:
```bash
google-chrome --version
microsoft-edge --version
pdfsam --version
vlc --version
gimp --version
inkscape --version
systemctl status ssh
```

4. dconf aplicado
- Critério: arquivos e locks existem + `dconf update` sem erro.
- Evidência: arquivos em `/etc/dconf/...` e leitura de chaves esperadas.
- Comandos:
```bash
ls -la /etc/dconf/db/local.d/01-cmc /etc/dconf/db/local.d/locks/01-cmc
sudo dconf update
```

5. Remote Desktop/VNC no Mint 22
- Critério: configuração ativa e serviço funcional no modelo atual da role.
- Evidência: arquivos/serviços esperados presentes e conexão de teste bem-sucedida.

6. Drivers de vídeo
- Critério: pacote de driver definido pela role instalado e sistema funcional após reboot.
- Evidência: pacote instalado e sem erro de sessão gráfica.
- Comando: `dpkg -l | grep linux-oem-24.04`

7. Assinador Serpro (aplicativo externo)
- Critério: instalação abre e assina com token em teste real.
- Evidência: teste funcional documentado (passo a passo + resultado).
- Observação: incluir ajuste de repositório para evitar aviso de `i386`.

8. Saúde do APT
- Critério: `apt update` sem erro de Release, sem NO_PUBKEY, sem warning de arquitetura indevida.
- Evidência: saída limpa.
- Comando: `sudo apt update`

9. Documentação atualizada
- Critério: README e caderno de testes refletem Mint 22 e fluxo atual.
- Evidência: links/comandos válidos e sem passos obsoletos.

## Levantamento oficial Mint 21.3 -> 22.3

1. Mint 21.3 (Virginia)
- Base: Ubuntu 22.04.
- Destaques oficiais: Cinnamon 6.0 e sessão Wayland experimental.
- Impacto de verificação: validar compatibilidade de políticas dconf em X11/Wayland e comportamento de applets.

2. Mint 22 (Wilma)
- Base: Ubuntu 24.04.
- Release notes destacam transição para base nova e riscos com kernels HWE/OEM + NVIDIA proprietário.
- Impacto de verificação: validar kernel/driver de vídeo e estabilidade gráfica após reboot.

3. Mint 22.1 (Xia)
- Base: Ubuntu 24.04, kernel 6.8, Cinnamon 6.4.
- Destaques oficiais: Night Light no Cinnamon, integração com `powerprofilesctl`, melhorias de touchpad e tema/accent color (incluindo apps libAdwaita).
- Impacto de verificação: validar perfis de energia, applet de energia e consistência visual/políticas.

4. Mint 22.2 (Zara)
- Base: Ubuntu 24.04, kernel 6.8, Cinnamon 6.4.
- Destaques oficiais: autenticação por impressão digital em apps que usam `pkexec`, melhorias em libAdwaita/XDG desktop portal.
- Impacto de verificação: validar fluxo de autenticação local e confirmar ausência de regressão em apps com `pkexec`.

5. Mint 22.3 (Zena)
- Base: Ubuntu 24.04, kernel 6.8, Cinnamon 6.4.
- Destaques oficiais: manutenção interna de componentes como aptkit/captain e melhorias de XApps.
- Impacto de verificação: validar operações de APT no desktop e smoke test dos apps padrão.

## Levantamento de impacto nas tasks da role estacao

1. Pacotes e base do sistema
- Task: `030-instala-programas.yml`.
- Cobertura atual: instala pacotes principais e `linux-oem-24.04`.
- Gap: role ainda referencia `vino`; no Mint 22.x a trilha recomendada é GNOME Remote Desktop.

2. dconf e desktop
- Task: `100-dconf.yml`.
- Cobertura atual: aplica perfil/locks e executa `dconf update`.
- Gap: locks e chaves de Remote Desktop precisam ser validados contra schemas efetivos do Mint 22.x.

3. VNC/Remote Desktop
- Task: `220-vnc.yml`.
- Cobertura atual: autostart de `vino-server.desktop`.
- Gap crítico: checar aderência ao stack atual do Mint 22.x (RDP/VNC do GNOME Remote Desktop).

4. Segurança e autenticação
- Tasks relacionadas: `110-terminal-policy.yml`, `150-configura-pam.yml`, `160-sudoers.yml`.
- Cobertura atual: política de elevação e PAM/sudoers.
- Gap: validação explícita para cenário biométrico/`pkexec` do Mint 22.2+.

5. Saúde de repositórios
- Tasks relacionadas: `030-instala-programas.yml`, `170-unattended-upgrades.yml`.
- Cobertura atual: update/upgrade e unattended-upgrades.
- Gap: não há hardening explícito de `signed-by`/arquitetura para repositórios de terceiros.

## Passos adicionais de verificação recomendados

1. Remote Desktop real em Mint 22.x
- Validar conexão remota funcional após aplicar tags `dconf,vnc`.

2. Cenários gráficos sensíveis
- Testar login gráfico com 1 e 2 monitores, escala fracionada e reboot.

3. Energia e dispositivos
- Validar `powerprofilesctl`, Night Light e touchpad.

4. Assinador Serpro e token
- Teste funcional ponta a ponta (abrir, autenticar, assinar).

5. APT de terceiros
- Garantir `sudo apt update` sem erros de Release/GPG/arquitetura.

## Avaliação da suficiência do README

Veredito: parcialmente suficiente.

1. O README cobre instalação, inventário e fluxo básico de execução/teste.
2. Não cobre um roteiro de validação específico para a migração 21.3 -> 22.3.
3. Não lista checks para pontos críticos de 22.x: Remote Desktop atual, `powerprofilesctl`, biometria/`pkexec`, multi-monitor/escala e repositórios externos.
4. É recomendável adicionar uma seção "Validação Mint 22.x" com checklist de aceite e evidências.

## Definição de pronto (DoD)

Fechar a issue apenas quando os 9 critérios acima estiverem marcados como OK com evidência (comando + saída resumida ou screenshot).

## Resultado da validação (2026-03-05)

Status geral: issue ainda não pode ser considerada concluída.

1. Molecule em Mint 22: BLOQUEADO
- Resultado: `molecule` não está instalado no ambiente atual (`command not found`).

2. Playbook completo em VM limpa: NÃO ATENDIDO (nesta execução)
- Resultado: `ansible-playbook` executou, porém host `vagrant` inacessível.
- Evidência: `UNREACHABLE! ... ssh: connect to host 127.0.0.1 port 2222: Connection refused`.

3. Aplicativos principais instalados: PARCIAL
- OK: Chrome, Edge, VLC, GIMP, Inkscape e pacote `openssh-server` presentes.
- Pendente/atenção: execução `pdfsam --version` falha sem DISPLAY e o pacote instalado é `pdfsam` (não `pdfsam-basic`).

4. dconf aplicado: PARCIAL
- OK: arquivos `/etc/dconf/db/local.d/01-cmc` e `locks/01-cmc` existem.
- Pendente: `dconf update` sem privilégios falha com `Permission denied`.

5. Remote Desktop/VNC no Mint 22: NÃO ATENDIDO (gap funcional)
- Resultado: stack atual ainda usa `vino` (`vino-server.desktop` presente) e não `org.gnome-remote-desktop.desktop`.

6. Drivers de vídeo: NÃO ATENDIDO
- Resultado: encontrado `linux-oem-22.04` (transitional), não evidência de `linux-oem-24.04` instalado.

7. Assinador Serpro (externo): NÃO VALIDADO
- Resultado: sem teste funcional ponta a ponta com token nesta rodada.

8. Saúde do APT: NÃO ATENDIDO / NÃO VALIDADO COMPLETAMENTE
- Não foi possível executar `sudo apt update` neste ambiente.
- Evidências de configuração ainda inconsistente:
  - Spotify sem `signed-by` em `spotify.list`.
  - Chave Spotify em `/etc/apt/keyrings/spotify.gpg` expirada em 2026-02-06.
  - Repositório Serpro sem restrição `arch=amd64`.
  - `winehq-questing.sources` coexistindo com `winehq-noble.sources`.

9. Documentação atualizada: PARCIAL
- README melhorou, mas ainda há trecho obsoleto:
  - `sed -i 's/et1/localhost/g' playbook.yml` ainda presente.
  - O playbook atual usa `hosts: vagrant`.

## Pendências objetivas para fechamento

1. Subir VM (`vagrant up`) e repetir `ansible-playbook` até `failed=0` e `unreachable=0`.
2. Instalar/rodar `molecule test` no cenário default.
3. Decidir e alinhar definitivamente VNC/RDP para Mint 22.x (Vino vs GNOME Remote Desktop) em código + docs.
4. Corrigir saúde do APT (Spotify key + signed-by, Serpro arch, Wine suite).
5. Executar validação funcional do Assinador Serpro com token.
6. Corrigir trecho obsoleto do README e registrar evidências finais no PR/issue.

## Referências

- Linux Mint 21.3 "Virginia" - Release notes:
  https://www.linuxmint.com/rel_virginia.php
- Linux Mint 21.3 "Virginia" - What's new:
  https://www.linuxmint.com/rel_virginia_whatsnew.php
- Linux Mint 22 "Wilma" - Release notes:
  https://linuxmint.com/rel_wilma.php
- Linux Mint 22.1 "Xia" - What's new:
  https://www.linuxmint.com/rel_xia_whatsnew.php
- Linux Mint 22.2 "Zara" - Release notes:
  https://linuxmint.com/rel_zara.php
- Linux Mint 22.2 "Zara" - What's new:
  https://www.linuxmint.com/rel_zara_whatsnew.php
- Linux Mint 22.3 "Zena" - Release notes:
  https://linuxmint.com/rel_zena.php
- Linux Mint 22.3 "Zena" - What's new:
  https://www.linuxmint.com/rel_zena_whatsnew.php
- Linux Mint Blog (arquivo Jan/2025):
  https://blog.linuxmint.com/?m=202501
