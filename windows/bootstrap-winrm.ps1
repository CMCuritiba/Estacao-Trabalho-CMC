#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Configura o WinRM para permitir gerenciamento remoto via Ansible.

.DESCRIPTION
    Este script deve ser executado uma única vez em cada estação Windows,
    antes do primeiro uso do playbook Ansible. Ele realiza:
      - Habilitação do WinRM (Windows Remote Management)
      - Configuração do transporte CredSSP (necessário antes do ingresso no AD)
      - Abertura da regra de firewall para a porta 5985 (HTTP) ou 5986 (HTTPS)
    Após o ingresso no domínio, o transporte pode ser migrado para Kerberos,
    atualizando ansible_winrm_transport em group_vars/windows.yml.

.PARAMETER UseHTTPS
    Configura listener HTTPS na porta 5986 em vez de HTTP (5985).
    Requer um certificado SSL válido instalado na máquina.

.PARAMETER CertThumbprint
    Thumbprint do certificado SSL a ser usado no listener HTTPS.
    Obrigatório quando -UseHTTPS é especificado.

.EXAMPLE
    # Configuração básica com HTTP (para bootstrap inicial)
    powershell -ExecutionPolicy Bypass -File bootstrap-winrm.ps1

.EXAMPLE
    # Configuração com HTTPS (recomendada para produção)
    powershell -ExecutionPolicy Bypass -File bootstrap-winrm.ps1 -UseHTTPS -CertThumbprint "ABCDEF1234..."
#>

[CmdletBinding()]
param(
    [switch]$UseHTTPS,
    [string]$CertThumbprint
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Valida pré-condição para HTTPS
if ($UseHTTPS -and -not $CertThumbprint) {
    Write-Error "Para HTTPS, forneça -CertThumbprint com o thumbprint do certificado SSL."
}

Write-Host "==> Habilitando WinRM..." -ForegroundColor Cyan
winrm quickconfig -quiet -force

Write-Host "==> Configurando parâmetros do serviço WinRM..." -ForegroundColor Cyan
# Desabilita texto não-cifrado; exige negociação de protocolo
Set-WSManInstance -ResourceURI winrm/config/service -ValueSet @{
    AllowUnencrypted             = $false
    MaxConcurrentOperationsPerUser = 100
}

# Desabilita autenticação básica (insegura); habilita Kerberos, Negotiate e CredSSP
Set-WSManInstance -ResourceURI winrm/config/service/auth -ValueSet @{
    Basic     = $false
    Kerberos  = $true
    Negotiate = $true
    CredSSP   = $true
}

# Aumenta o limite de memória por shell para execução de scripts mais pesados
Set-WSManInstance -ResourceURI winrm/config/winrs -ValueSet @{
    MaxMemoryPerShellMB = 1024
}

Write-Host "==> Habilitando CredSSP no servidor (necessário antes do ingresso no AD)..." -ForegroundColor Cyan
Enable-WSManCredSSP -Role Server -Force | Out-Null

# Abre firewall somente nas redes de domínio e privada (não pública)
Write-Host "==> Configurando regra de firewall para WinRM HTTP (porta 5985)..." -ForegroundColor Cyan
$nomeRegra = "Ansible-WinRM-HTTP-In"
$regraExistente = Get-NetFirewallRule -Name $nomeRegra -ErrorAction SilentlyContinue
if (-not $regraExistente) {
    New-NetFirewallRule `
        -Name        $nomeRegra `
        -DisplayName "Ansible WinRM (HTTP 5985)" `
        -Direction   Inbound `
        -Protocol    TCP `
        -LocalPort   5985 `
        -Action      Allow `
        -Profile     Domain, Private `
        | Out-Null
    Write-Host "    Regra de firewall criada." -ForegroundColor Green
}
else {
    Write-Host "    Regra de firewall já existe, ignorando." -ForegroundColor Yellow
}

# Configuração opcional de HTTPS
if ($UseHTTPS) {
    Write-Host "==> Configurando listener HTTPS (porta 5986)..." -ForegroundColor Cyan
    $listenerExistente = Get-WSManInstance -ResourceURI winrm/config/listener `
        -SelectorSet @{ Address = '*'; Transport = 'HTTPS' } -ErrorAction SilentlyContinue
    if (-not $listenerExistente) {
        New-WSManInstance -ResourceURI winrm/config/listener `
            -SelectorSet @{ Address = '*'; Transport = 'HTTPS' } `
            -ValueSet @{ CertificateThumbprint = $CertThumbprint } | Out-Null
    }
    New-NetFirewallRule `
        -Name        "Ansible-WinRM-HTTPS-In" `
        -DisplayName "Ansible WinRM (HTTPS 5986)" `
        -Direction   Inbound `
        -Protocol    TCP `
        -LocalPort   5986 `
        -Action      Allow `
        -Profile     Domain, Private `
        -ErrorAction SilentlyContinue | Out-Null
}

Write-Host "==> Reiniciando serviço WinRM para aplicar configurações..." -ForegroundColor Cyan
Restart-Service WinRM -Force

Write-Host ""
Write-Host "WinRM configurado com sucesso." -ForegroundColor Green
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor White
Write-Host "  1. Adicione esta estação ao grupo [windows] em inventory/inventory.yml" -ForegroundColor Gray
Write-Host "  2. Preencha inventory/group_vars/windows.yml com os dados de conexão" -ForegroundColor Gray
Write-Host "  3. Teste: ansible windows -m win_ping -i inventory/inventory.yml" -ForegroundColor Gray
Write-Host "  4. Execute: ansible-playbook -i inventory/inventory.yml playbook-windows.yml --ask-vault-pass" -ForegroundColor Gray
