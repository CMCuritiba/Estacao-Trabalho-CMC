# Caderno de Testes - Estação de Trabalho CMC

Este documento contém todos os testes necessários para validar a configuração correta da estação de trabalho CMC após a instalação/atualização.

## Como usar este caderno

1. Execute cada teste na ordem apresentada
2. Marque como ✅ os testes que passaram
3. Marque como ❌ os testes que falharam e investigue o problema
4. Para testes automáticos, use o comando `molecule verify` na pasta `roles/estacao/`

## Testes Automatizados com Molecule

Para facilitar a validação, alguns testes podem ser executados automaticamente usando o Molecule:

```bash
cd roles/estacao/
molecule verify
```

### Testes automatizados disponíveis:
- **001-002**: Verificação de usuário suporte e grupos
- **004**: Verificação de programas removidos  
- **005**: Verificação de repositórios brasileiros
- **006**: Verificação de programas essenciais instalados
- **007**: Verificação de instalação do Google Chrome
- **009**: Verificação de imagens CMC
- **011**: Verificação de diretórios skel
- **013**: Verificação de políticas do Chrome
- **019**: Verificação de TTY desabilitados
- **022**: Verificação de políticas do terminal
- **023**: Verificação de configuração DNS
- **025-026**: Verificação de script e serviço de boot
- **028-029**: Verificação de pacotes e configuração AD
- **034**: Verificação de configuração sudoers
- **036**: Verificação de unattended-upgrades
- **040-041**: Verificação de S3FS e mount point
- **045-046**: Verificação de SSH server
- **057**: Verificação de CUPS
- **066**: Verificação de script on-login
- **072**: Verificação de arquivo de versão
- **073**: Verificação de diretório de arquivos modificados

> **Nota**: Os testes automatizados cobrem validações que podem ser verificadas programaticamente. Testes que requerem interação do usuário, verificação visual ou testes de funcionalidade devem ser executados manualmente seguindo as instruções abaixo.

## Testes Manuais

### Categoria: Usuários e Grupos (010-user-group-suporte.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 001 | Criação do usuário suporte | Testar login na estação com o usuário suporte usando a senha configurada |
| 002 | Grupo do usuário suporte | Verificar se o usuário suporte está nos grupos corretos<br>No terminal: `id suporte`<br>Deve mostrar grupos: suporte, sudo |
| 003 | Senha de root | Testar login com root com a senha configurada<br>No terminal: `su -`<br>Inserir a senha de root configurada |

### Categoria: Remoção de Programas (020-remover-programas.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 004 | Programas removidos | Verificar se programas desnecessários foram removidos<br>Comando: `dpkg -l | grep -E "(hexchat|thunderbird|hypnotix|drawing|celluloid|pix|webapp-manager|warpinator|sticky|simple-scan|transmission)"`<br>Não deve retornar nenhum resultado |

### Categoria: Instalação de Programas (030-instala-programas.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 005 | Repositórios brasileiros | Verificar se repositórios estão configurados para Brasil<br>Comando: `grep "br.archive.ubuntu.com" /etc/apt/sources.list.d/official-package-repositories.list`<br>Comando: `grep "mint-packages.c3sl.ufpr.br" /etc/apt/sources.list.d/official-package-repositories.list` |
| 006 | Programas essenciais instalados | Verificar instalação de programas essenciais<br>Comando: `dpkg -l | grep -E "(curl|vim|git|htop|tree|unzip|wget|ssh)"`<br>Todos devem estar instalados |
| 007 | Google Chrome instalado | Verificar se Google Chrome está instalado<br>Comando: `google-chrome --version`<br>Deve retornar a versão instalada |
| 008 | Zoom instalado | Verificar se Zoom está instalado<br>Comando: `zoom --version` ou verificar em `/opt/zoom/` |

### Categoria: Imagens CMC (040-imagens-cmc.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 009 | Imagens de fundo CMC | Verificar se imagens estão na pasta correta<br>Comando: `ls -la /usr/share/backgrounds/cmc/`<br>Deve conter arquivos de imagem |
| 010 | Papel de parede configurado | Verificar se papel de parede padrão está definido<br>Verificar nas configurações do sistema ou dconf |

### Categoria: Configuração Skel (050-skel.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 011 | Diretórios skel criados | Verificar estrutura de diretórios em /etc/skel<br>Comando: `ls -la /etc/skel/`<br>Verificar se contém Desktop, Documents, etc. |
| 012 | Configurações padrão skel | Testar criando um novo usuário e verificar se herda as configurações<br>Login com novo usuário e verificar desktop |

### Categoria: Browsers (060-configura-browsers.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 013 | Políticas do Chrome | Verificar arquivo de políticas do Chrome<br>Comando: `cat /etc/opt/chrome/policies/managed/policies.json`<br>Deve conter configurações como bookmarks gerenciados |
| 014 | Firefox configurado | Verificar configuração do Firefox<br>Comando: `ls -la /usr/lib/firefox/`<br>Verificar arquivos de configuração |
| 015 | Bookmarks gerenciados | Abrir Chrome e verificar se bookmarks da CMC estão presentes<br>Verificar favoritos: "Câmara Municipal", "Intranet", "Correio", etc. |

### Categoria: Autostart (070-autostart.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 016 | Arquivos autostart criados | Verificar se arquivos de autostart estão presentes<br>Comando: `ls -la /etc/xdg/autostart/`<br>Verificar arquivos .desktop |
| 017 | ForceLogout configurado | Verificar se forcelogout está configurado<br>Comando: `cat /etc/xdg/autostart/forcelogout.desktop` |

### Categoria: Política Informática (080-politica-informatica.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 018 | Arquivo política criado | Verificar se arquivo de política foi criado<br>Comando: `ls -la /home/*/Desktop/politica-informatica.pdf`<br>Arquivo deve existir no desktop |

### Categoria: Desabilitar TTY (090-desabilita-tty.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 019 | TTYs desabilitados | Tentar trocar para TTY2-6 usando Ctrl+Alt+F2 até F6<br>Não deve ser possível acessar outros terminais |

### Categoria: DConf (100-dconf.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 020 | Configurações dconf aplicadas | Verificar configurações do ambiente gráfico<br>Comando: `dconf dump /` \| grep -i cinnamon<br>Verificar se configurações personalizadas estão aplicadas |
| 021 | Applet calendário | Verificar se applet de calendário está configurado<br>Verificar panel do Cinnamon |

### Categoria: Terminal Policy (110-terminal-policy.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 022 | PolicyKit configurado | Verificar arquivo de política<br>Comando: `cat /etc/polkit-1/localauthority/50-local.d/10-terminal.pkla`<br>Deve conter regras de acesso ao terminal |

### Categoria: DNS (120-configura-dns.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 023 | Configuração DNS | Verificar configuração do systemd-resolved<br>Comando: `cat /etc/systemd/resolved.conf`<br>Deve conter DNS e domínio configurados |
| 024 | Resolução DNS funcionando | Testar resolução de nomes do domínio<br>Comando: `nslookup <servidor_dominio>`<br>Deve resolver corretamente |

### Categoria: Script Boot (130-script-boot.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 025 | Script boot criado | Verificar se script existe<br>Comando: `ls -la /opt/cmc/cmc-boot.sh`<br>Script deve existir e ser executável |
| 026 | Serviço boot ativo | Verificar se serviço está ativo<br>Comando: `systemctl status cmc-boot.service`<br>Deve estar ativo e habilitado |

### Categoria: Integração AD (140-integra-ad.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 027 | Hostname configurado | Verificar se hostname está no domínio<br>Comando: `hostname -f`<br>Deve retornar FQDN com domínio |
| 028 | Pacotes AD instalados | Verificar instalação do SSSD<br>Comando: `dpkg -l \| grep -E "(sssd\|realm\|krb5\|adcli)"`<br>Pacotes devem estar instalados |
| 029 | Configuração SSSD | Verificar arquivo sssd.conf<br>Comando: `sudo cat /etc/sssd/sssd.conf`<br>Deve conter configuração do domínio |
| 030 | Join no domínio | Verificar se máquina está no domínio<br>Comando: `sudo realm list`<br>Deve mostrar o domínio configurado |
| 031 | Login domínio funcional | Testar login com usuário do domínio<br>Fazer logout e tentar login com usuário AD |

### Categoria: PAM (150-configura-pam.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 032 | Configuração PAM | Verificar arquivos PAM<br>Comando: `ls -la /etc/pam.d/`<br>Verificar se contém configurações adequadas |
| 033 | Autenticação funcionando | Testar autenticação com usuário local e domínio<br>Comando: `su - <usuario>`<br>Deve funcionar para ambos os tipos |

### Categoria: Sudoers (160-sudoers.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 034 | Grupo DTIC no sudoers | Verificar se grupo tem acesso sudo<br>Comando: `sudo cat /etc/sudoers.d/dtic`<br>Deve conter regra para grupo DTIC |
| 035 | Sudo funcional para DTIC | Testar sudo com usuário do grupo DTIC<br>Login com usuário DTIC e executar: `sudo whoami`<br>Deve retornar "root" |

### Categoria: Unattended Upgrades (170-unattended-upgrades.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 036 | Unattended-upgrades instalado | Verificar se está instalado<br>Comando: `dpkg -l \| grep unattended-upgrades`<br>Deve estar instalado |
| 037 | Configuração upgrades | Verificar arquivo de configuração<br>Comando: `cat /etc/apt/apt.conf.d/50unattended-upgrades`<br>Deve ter configurações adequadas |

### Categoria: Bashrc (180-bashrc.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 038 | Bashrc configurado | Verificar configuração personalizada do bash<br>Comando: `cat /etc/bash.bashrc`<br>Deve conter personalizações CMC |
| 039 | Aliases funcionais | Abrir terminal e testar aliases personalizados<br>Testar comandos como `ll`, `la` se configurados |

### Categoria: S3FS Mount (190-s3fs-mount.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 040 | S3FS instalado | Verificar se s3fs está instalado<br>Comando: `which s3fs`<br>Deve retornar caminho do executável |
| 041 | Mount point criado | Verificar se ponto de montagem existe<br>Comando: `ls -la /mnt/suporte/`<br>Diretório deve existir |
| 042 | Configuração fstab | Verificar entrada no fstab<br>Comando: `grep s3fs /etc/fstab`<br>Deve conter configuração de montagem |

### Categoria: Script Rede (200-script-rede.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 043 | Script rede criado | Verificar se script existe<br>Comando: `ls -la /opt/cmc/cmc-rede.sh`<br>Script deve existir |
| 044 | Serviço rede ativo | Verificar serviço de rede<br>Comando: `systemctl status cmc-rede.service`<br>Verificar se está configurado |

### Categoria: SSH Server (210-ssh-server.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 045 | SSH server instalado | Verificar se openssh-server está instalado<br>Comando: `dpkg -l \| grep openssh-server`<br>Deve estar instalado |
| 046 | SSH server rodando | Verificar se serviço SSH está ativo<br>Comando: `systemctl status ssh`<br>Deve estar ativo |
| 047 | Configuração SSH | Verificar arquivo de configuração<br>Comando: `sudo cat /etc/ssh/sshd_config`<br>Verificar configurações de segurança |
| 048 | Conexão SSH funcional | Testar conexão SSH local<br>Comando: `ssh localhost`<br>Deve ser possível conectar |

### Categoria: VNC (220-vnc.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 049 | VNC instalado | Verificar se VNC está instalado<br>Comando: `dpkg -l \| grep vnc`<br>Deve estar instalado |
| 050 | Configuração VNC | Verificar configuração do VNC<br>Comando: `ls -la /home/.vnc/`<br>Verificar arquivos de configuração |
| 051 | Serviço VNC | Verificar se serviço VNC está rodando<br>Comando: `systemctl status vncserver@*`<br>Verificar status |

### Categoria: Menu Items (230-menu-items.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 052 | Itens menu desabilitados | Verificar se itens desnecessários estão ocultos no menu<br>Abrir menu principal e verificar quais aplicativos estão visíveis |
| 053 | Arquivos .desktop modificados | Verificar modificações em arquivos desktop<br>Comando: `grep "NoDisplay=true" /usr/share/applications/*.desktop`<br>Alguns itens devem estar ocultos |

### Categoria: Login Gráfico (240-login-grafico.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 054 | LightDM configurado | Verificar configuração do lightdm<br>Comando: `cat /etc/lightdm/lightdm.conf`<br>Deve conter configurações personalizadas |
| 055 | Tema login personalizado | Verificar se tema da CMC está aplicado<br>Fazer logout e verificar aparência da tela de login |
| 056 | Autologin desabilitado | Verificar se autologin está desabilitado<br>Reiniciar e verificar se pede login |

### Categoria: CUPS (250-configura-cups.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 057 | CUPS instalado e rodando | Verificar se CUPS está ativo<br>Comando: `systemctl status cups`<br>Deve estar ativo |
| 058 | Interface CUPS acessível | Acessar interface web do CUPS<br>Abrir navegador em `http://localhost:631`<br>Interface deve carregar |
| 059 | Configuração impressoras | Verificar se pode configurar impressoras<br>Tentar adicionar impressora via interface |

### Categoria: Mount Pendrive (260-mount-pendrive.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 060 | Regras udev criadas | Verificar regras para dispositivos USB<br>Comando: `ls -la /etc/udev/rules.d/`<br>Verificar arquivos de regras |
| 061 | Montagem automática funcionando | Conectar pendrive e verificar montagem<br>Plugar USB e verificar se monta automaticamente |

### Categoria: Bluetooth Pairing (265-pairing-bluetooth.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 062 | Bluetooth configurado | Verificar se bluetooth está funcionando<br>Comando: `bluetoothctl show`<br>Deve mostrar adaptador |
| 063 | Pareamento funcional | Testar pareamento com dispositivo<br>Tentar parear com dispositivo bluetooth |

### Categoria: Bloqueio Cinnamon (270-bloqueio-cinnamon.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 064 | ACLs configuradas | Verificar ACLs nos executáveis<br>Comando: `getfacl /usr/bin/cinnamon-settings`<br>Verificar permissões |
| 065 | Programas bloqueados | Tentar executar programas restritos<br>Tentar abrir configurações do sistema<br>Deve estar restrito para usuários normais |

### Categoria: On Login (280-on-login.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 066 | Script on-login criado | Verificar se script existe<br>Comando: `ls -la /opt/cmc/on-login.sh`<br>Script deve existir |
| 067 | Ícones desktop protegidos | Fazer login e verificar ícones<br>Tentar remover ícones do desktop<br>Deve estar protegido (chattr +i) |

### Categoria: Logs (290-configura-logs.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 068 | Configuração rsyslog | Verificar configuração de logs<br>Comando: `cat /etc/rsyslog.conf`<br>Verificar se tem configurações personalizadas |
| 069 | Logs funcionando | Verificar se logs estão sendo gerados<br>Comando: `tail -f /var/log/syslog`<br>Deve mostrar atividade do sistema |

### Categoria: Zoom Autoupdate (300-zoom-autoupdate.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 070 | Script zoom update | Verificar script de atualização<br>Comando: `ls -la /opt/cmc/zoom-update.sh`<br>Script deve existir |
| 071 | Serviço zoom update | Verificar serviço de atualização<br>Comando: `systemctl status zoom-update.service`<br>Verificar se está configurado |

### Categoria: Versionamento (990-versionamento.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 072 | Arquivo versão criado | Verificar arquivo de versão<br>Comando: `cat /opt/cmc/versao`<br>Deve conter informações da versão |

### Categoria: Arquivos Modificados (995-arquivos-modificados.yml)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 073 | Links simbólicos criados | Verificar links para arquivos modificados<br>Comando: `ls -la /opt/cmc/modificados/`<br>Deve conter links para arquivos alterados |

## Teste Final Integrado

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 074 | Reinicialização completa | Reiniciar sistema e verificar se tudo funciona<br>1. Reiniciar a máquina<br>2. Fazer login com usuário do domínio<br>3. Verificar se desktop carrega corretamente<br>4. Abrir aplicativos principais (Chrome, Firefox)<br>5. Verificar conectividade de rede<br>6. Testar acesso a recursos do domínio |
| 075 | Performance geral | Verificar se sistema está responsivo<br>Abrir múltiplas aplicações e verificar performance |

---

**Total de testes manuais: 75**

## Resumo de Validação

- [ ] **Usuários e Grupos**: 3 testes
- [ ] **Pacotes**: 6 testes  
- [ ] **Configurações de Sistema**: 15 testes
- [ ] **Rede e DNS**: 4 testes
- [ ] **Segurança e Acesso**: 8 testes
- [ ] **Serviços**: 12 testes
- [ ] **Interface Gráfica**: 8 testes
- [ ] **Integração AD**: 5 testes
- [ ] **Funcionalidades Específicas**: 14 testes

**Status da Estação: [ ] Aprovada [ ] Reprovada**

**Data do Teste: ___________**  
**Testador: _______________**  
**Versão Testada: _________**