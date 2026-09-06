# Documentação do Projeto

Este arquivo serve como índice rápido da documentação do repositório. Ele cobre os guias da pasta `docs/`, a documentação principal da raiz do repositório e os materiais técnicos mais importantes da role `estacao`.

## Visão geral

- [README.md](/home/tss2025/workspace/Estacao-Trabalho-CMC/README.md): guia principal do repositório, com instalação, configuração em produção, variáveis, inventário e fluxo de desenvolvimento.
- [CHANGELOG.md](/home/tss2025/workspace/Estacao-Trabalho-CMC/CHANGELOG.md): histórico de mudanças relevantes do projeto.
- [docs/TESTING.md](/home/tss2025/workspace/Estacao-Trabalho-CMC/docs/TESTING.md): roteiro objetivo de testes, com pré-requisitos, sequência sugerida e critérios mínimos de validação.
- [docs/caderno-de-testes.md](/home/tss2025/workspace/Estacao-Trabalho-CMC/docs/caderno-de-testes.md): checklist operacional mais detalhado para execução dos testes e registro de evidências.
- [docs/migracao-mint22.md](/home/tss2025/workspace/Estacao-Trabalho-CMC/docs/migracao-mint22.md): contexto da migração para Linux Mint 22, impactos esperados e pontos que exigem validação.
- [roles/estacao/tasks/README.md](/home/tss2025/workspace/Estacao-Trabalho-CMC/roles/estacao/tasks/README.md): referência por task da role, útil para validação funcional e troubleshooting por etapa.
- [roles/estacao/ESTACAO-tasks-dependencies.md](/home/tss2025/workspace/Estacao-Trabalho-CMC/roles/estacao/ESTACAO-tasks-dependencies.md): mapa de dependências entre tasks, handlers, arquivos e ordem recomendada de teste.
- [roles/estacao/PR-CHANGELOG.md](/home/tss2025/workspace/Estacao-Trabalho-CMC/roles/estacao/PR-CHANGELOG.md): notas de contexto para a mudança em andamento na role, quando esse arquivo estiver sendo usado.

## Estrutura dos arquivos

```text
.
├── CHANGELOG.md
├── README.md
├── docs
│   ├── README.md
│   ├── TESTING.md
│   ├── caderno-de-testes.md
│   └── migracao-mint22.md
└── roles
    └── estacao
        ├── ESTACAO-tasks-dependencies.md
        ├── PR-CHANGELOG.md
        └── tasks
            └── README.md
```

## Ordem sugerida de leitura

1. Comece pelo [README.md](/home/tss2025/workspace/Estacao-Trabalho-CMC/README.md).
2. Use [docs/TESTING.md](/home/tss2025/workspace/Estacao-Trabalho-CMC/docs/TESTING.md) para planejar a validação.
3. Execute e registre os testes com apoio de [docs/caderno-de-testes.md](/home/tss2025/workspace/Estacao-Trabalho-CMC/docs/caderno-de-testes.md).
4. Consulte [docs/migracao-mint22.md](/home/tss2025/workspace/Estacao-Trabalho-CMC/docs/migracao-mint22.md) quando a mudança envolver compatibilidade com Mint 22.
5. Se precisar analisar o comportamento interno da role, use [roles/estacao/tasks/README.md](/home/tss2025/workspace/Estacao-Trabalho-CMC/roles/estacao/tasks/README.md) e [roles/estacao/ESTACAO-tasks-dependencies.md](/home/tss2025/workspace/Estacao-Trabalho-CMC/roles/estacao/ESTACAO-tasks-dependencies.md).
