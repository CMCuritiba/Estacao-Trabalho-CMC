# Guia de Contribuição

Bem-vindo(a) ao projeto Estação-Trabalho-CMC!

Este documento fornece diretrizes para garantir que suas contribuições sejam bem recebidas e incorporadas de forma eficiente ao projeto.

## Como Contribuir

Ao contribuir para este repositório, primeiro discuta a alteração que deseja fazer com os proprietários deste repositório antes de fazer uma alteração.

### Relatando Problemas (_Issues_)

Caso encontre um erro ou tenha uma sugestão de melhoria, siga estes passos ao abrir uma issue:

1. **Verifique se a issue já existe** para evitar duplicatas.
2. **Forneça um título claro e descritivo**.
3. **Explique o problema atual e como sua sugestão pode melhorá-lo**.
4. **Inclua detalhes do ambiente** (versão do sistema operacional, versão do software, etc.).
5. **Descreva os passos para reproduzir o problema**.
6. **Inclua logs ou prints** se relevante.

Procure se ater ao modelo de _issue_ fornecido e evite remover ou deixar em branco qualquer seção.

Algumas diretrizes gerais:

- Trabalhamos arduamente para garantir que os problemas sejam resolvidos em tempo hábil, mas, dependendo do impacto, pode demorar um pouco para investigar a causa raiz. Se o seu problema estiver bloqueando, um ping amigável no tópico de comentários pode ajudar a chamar a atenção do autor ou colaborador.
- As _issues_ devem ser usadas ​​para relatar problemas, solicitar um novo recurso ou discutir possíveis alterações antes da criação de um PR. Quando você cria uma nova _issue_, será carregado um modelo que o guiará na coleta e no fornecimento das informações que precisamos investigar.
- Se você encontrar uma _issue_ que resolva o problema que você está enfrentando, adicione suas próprias informações de reprodução ao problema existente em vez de criar um novo.

## Padrões de Código

- Siga a convenção de estilo estabelecida pelo projeto (ESLint, PEP8, etc.).
- Use indentacão consistente.
- Nomeie variáveis e funções de forma clara e sem abreviações excessivas.
- Escreva comentários explicativos quando necessário.

## Mensagens de Commit

Temos regras precisas sobre como nossas mensagens de commit do git podem ser formatadas. Isso leva a **mensagens mais legíveis** que são fáceis de seguir ao examinar o **histórico do projeto** e permite várias **automações** mágicas.

Nós utilizamos os [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) reforçados pelo [commitlint](https://github.com/conventional-changelog/commitlint) e o [commitzen](https://github.com/commitizen/cz-cli). Ative-os em sua cópia do repositório e escreva mensagens de commit claras e descritivas, no formato: `feat: adiciona funcionalidade X` ou `fix: corrige bug Y`.

Para exemplos e mais sobre este tópico, veja também:

- [Angular convention](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md)
- [Semantic Commit Messages](https://gist.github.com/joshbuchea/6f47e86d2510bce28f8e7f42ae84c716)

### Enviando Pull Requests (PRs)

Em geral, seguimos o [Github Flow](https://docs.github.com/en/get-started/using-github/github-flow#following-github-flow). Siga estas etapas ao enviar um PR:

1. **Fork o repositório** e clone localmente.
2. **Crie um novo branch** referenciando uma issue aberta (`feat/nome-da-feature` ou `fix/nome-do-fix`).
3. **Siga as boas práticas de commit** (consulte a seção [Mensagens de Commit](#mensagens-de-commit)).
4. **Garanta que seu código segue os padrões do projeto** (consulte a seção [Padrões de Código](#padrões-de-código)).
5. **Adicione testes** caso o código adicionado exija testes.
6. **Execute os testes antes de enviar o PR**.
7. **Faça _lint_** do seu código.
8. **Adicione documentação** caso sua contribuição exija.
9. **Faça _bump_ da versão** nos arquivos apropriados, no README.md e no CHANGELOG.md para a nova versão que este Pull Request representaria. O esquema de versionamento que usamos é [SemVer](http://semver.org/) e [Keep a Changelog](http://keepachangelog.com/).
10. **Descreva claramente o que sua PR faz** e referencie issues relacionadas.

Em geral, os PRs devem:

- Apenas corrigir/adicionar a funcionalidade em questão OU resolver problemas generalizados de espaço em branco/estilo, não ambos.
- Adicionar testes unitários ou de integração para funcionalidades corrigidas ou alteradas (se já existir um conjunto de testes).
- Tratar um único assunto com o menor número possível de linhas alteradas.
- Incluir documentação no repositório ou em nosso site de documentção.
- Serem acompanhados de um modelo completo de Pull Request (carregado automaticamente quando um PR é criado).

## Revisão e Aprovação

Todas as contribuições passarão por revisão antes de se fazer o _merge_ ao código principal. A revisão levará em conta:

- Clareza e qualidade do código.
- Adesão às diretrizes do projeto.
- Impacto da mudança no sistema.

Se ajustes forem necessários, os revisores farão sugestões e solicitarão alterações antes da aprovação final.

## Código de Conduta

Nós levamos a sério nossa comunidade de código aberto e mantemos altos padrões de comunicação, tanto para nós quanto para outros colaboradores. Ao participar e contribuir para este projeto, você concorda em respeitar nosso [Código de Conduta](./CODE_OF_CONDUCT.md).

## Quaisquer contribuições que você fizer estarão sob a licença de software GPL

Resumindo, quando você submete alterações de código, entende-se que seus envios estão sob a mesma [licença GPL-3.0-ou-later](https://choosealicense.com/licenses/gpl-3.0/) que cobre o projeto. Sinta-se à vontade para entrar em contato com os mantenedores se isso for uma preocupação.

## Canais de Comunicação

Para tirar dúvidas ou discutir ideias, use os seguintes canais:

- Issues no GitHub para problemas e sugestões.
- Pull Requests para discutir mudanças no código.
- [Email](mailto:suporte@cmc.pr.gov.br).

Agradecemos sua contribuição para tornar este projeto melhor!
