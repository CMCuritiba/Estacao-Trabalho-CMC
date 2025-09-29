# Guia de Testes - Estação de Trabalho CMC

Este documento descreve como executar testes para validar a configuração da estação de trabalho CMC.

Obs: Este guia foi feito com o agente de IA GitHub Copilot, e pode conter erros.
Favor revisar cuidadosamente antes de usar.

## Visão Geral

O processo de testes é dividido em duas partes:

1. **Testes Automatizados** - Executados via Molecule
2. **Testes Manuais** - Executados seguindo o caderno de testes

## Pré-requisitos

### Para Testes Automatizados
- Python 3.x
- Molecule
- Ansible
- Vagrant (para testes locais)
- VirtualBox (para testes locais)

### Para Testes Manuais
- Acesso à estação de trabalho configurada
- Usuário com privilégios administrativos
- Caderno de testes impresso ou em tela

## Executando Testes Automatizados

### 1. Configuração do Ambiente
```bash
# Instalar dependências
pip install molecule[vagrant] ansible

# Navegar para o diretório da role
cd roles/estacao/
```

### 2. Executar Todos os Testes
```bash
# Executar apenas verificação
molecule verify

# Executar converge + verify (configuração + teste)
molecule test
```

### 3. Executar Testes Específicos
```bash
# Executar apenas para tags específicas
molecule converge -- --tags "suporte,dns"
molecule verify
```

### 4. Interpretar Resultados
- ✅ **VERDE**: Teste passou
- ❌ **VERMELHO**: Teste falhou - verificar logs para detalhes
- ⚠️ **AMARELO**: Aviso - pode necessitar atenção

## Executando Testes Manuais

### 1. Preparação
- Abrir o arquivo `caderno-de-testes.md`
- Ter acesso à estação de trabalho
- Logar com usuário apropriado para cada teste

### 2. Processo de Execução
1. Seguir ordem numérica dos testes (001-075)
2. Executar comandos conforme instruções
3. Marcar resultado: ✅ (passou) ou ❌ (falhou)
4. Investigar falhas antes de continuar

### 3. Categorias de Teste
- **Usuários e Grupos** (001-003)
- **Pacotes** (004-008)
- **Configurações** (009-073)
- **Teste Integrado Final** (074-075)

## Estratégia de Testes

### 1. Testes de Desenvolvimento
Durante o desenvolvimento, execute:
```bash
# Teste rápido
molecule converge -- --diff
molecule verify

# Teste específico
molecule converge -- --tags "dns"
```

### 2. Testes de Validação
Antes de deploy em produção:
1. Execute todos os testes automatizados
2. Execute todos os testes manuais
3. Documente falhas e correções

### 3. Testes de Produção
Após instalação em estação nova:
1. Execute testes manuais críticos (001-010, 074-075)
2. Execute testes específicos conforme necessidade
3. Documente status final

## Solução de Problemas

### Testes Automatizados Falhando
1. Verificar se variáveis estão definidas corretamente
2. Conferir logs detalhados: `molecule verify -v`
3. Validar se a máquina virtual tem recursos suficientes
4. Verificar conectividade de rede

### Testes Manuais Falhando
1. Verificar se usuário tem permissões adequadas
2. Confirmar se estação foi configurada corretamente
3. Revisar logs do sistema: `/var/log/syslog`
4. Verificar status de serviços: `systemctl status <servico>`

## Interpretação de Resultados

### Status Geral
- **100% PASSOU**: Estação pronta para produção
- **90-99% PASSOU**: Investigar falhas pontuais
- **<90% PASSOU**: Não implantar, corrigir problemas

### Testes Críticos (não podem falhar)
- 001-003: Criação usuário suporte
- 027-031: Integração com AD
- 045-048: SSH funcionando
- 074-075: Teste integrado final

### Testes Opcionais (podem ser ignorados)
- Testes relacionados a hardware específico
- Funcionalidades não utilizadas na organização
- Configurações específicas de ambiente

## Relatórios

### Automated Test Report
Os testes automatizados geram relatório automático no terminal.

### Manual Test Report
Preencher no final do `caderno-de-testes.md`:
- Status da Estação: Aprovada/Reprovada
- Data do Teste
- Nome do Testador
- Versão Testada

## Manutenção dos Testes

### Adicionando Novos Testes Automatizados
1. Editar `roles/estacao/molecule/default/verify.yml`
2. Seguir padrão existente
3. Testar com `molecule verify`

### Adicionando Novos Testes Manuais
1. Editar `caderno-de-testes.md`
2. Seguir formato da tabela existente
3. Atribuir ID sequencial

### Atualizando Testes Existentes
1. Verificar impacto em outros testes
2. Atualizar documentação
3. Testar antes de commit

## Referências

- [Documentação Molecule](https://molecule.readthedocs.io/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Guia Vagrant](https://www.vagrantup.com/docs)
- `README.md` - Configuração geral do projeto
- `caderno-de-testes.md` - Testes manuais detalhados
