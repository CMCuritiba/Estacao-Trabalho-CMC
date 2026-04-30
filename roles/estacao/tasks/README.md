# Caderno de Testes

## Guia para teste das tasks da ET

### `010-user-group-suporte.yml`

| ID | Teste | Como testar |
|---|---|---|
| 011 | Criação do usuário | Testar login na estação com o usuário usando a senha esperada |
| 012 | Grupo do usuário | Verificar se o usuário está nos grupos corretos<br>No terminal, com os comandos:<br>`id <usuario>` ou `cat /etc/group \| grep <usuario> \| grep <grupo>` |
| 013 | Testar senha de root | Testar login com root com a senha pretendida<br>No terminal, com o comando:<br>`su` |

### `020-remover-programas.yml`

| ID | Teste | Como testar |
|---|---|---|
| 021 | Verificar remoção do Thunderbird | Verificar se o cliente de e-mail Thunderbird foi removido<br>No terminal: `dpkg -l | grep thunderbird` (deve retornar vazio) |
| 022 | Verificar remoção do Transmission | Verificar se o cliente torrent Transmission foi removido<br>No terminal: `dpkg -l | grep transmission` (deve retornar vazio) |
| 023 | Verificar remoção de programas desnecessários | Verificar se os programas xed, hexchat, celluloid, hypnotix, redshift e warpinator foram removidos<br>No menu de aplicações ou comando: `which xed hexchat celluloid hypnotix redshift warpinator` |

### `030-instala-programas.yml`

| ID | Teste | Como testar |
|---|---|---|
| 031 | Verificar repositórios brasileiros | Verificar se os repositórios foram alterados para servidores brasileiros<br>No terminal: `cat /etc/apt/sources.list.d/official-package-repositories.list | grep br.archive.ubuntu.com` |
| 032 | Verificar instalação do Google Chrome | Verificar se o Google Chrome foi instalado<br>No menu de aplicações ou comando: `google-chrome --version` |
| 033 | Verificar instalação do Microsoft Edge | Verificar se o Microsoft Edge foi instalado<br>No menu de aplicações ou comando: `microsoft-edge --version` |
| 034 | Verificar programas de mídia | Verificar se VLC, Audacity, GIMP, Inkscape e Drawing foram instalados<br>No menu de aplicações ou terminal: `vlc --version && audacity --version` |
| 035 | Verificar utilitários instalados | Verificar se vim, gedit, pdfsam, unrar foram instalados<br>No terminal: `vim --version && gedit --version` |

### `040-imagens-cmc.yml`

| ID | Teste | Como testar |
|---|---|---|
| 041 | Verificar ícone de suporte | Verificar se o ícone suporte_tux.png foi copiado<br>No terminal: `ls -la /usr/share/pixmaps/suporte_tux.png` |
| 042 | Verificar papel de parede | Verificar se as imagens de fundo foram copiadas<br>No terminal: `ls -la /usr/share/backgrounds/cmc/` |
| 043 | Verificar imagens do greeter | Verificar se login-bg.jpg e desktop-bg.jpg estão disponíveis<br>Verificar na tela de login e área de trabalho |

### `050-skel.yml`

| ID | Teste | Como testar |
|---|---|---|
| 051 | Verificar estrutura de diretórios skel | Verificar se os diretórios padrão foram criados<br>No terminal: `ls -la /etc/skel/` (deve mostrar Desktop, Downloads, Música, Imagens, Vídeos) |
| 052 | Verificar Docs.Locais | Verificar se o diretório compartilhado foi criado e linkado<br>No terminal: `ls -la /home/Docs.Locais && ls -la /etc/skel/Docs.Locais` |
| 053 | Verificar ícones no desktop | Criar um novo usuário e verificar se os ícones do Firefox, Chrome e Suporte aparecem no desktop |
| 054 | Verificar política de privacidade | Fazer login com novo usuário e verificar se a política de informática aparece |
| 055 | Verificar configurações de mímica | Verificar se as associações de arquivos foram configuradas<br>No terminal: `cat /etc/skel/.config/mimeapps.list` |

Para criar um novo usuário para testes, use o comando:

```bash
    sudo adduser user_teste
    # após isso, faça logout e login com o novo usuário
```

### `060-configura-browsers.yml`

| ID | Teste | Como testar |
|---|---|---|
| 061 | Verificar configurações do Firefox | Abrir o Firefox e verificar se as configurações da CMC foram aplicadas<br>Verificar arquivos: `/usr/lib/firefox/defaults/pref/local-settings.js` e `/usr/lib/firefox/mozilla.cfg` |
| 062 | Verificar políticas do Firefox | Verificar se os bookmarks gerenciados estão presentes<br>No Firefox: Menu > Favoritos (devem aparecer links da CMC) |
| 063 | Verificar configurações do Chrome | Abrir o Chrome e verificar se as políticas foram aplicadas<br>No terminal: `cat /etc/opt/chrome/policies/managed/cmc.json` |
| 064 | Verificar bookmarks gerenciados | Verificar se os bookmarks da CMC aparecem nos navegadores<br>Abrir Firefox e Chrome e verificar barra de favoritos |

### `070-autostart.yml`

| ID | Teste | Como testar |
|---|---|---|
| 071 | Verificar desabilitação do autostart | Verificar se os autostarts do Mint foram desabilitados<br>No terminal: `ls -la /etc/xdg/autostart/*.disable` |
| 072 | Verificar autostart do forcelogout | Verificar se o arquivo forcelogout.desktop foi criado<br>No terminal: `cat /etc/xdg/autostart/forcelogout.desktop` |
| 073 | Testar funcionamento do forcelogout | Fazer login e verificar se o sistema de logout forçado está funcionando<br>Aguardar o tempo configurado de inatividade |

### `080-politica-informatica.yml`

| ID | Teste | Como testar |
|---|---|---|
| 081 | Verificar diretório de scripts CMC | Verificar se o diretório foi criado<br>No terminal: `ls -la /opt/cmc/scripts/` |
| 082 | Verificar script forcelogout.sh | Verificar se o script foi copiado<br>No terminal: `ls -la /opt/cmc/scripts/forcelogout.sh` |
| 083 | Verificar política de informática | Verificar se o arquivo foi copiado<br>No terminal: `cat /opt/cmc/politica-informatica.txt` |

### `090-desabilita-tty.yml`

| ID | Teste | Como testar |
|---|---|---|
| 091 | Verificar configuração do xorg.conf | Verificar se a configuração foi adicionada<br>No terminal: `cat /etc/X11/xorg.conf | grep DontVTSwitch` |
| 092 | Testar desabilitação de TTY | Tentar usar Ctrl+Alt+F1 a F6 para trocar de terminal<br>As combinações não devem funcionar |
| 093 | Verificar acesso apenas ao modo gráfico | Reiniciar o sistema e verificar se só é possível acessar o modo gráfico |

### `100-dconf.yml`

| ID | Teste | Como testar |
|---|---|---|
| 101 | Verificar configurações dconf | Verificar se os arquivos de configuração foram criados<br>No terminal: `ls -la /etc/dconf/db/local.d/01-cmc` |
| 102 | Verificar configurações do calendário | Verificar se o formato do calendário foi configurado<br>Olhar o applet do calendário no painel |
| 103 | Verificar configurações do Remote Desktop | Verificar se as configurações do Remote Desktop (gnome-remote-desktop) foram aplicadas e travadas<br>No terminal: `cat /etc/dconf/db/local.d/locks/01-cmc` |
| 104 | Testar script root-terminal | Verificar se o script foi copiado<br>No terminal: `ls -la /opt/cmc/scripts/root-terminal.sh` |

### `110-terminal-policy.yml`

| ID | Teste | Como testar |
|---|---|---|
| 111 | Verificar política do PolicyKit | Verificar se o arquivo de política foi criado<br>No terminal: `ls -la /usr/share/polkit-1/actions/org.freedesktop.policykit.terminal.policy` |
| 112 | Testar abertura de terminal como root | Testar se é possível abrir terminal como root usando pkexec<br>No terminal: `pkexec gnome-terminal` |
| 113 | Verificar autenticação PolicyKit | Verificar se a autenticação é solicitada ao tentar executar comandos privilegiados |

### `120-configura-dns.yml`

| ID | Teste | Como testar |
|---|---|---|
| 121 | Verificar configuração DNS | Verificar se as configurações DNS foram aplicadas<br>No terminal: `cat /etc/systemd/resolved.conf | grep -E "DNS|Domains|FallbackDNS"` |
| 122 | Testar resolução de nomes | Testar se a resolução de nomes do domínio AD funciona<br>No terminal: `nslookup curitiba.local` |
| 123 | Verificar cache DNS | Verificar se o cache negativo foi desabilitado<br>No terminal: `systemctl status systemd-resolved` |

### `130-script-boot.yml`

| ID | Teste | Como testar |
|---|---|---|
| 131 | Verificar script de boot | Verificar se o script foi criado<br>No terminal: `ls -la /opt/cmc/scripts/cmc-boot.sh` |
| 132 | Verificar serviço cmc-boot | Verificar se o serviço foi criado e habilitado<br>No terminal: `systemctl status cmc-boot.service` |
| 133 | Verificar timer cmc-boot | Verificar se o timer foi configurado<br>No terminal: `systemctl status cmc-boot.timer` |
| 134 | Testar execução do script | Executar manualmente e verificar se configura o hostname corretamente<br>No terminal: `sudo /opt/cmc/scripts/cmc-boot.sh` |

### `140-integra-ad.yml`

| ID | Teste | Como testar |
|---|---|---|
| 141 | Verificar configuração hostname | Verificar se o hostname foi configurado corretamente<br>No terminal: `hostname -f` (deve incluir o domínio) |
| 142 | Verificar integração com AD | Verificar se a máquina está no realm<br>No terminal: `realm list` |
| 143 | Verificar configuração SSSD | Verificar se o SSSD foi configurado<br>No terminal: `cat /etc/sssd/conf.d/01-cmc.conf` |
| 144 | Testar login com usuário AD | Tentar fazer login com um usuário do Active Directory |
| 145 | Verificar configuração Kerberos | Verificar se o Kerberos foi configurado<br>No terminal: `cat /etc/krb5.conf | grep default_realm` |

### `150-configura-pam.yml`

| ID | Teste | Como testar |
|---|---|---|
| 151 | Verificar configuração PAM | Verificar se as configurações PAM foram aplicadas<br>No terminal: `cat /etc/pam.d/common-auth` |
| 152 | Testar autenticação híbrida | Testar login com usuários locais e do AD<br>Fazer login com ambos os tipos de usuário |
| 153 | Verificar criação de home directory | Verificar se o diretório home é criado automaticamente para usuários AD<br>Fazer primeiro login de usuário AD |

### `160-sudoers.yml`

| ID | Teste | Como testar |
|---|---|---|
| 161 | Verificar configuração sudoers | Verificar se o grupo DTIC foi adicionado<br>No terminal: `cat /etc/sudoers.d/cmc` |
| 162 | Testar privilégios sudo | Fazer login com usuário do grupo DTIC e testar comando sudo<br>No terminal: `sudo whoami` |
| 163 | Verificar solicitação de senha | Verificar se senha é solicitada ao usar sudo<br>Executar comando sudo e verificar prompt de senha |

### `170-unattended-upgrades.yml`

| ID | Teste | Como testar |
|---|---|---|
| 171 | Verificar instalação unattended-upgrades | Verificar se o pacote foi instalado<br>No terminal: `dpkg -l | grep unattended-upgrades` |
| 172 | Verificar configuração de atualizações | Verificar se as configurações foram aplicadas<br>No terminal: `cat /etc/apt/apt.conf.d/50unattended-upgrades` |
| 173 | Verificar minimal steps | Verificar se MinimalSteps foi habilitado<br>Procurar por "MinimalSteps" no arquivo de configuração |
| 174 | Verificar atualizações automáticas navegadores | Verificar se Chrome, Edge e Firefox estão configurados para atualização automática<br>Verificar origins no arquivo de configuração |

### `180-bashrc.yml`

| ID | Teste | Como testar |
|---|---|---|
| 181 | Verificar aliases do root | Verificar se os aliases padrão foram removidos<br>No terminal como root: `alias` |
| 182 | Verificar bash_aliases personalizado | Verificar se o arquivo personalizado foi copiado<br>No terminal: `cat /root/.bash_aliases` |
| 183 | Verificar bash_aliases no skel | Verificar se novos usuários receberão os aliases<br>No terminal: `cat /etc/skel/.bash_aliases` |
| 184 | Testar funcionamento dos aliases | Fazer login com novo usuário e testar aliases personalizados<br>Exemplo: `ll`, `la`, etc. |

### `190-s3fs-mount.yml`

| ID | Teste | Como testar |
|---|---|---|
| 191 | Verificar configuração chaves AWS | Verificar se as chaves foram configuradas<br>No terminal: `ls -la /etc/passwd-s3fs` (arquivo deve existir com permissão 600) |
| 192 | Verificar diretório de montagem | Verificar se o diretório foi criado<br>No terminal: `ls -la /mnt/suporte/` |
| 193 | Verificar configuração fstab | Verificar se a entrada foi adicionada ao fstab<br>No terminal: `cat /etc/fstab | grep s3fs` |
| 194 | Testar montagem S3 | Tentar montar manualmente e verificar acesso<br>No terminal: `sudo mount /mnt/suporte/ && ls /mnt/suporte/` |

### `200-script-rede.yml`

| ID | Teste | Como testar |
|---|---|---|
| 201 | Verificar serviço cmc-network | Verificar se o serviço foi criado<br>No terminal: `systemctl status cmc-network.service` |
| 202 | Verificar habilitação do serviço | Verificar se o serviço está habilitado<br>No terminal: `systemctl is-enabled cmc-network` |
| 203 | Testar execução após rede | Reiniciar o sistema e verificar se o serviço executa após a rede estar disponível<br>Verificar logs: `journalctl -u cmc-network` |

### `210-ssh-server.yml`

| ID | Teste | Como testar |
|---|---|---|
| 211 | Verificar configuração SSH | Verificar se as configurações foram aplicadas<br>No terminal: `cat /etc/ssh/sshd_config | grep -E "PasswordAuthentication|PermitRootLogin|AllowGroups"` |
| 212 | Testar login SSH com usuário autorizado | Tentar conectar via SSH com usuário do grupo DTIC<br>No terminal: `ssh usuario@ip-da-estacao` |
| 213 | Testar bloqueio do root | Tentar conectar como root via SSH (deve ser negado)<br>No terminal: `ssh root@ip-da-estacao` |
| 214 | Verificar serviço SSH | Verificar se o serviço SSH está rodando<br>No terminal: `systemctl status ssh` |

### `220-vnc.yml`

| ID | Teste | Como testar |
|---|---|---|
| 221 | Verificar arquivo de autostart do Remote Desktop | Verificar se o arquivo foi copiado<br>No terminal: `cat /etc/xdg/autostart/org.gnome-remote-desktop.desktop` |
| 222 | Verificar autostart do VNC | Verificar se o autostart foi habilitado<br>Procurar linha "X-GNOME-Autostart-enabled=true" no arquivo |
| 223 | Testar conexão VNC | Fazer login na estação e tentar conectar via VNC<br>Usar cliente VNC para conectar na porta 5900 |

### `230-menu-items.yml`

| ID | Teste | Como testar |
|---|---|---|
| 231 | Verificar remoção de itens do menu | Verificar se os itens foram renomeados para .disable<br>No terminal: `ls -la /usr/share/applications/*.disable` |
| 232 | Verificar menu de aplicações | Abrir o menu de aplicações e verificar se os itens do Mint não aparecem mais<br>Procurar por: Update Manager, Welcome, Report, etc. |
| 233 | Verificar aplicações sistema | Verificar se apenas aplicações necessárias aparecem no menu<br>Navegar pelo menu Aplicações > Administração |

### `240-login-grafico.yml`

| ID | Teste | Como testar |
|---|---|---|
| 241 | Verificar desabilitação guest | Verificar se o login como guest foi desabilitado<br>Na tela de login: não deve aparecer opção "Guest" |
| 242 | Verificar login manual | Verificar se o login manual foi habilitado<br>Na tela de login: deve aparecer campo para digitar usuário |
| 243 | Verificar ocultação de usuários | Verificar se a lista de usuários está oculta<br>Na tela de login: não deve mostrar lista de usuários |
| 244 | Verificar background personalizado | Verificar se o fundo da tela de login foi alterado<br>Fazer logout e verificar imagem de fundo na tela de login |

### `250-configura-cups.yml`

| ID | Teste | Como testar |
|---|---|---|
| 251 | Verificar configuração CUPS | Verificar se o acesso remoto foi habilitado<br>No terminal: `cupsctl | grep _remote_admin` |
| 252 | Verificar acesso da DTIC | Verificar se a rede da DTIC foi adicionada<br>No terminal: `cat /etc/cups/cupsd.conf | grep "Allow {{ estacao_dtic_network }}"` |
| 253 | Verificar desabilitação discovery | Verificar se o discovery foi desabilitado<br>No terminal: `cat /etc/cups/cups-browsed.conf | grep "BrowseRemoteProtocols none"` |
| 254 | Testar acesso web CUPS | Acessar interface web do CUPS<br>No navegador: `http://localhost:631` |

### `260-mount-pendrive.yml`

| ID | Teste | Como testar |
|---|---|---|
| 261 | Verificar configuração UDisks2 | Verificar se as permissões foram alteradas<br>No terminal: `cat /usr/share/polkit-1/actions/org.freedesktop.UDisks2.policy | grep -A 5 filesystem-mount` |
| 262 | Testar montagem automática | Conectar um pendrive e verificar se monta automaticamente<br>Verificar se aparece no gerenciador de arquivos |
| 263 | Testar desmontagem | Tentar desmontar dispositivo sem solicitar senha<br>Clicar com botão direito no dispositivo > Desmontar |
| 264 | Verificar permissões de usuário | Fazer login com usuário comum e testar montagem de dispositivos<br>Deve funcionar sem solicitar senha de administrador |

### `265-pairing-bluetooth.yml`

| ID | Teste | Como testar |
|---|---|---|
| 266 | Verificar configuração Blueman | Verificar se as permissões foram alteradas<br>No terminal: `cat /usr/share/polkit-1/actions/org.blueman.policy | grep -A 3 network.setup` |
| 267 | Testar pareamento Bluetooth | Tentar parear um dispositivo Bluetooth sem senha de administrador<br>Abrir gerenciador Bluetooth e parear dispositivo |
| 268 | Testar ativação/desativação | Tentar ligar/desligar Bluetooth sem solicitar senha<br>Usar applet do Bluetooth no painel |
| 269 | Verificar configuração de rede | Testar configurações de rede Bluetooth sem privilégios elevados<br>Configurar dispositivo de rede via Bluetooth |

### `270-bloqueio-cinnamon.yml`

| ID | Teste | Como testar |
|---|---|---|
| 271 | Verificar restrição de programas | Verificar se as permissões foram alteradas<br>No terminal: `ls -la /usr/bin/gnome-terminal /usr/bin/mintupdate /usr/bin/cinnamon-menu-editor` |
| 272 | Testar acesso com usuário comum | Fazer login com usuário comum e tentar executar programas restritos<br>Deve aparecer erro de permissão |
| 273 | Testar acesso com usuário suporte | Fazer login com usuário de suporte e testar acesso aos programas<br>Deve conseguir executar gnome-terminal e cinnamon-desktop-editor |
| 274 | Testar acesso grupo DTIC | Fazer login com usuário do grupo DTIC e verificar permissões<br>Deve ter acesso aos programas com ACL configurada |

### `280-on-login.yml`

| ID | Teste | Como testar |
|---|---|---|
| 281 | Verificar script on-login | Verificar se o script foi copiado<br>No terminal: `ls -la /opt/cmc/scripts/on-login.sh` |
| 282 | Verificar configuração PAM | Verificar se foi adicionado ao PAM session<br>No terminal: `cat /etc/pam.d/common-session | grep on-login.sh` |
| 283 | Testar execução no login | Fazer login e verificar se o script executa automaticamente<br>Verificar se os ícones do desktop ficam travados |
| 284 | Verificar logs de execução | Verificar se o script está sendo executado<br>No terminal: `journalctl | grep on-login` |

### `290-configura-logs.yml`

| ID | Teste | Como testar |
|---|---|---|
| 291 | Verificar configuração logrotate rsyslog | Verificar se a retenção foi alterada para 27 semanas<br>No terminal: `cat /etc/logrotate.d/rsyslog | grep "rotate 27"` |
| 292 | Verificar configuração logrotate SSSD | Verificar se a retenção SSSD foi configurada<br>No terminal: `cat /etc/logrotate.d/sssd-common | grep "rotate 27"` |
| 293 | Verificar rotação semanal | Verificar se os logs foram configurados para rotação semanal<br>No terminal: `cat /etc/logrotate.d/rsyslog | grep weekly` |
| 294 | Testar logrotate | Executar logrotate manualmente para testar<br>No terminal: `sudo logrotate -d /etc/logrotate.d/rsyslog` |

### `300-zoom-autoupdate.yml`

| ID | Teste | Como testar |
|---|---|---|
| 301 | Verificar script zoom-update | Verificar se o script foi criado<br>No terminal: `ls -la /opt/cmc/scripts/zoom-update.sh` |
| 302 | Verificar serviço zoom-update | Verificar se o serviço foi configurado<br>No terminal: `systemctl status zoom-update.service` |
| 303 | Verificar timer zoom-update | Verificar se o timer foi criado e habilitado<br>No terminal: `systemctl status zoom-update.timer` |
| 304 | Testar execução do script | Executar manualmente o script e verificar se atualiza o Zoom<br>No terminal: `sudo /opt/cmc/scripts/zoom-update.sh` |

### `990-versionamento.yml`

| ID | Teste | Como testar |
|---|---|---|
| 991 | Verificar arquivo de versão | Verificar se o arquivo de versão foi criado<br>No terminal: `cat /opt/cmc/version` |
| 992 | Verificar formato de versionamento | Verificar se segue o padrão SemVer ET-MAJOR.MINOR.PATCH<br>O conteúdo deve ser algo como "ET-6.1.5" |
| 993 | Verificar permissões do arquivo | Verificar se as permissões estão corretas<br>No terminal: `ls -la /opt/cmc/version` (deve ser 644) |

### `999-arquivos-modificados.yml`

| ID | Teste | Como testar |
|---|---|---|
| 996 | Verificar pasta de modificados | Verificar se a pasta foi criada<br>No terminal: `ls -la /opt/cmc/modificados/` |
| 997 | Verificar links simbólicos | Verificar se todos os links foram criados corretamente<br>No terminal: `ls -la /opt/cmc/modificados/ | grep -v "^d"` |
| 998 | Testar integridade dos links | Verificar se os links apontam para arquivos existentes<br>No terminal: `find /opt/cmc/modificados/ -type l -exec test ! -e {} \; -print` (deve retornar vazio) |
| 999 | Verificar documentação de modificações | Usar a pasta para auditorias e documentar todas as modificações feitas no sistema<br>Útil para rastreabilidade e troubleshooting |

