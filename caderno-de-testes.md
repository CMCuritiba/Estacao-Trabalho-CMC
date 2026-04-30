# Caderno de Testes - Estação de Trabalho CMC

Este documento contém todos os testes necessários para validar a configuração correta da estação de trabalho CMC.

# Esclarecimento

> Este caderno foi feito com o agente de IA GitHub Copilot, e pode conter erros. Favor revisar cuidadosamente antes de usar.

## Como usar este caderno

1. Execute cada teste na ordem apresentada
2. Marque como ✅ os testes que passaram
3. Marque como ❌ os testes que falharam e investigue o problema
4. Para testes automatizados, use o comando `molecule verify` na pasta `roles/estacao/`

> NOTA IMPORTANTE: antes de executar testes semiautomatizados ou alterar a ordem das tasks,
> leia `roles/estacao/ESTACAO-tasks-dependencies.md`. Esse arquivo descreve dependências
> críticas entre as tasks (handlers acionados por `notify`, templates que dependem de mounts,
> variáveis compartilhadas, etc.). Seguir as recomendações evita efeitos colaterais (por exemplo,
> executar `050-skel` antes de `080-politica-informatica` pode fazer com que o script `.politicainformatica.sh`
> em `/etc/skel` não encontre o arquivo de política e gere um arquivo `.forcelogout` para novos usuários, mostrando uma tela de política vazia).

## T1. Testes Semiautomatizados

> Utilizam Ansible (e Vagrant opcionalmente)

### Categorias

#### Usuários e Grupos (`010-user-group-suporte.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 011 | Criação do usuário suporte | Testar login na estação com o usuário suporte usando a senha configurada |
| 012 | Grupo do usuário suporte | Verificar se o usuário suporte está nos grupos corretos<br>No terminal: `id suporte`<br>Deve mostrar grupos: suporte, sudo |
| 013 | Senha de root | Testar login com root com a senha configurada<br>No terminal: `su -`<br>Inserir a senha de root configurada |

#### Remoção de Programas (`020-remover-programas.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 021 | Programas removidos | Verificar apenas os pacotes-alvo de remoção, evitando falso positivo por nomes genéricos<br>Comando: `dpkg -l hexchat thunderbird hypnotix celluloid warpinator transmission-gtk 2>/dev/null | grep '^ii'`<br>Não deve retornar nenhum resultado |

#### Instalação de Programas (`030-instala-programas.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 031 | Repositórios brasileiros | Verificar se repositórios estão configurados para Brasil<br>Comando: `grep "br.archive.ubuntu.com" /etc/apt/sources.list.d/official-package-repositories.list`<br>Comando: `grep "mint-packages.c3sl.ufpr.br" /etc/apt/sources.list.d/official-package-repositories.list` |
| 032 | Programas essenciais instalados | Verificar instalação de programas essenciais<br>Comando: `dpkg -l curl vim git htop tree unzip wget openssh-server 2>/dev/null | grep '^ii'`<br>Todos devem aparecer como instalados |
| 033 | Google Chrome instalado | Verificar se Google Chrome está instalado<br>Comando: `google-chrome --version`<br>Deve retornar a versão instalada |
| 034 | Zoom instalado | Verificar se Zoom está instalado<br>Comando: `zoom --version` ou verificar em `/opt/zoom/` |

#### Imagens CMC (`040-imagens-cmc.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 041 | Imagens de fundo CMC | Verificar se imagens estão na pasta correta<br>Comando: `ls -la /usr/share/backgrounds/cmc/`<br>Deve conter arquivos de imagem |
| 042 | Papel de parede configurado | Verificar se papel de parede padrão está definido<br>Verificar nas configurações do sistema ou dconf |

#### Configuração Skel (`050-skel.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 051 | Diretórios skel criados | Verificar estrutura de diretórios em /etc/skel<br>Comando: `ls -la /etc/skel/`<br>Verificar se contém Desktop, Documents, etc. |
| 052 | Configurações padrão skel | Testar criando um novo usuário e verificar se herda as configurações<br>Login com novo usuário e verificar desktop |

> NOTA: A task `050-skel.yml` instala o script de política em `/etc/skel` que lê o arquivo definido em
> `{{ estacao_politica }}`. Esse arquivo é criado por `080-politica-informatica.yml`. Recomenda-se executar
> `080` antes de `050`, ou criar manualmente um mock de `{{ estacao_politica }}` (por exemplo `/usr/local/cmc/politica-informatica.txt`)
> antes de rodar `050` para evitar comportamentos inesperados ao criar novos usuários.

#### Browsers (`060-configura-browsers.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 061 | Políticas dos navegadores | Verificar arquivos de políticas aplicados<br>Comando: `ls -la /etc/opt/chrome/policies/managed/cmc.json /etc/firefox/policies/policies.json`<br>Os arquivos devem existir |
| 062 | Firefox configurado | Verificar configuração do Firefox<br>Comando: `ls -la /usr/lib/firefox/`<br>Verificar arquivos de configuração |
| 063 | Bookmarks gerenciados | Abrir Chrome e verificar se bookmarks da CMC estão presentes<br>Verificar favoritos: "Câmara Municipal", "Intranet", "Correio", etc. |

#### Autostart (`070-autostart.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 071 | Arquivos autostart criados | Verificar se arquivos de autostart estão presentes<br>Comando: `ls -la /etc/xdg/autostart/`<br>Verificar arquivos .desktop |
| 072 | ForceLogout configurado | Verificar se forcelogout está configurado<br>Comando: `cat /etc/xdg/autostart/forcelogout.desktop` |

#### Política Informática (`080-politica-informatica.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 081 | Arquivo política criado | Verificar se o arquivo-base da política foi criado<br>Comando: `ls -la /usr/local/cmc/politica-informatica.txt /usr/local/cmc/scripts/forcelogout.sh /etc/skel/.politicainformatica.sh`<br>Os arquivos devem existir |

#### Desabilitar TTY (`090-desabilita-tty.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 091 | TTYs desabilitados | Tentar trocar para TTY2-6 usando Ctrl+Alt+F2 até F6<br>Não deve ser possível acessar outros terminais |

#### DConf (`100-dconf.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 101 | Configurações dconf aplicadas | Verificar arquivos dconf gerados<br>Comando: `ls -la /etc/dconf/db/local.d/01-cmc /etc/dconf/db/local.d/locks/01-cmc && sudo dconf update`<br>Os arquivos devem existir e `dconf update` deve executar sem erro |
| 102 | Applet calendário | Verificar se applet de calendário está configurado<br>Verificar panel do Cinnamon |

#### Políticas de Terminal (`110-terminal-policy.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 111 | PolicyKit configurado | Verificar arquivo de política aplicado pela role<br>Comando: `ls -la /usr/share/polkit-1/actions/org.freedesktop.policykit.terminal.policy`<br>O arquivo deve existir |

#### DNS (`120-configura-dns.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 121 | Configuração DNS | Verificar configuração do systemd-resolved<br>Comando: `cat /etc/systemd/resolved.conf`<br>Deve conter DNS e domínio configurados |
| 122 | Resolução DNS funcionando | Testar resolução de nomes do domínio<br>Comando: `nslookup <servidor_dominio>`<br>Deve resolver corretamente |

#### Script Boot (`130-script-boot.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 131 | Script boot criado | Verificar se script existe<br>Comando: `ls -la /usr/local/cmc/scripts/cmc-boot.sh`<br>O script deve existir e ser executável |
| 132 | Serviço boot ativo | Verificar se serviço está ativo<br>Comando: `systemctl status cmc-boot.service`<br>Deve estar ativo e habilitado |

#### Integração AD (`140-integra-ad.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 141 | Hostname configurado | Verificar se hostname está no domínio<br>Comando: `hostname -f`<br>Deve retornar FQDN com domínio |
| 142 | Pacotes AD instalados | Verificar instalação do SSSD<br>Comando: `dpkg -l \| grep -E "(sssd\|realm\|krb5\|adcli)"`<br>Pacotes devem estar instalados |
| 143 | Configuração SSSD | Verificar arquivo de configuração do SSSD<br>Comando: `sudo cat /etc/sssd/conf.d/01-cmc.conf`<br>Deve conter configuração do domínio |
| 144 | Join no domínio | Verificar se máquina está no domínio<br>Comando: `sudo realm list`<br>Deve mostrar o domínio configurado |
| 145 | Login domínio funcional | Testar login com usuário do domínio<br>Fazer logout e tentar login com usuário AD |

Obs: para testar o login com usuário do domínio, é necessário que a máquina esteja realmente integrada ao domínio AD da CMC. Se estiver usando uma VM de teste, certifique-se de que ela tenha acesso à rede da CMC e possa se comunicar com os controladores de domínio.

Altere o arquivo `inventory/group_vars/all.yml` para configurar as variáveis de domínio (como `estacao_dominio`, `estacao_realm`, etc.) de acordo com o ambiente de teste, para garantir que a integração AD funcione corretamente.

É necessário um usuário com permissões de administrador no domínio para realizar o join da máquina ao domínio. Certifique-se de ter as credenciais adequadas para isso.


```shell
# Verificar ip do host e domínio
host -f cmc.local
```

#### PAM (`150-configura-pam.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 151 | Configuração PAM | Verificar arquivos PAM<br>Comando: `ls -la /etc/pam.d/`<br>Verificar se contém configurações adequadas |
| 152 | Autenticação funcionando | Testar autenticação com usuário local e domínio<br>Comando: `su - <usuario>`<br>Deve funcionar para ambos os tipos |

#### Sudoers (`160-sudoers.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 161 | Grupo DTIC no sudoers | Verificar se grupo tem acesso sudo<br>Comando: `sudo cat /etc/sudoers.d/cmc`<br>Deve conter regra para grupo DTIC |
| 162 | Sudo funcional para DTIC | Testar sudo com usuário do grupo DTIC<br>Login com usuário DTIC e executar: `sudo whoami`<br>Deve retornar "root" |

#### Atualizações Não Automáticas (`170-unattended-upgrades.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 171 | Unattended-upgrades instalado | Verificar se está instalado<br>Comando: `dpkg -l \| grep unattended-upgrades`<br>Deve estar instalado |
| 172 | Configuração upgrades | Verificar arquivo de configuração<br>Comando: `cat /etc/apt/apt.conf.d/50unattended-upgrades`<br>Deve ter configurações adequadas |

#### Bashrc (`180-bashrc.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 181 | Bash aliases configurados | Verificar aliases distribuídos pela role<br>Comando: `ls -la /root/.bash_aliases /etc/skel/.bash_aliases`<br>Os arquivos devem existir |
| 182 | Aliases funcionais | Abrir terminal e testar aliases personalizados<br>Testar comandos como `ll`, `la` se configurados |

#### S3FS Mount (`190-s3fs-mount.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 191 | S3FS instalado | Verificar se s3fs está instalado<br>Comando: `which s3fs`<br>Deve retornar caminho do executável |
| 192 | Mount point criado | Verificar se ponto de montagem existe<br>Comando: `ls -la /mnt/suporte/`<br>Diretório deve existir |
| 193 | Configuração fstab | Verificar entrada no fstab<br>Comando: `grep s3fs /etc/fstab`<br>Deve conter configuração de montagem |

#### Script Rede (`200-script-rede.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 201 | Serviço rede criado | Verificar se arquivo do serviço existe<br>Comando: `ls -la /etc/systemd/system/cmc-network.service`<br>O arquivo deve existir |
| 202 | Serviço rede configurado | Verificar serviço de rede<br>Comando: `systemctl status cmc-network.service`<br>O serviço deve estar configurado |

#### SSH Server (`210-ssh-server.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 211 | SSH server instalado | Verificar se openssh-server está instalado<br>Comando: `dpkg -l \| grep openssh-server`<br>Deve estar instalado |
| 212 | SSH server rodando | Verificar se serviço SSH está ativo<br>Comando: `systemctl status ssh`<br>Deve estar ativo |
| 213 | Configuração SSH | Verificar arquivo de configuração<br>Comando: `sudo cat /etc/ssh/sshd_config`<br>Verificar configurações de segurança |
| 214 | Conexão SSH funcional | Testar conexão SSH local<br>Comando: `ssh localhost`<br>Deve ser possível conectar |

#### VNC (`220-vnc.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 221 | VNC instalado | Verificar se o stack atual da role está instalado<br>Comando: `dpkg -l | grep vino`<br>O pacote deve estar instalado |
| 222 | Configuração VNC | Verificar autostart do VNC<br>Comando: `ls -la /etc/xdg/autostart/vino-server.desktop`<br>O arquivo deve existir |
| 223 | Serviço VNC | Verificar se o processo/porta do VNC estão ativos em sessão gráfica<br>Comando: `ps -ef | grep -E "[v]ino-server" && ss -lntp | grep 5900`<br>Deve haver processo e porta ouvindo |

#### Menu Items (`230-menu-items.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 231 | Itens menu desabilitados | Verificar se itens desnecessários estão ocultos no menu<br>Abrir menu principal e verificar quais aplicativos estão visíveis |
| 232 | Arquivos .desktop modificados | Verificar modificações em arquivos desktop<br>Comando: `grep "NoDisplay=true" /usr/share/applications/*.desktop`<br>Alguns itens devem estar ocultos |

#### Login Gráfico (`240-login-grafico.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 241 | LightDM configurado | Verificar configuração do lightdm<br>Comando: `cat /etc/lightdm/lightdm.conf`<br>Deve conter configurações personalizadas |
| 242 | Tema login personalizado | Verificar se tema da CMC está aplicado<br>Fazer logout e verificar aparência da tela de login |
| 243 | Autologin desabilitado | Verificar se autologin está desabilitado<br>Reiniciar e verificar se pede login |

#### CUPS (`250-configura-cups.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 251 | CUPS instalado e rodando | Verificar se CUPS está ativo<br>Comando: `systemctl status cups`<br>Deve estar ativo |
| 252 | Interface CUPS acessível | Acessar interface web do CUPS<br>Abrir navegador em `http://localhost:631`<br>Interface deve carregar |
| 253 | Configuração impressoras | Verificar se pode configurar impressoras<br>Tentar adicionar impressora via interface |

#### Mount Pendrive (`260-mount-pendrive.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 261 | Regras udev criadas | Verificar regras para dispositivos USB<br>Comando: `ls -la /etc/udev/rules.d/`<br>Verificar arquivos de regras |
| 262 | Montagem automática funcionando | Conectar pendrive e verificar montagem<br>Plugar USB e verificar se monta automaticamente |

#### Bluetooth Pairing (`265-pairing-bluetooth.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 266 | Bluetooth configurado | Verificar se bluetooth está funcionando<br>Comando: `bluetoothctl show`<br>Deve mostrar adaptador |
| 267 | Pareamento funcional | Testar pareamento com dispositivo<br>Tentar parear com dispositivo bluetooth |

#### Bloqueio Cinnamon (`270-bloqueio-cinnamon.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 272 | ACLs configuradas | Verificar ACLs nos executáveis bloqueados<br>Comando: `getfacl /usr/bin/cinnamon-desktop-editor`<br>Verificar permissões para `suporte` e `grupo-dtic` |
| 273 | Programas bloqueados | Tentar executar programas restritos<br>Tentar abrir configurações do sistema<br>Deve estar restrito para usuários normais |

#### On Login (`280-on-login.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 282 | Script on-login criado | Verificar se script existe<br>Comando: `ls -la /usr/local/cmc/scripts/on-login.sh`<br>O script deve existir |
| 283 | Ícones desktop protegidos | Fazer login e verificar ícones<br>Tentar remover ícones do desktop<br>Deve estar protegido (chattr +i) |

#### Logs (`290-configura-logs.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 292 | Configuração de rotação de logs | Verificar arquivos de logrotate aplicados pela role<br>Comando: `ls -la /etc/logrotate.d/rsyslog /etc/logrotate.d/sssd-common`<br>Os arquivos devem existir |
| 293 | Logs funcionando | Verificar se logs estão sendo gerados<br>Comando: `tail -n 20 /var/log/syslog`<br>Deve mostrar atividade recente do sistema |

#### Zoom Autoupdate (`300-zoom-autoupdate.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 303 | Script zoom update | Verificar script de atualização<br>Comando: `ls -la /usr/local/cmc/scripts/zoom-update.sh`<br>O script deve existir |
| 304 | Serviço zoom update | Verificar serviço de atualização<br>Comando: `systemctl status zoom-update.service`<br>Verificar se está configurado |

#### Versionamento (`990-versionamento.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 991 | Arquivo versão criado | Verificar arquivo de versão<br>Comando: `cat /usr/local/cmc/version`<br>Deve conter informações da versão |

#### Arquivos Modificados (`999-arquivos-modificados.yml`)

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 996 | Links simbólicos criados | Verificar links para arquivos modificados<br>Comando: `ls -la /opt/cmc/modificados/`<br>Deve conter links para arquivos alterados |

#### Teste Final Integrado (`1000-teste-integrado.yml`)

> Ainda inexistente!

| ID  | Teste | Como testar |
|-----|-------|-------------|
| 1001 | Reinicialização completa | Reiniciar sistema e verificar se tudo funciona<br>1. Reiniciar a máquina<br>2. Fazer login com usuário do domínio<br>3. Verificar se desktop carrega corretamente<br>4. Abrir aplicativos principais (Chrome, Firefox)<br>5. Verificar conectividade de rede<br>6. Testar acesso a recursos do domínio |
| 1002 | Performance geral | Verificar se sistema está responsivo<br>Abrir múltiplas aplicações e verificar performance |

---

## T2. Testes Automatizados

> Utilizam Molecule + Vagrant + Ansible

Para facilitar a validação, alguns testes podem ser executados automaticamente usando o `Molecule`:

```bash
cd roles/estacao/
molecule verify
```

### Testes disponíveis

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

**Total de testes semiautomatizados: 40+ (distribuídos conforme numeração das tasks)**

---

## Formulário - Validação da Estação de Trabalho da CMC

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
**Testador(a): _______________**
**Versão Testada: _________**

**Observações Adicionais (caso necessário):**
**____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________**
