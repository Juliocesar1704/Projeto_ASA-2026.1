📋 Plano de Gestão Ágil do Projeto

👥 Equipe

Rodízio de Liderança

Sprint| Líder Responsável

Sprint 01| Júlio

Sprint 02| João

Sprint 03| Jonas

Sprint 04| Alicia

Sprint 05| João P.

«O líder da sprint será responsável por conduzir as cerimônias, acompanhar o progresso das tarefas e garantir a atualização do quadro Kanban.»

---

🚀 Metodologia de Trabalho

O projeto utilizará a metodologia Scrum com apoio de um quadro Kanban para gerenciamento das atividades.

Fluxo de Desenvolvimento

Issue → Branch Dev → Validação → Main

Regras de Branches

- A branch "main" conterá apenas funcionalidades concluídas e validadas.
- O desenvolvimento ocorrerá na branch "dev".
- Toda nova funcionalidade deverá iniciar pela criação de uma Issue.
- Após a criação da Issue, será criada uma branch específica para o desenvolvimento.
- Somente após testes e validação o código poderá ser integrado à "main".

---

📅 Cerimônias Scrum

1. Product Backlog

Nesta etapa serão definidas todas as atividades necessárias para o projeto.

Atividades

- Levantar requisitos.
- Definir funcionalidades.
- Criar tarefas.
- Cadastrar as tarefas no quadro Kanban.

---

2. Sprint Planning Meeting

Objetivo

Planejar as atividades que serão executadas durante a sprint.

Duração da Sprint

- 2 semanas (15 dias).

Sprint 01

Durante a Sprint Planning serão realizadas as seguintes atividades:

- Selecionar tarefas do Product Backlog.
- Garantir que as atividades caibam dentro dos 15 dias da sprint.
- Organizar as tarefas no quadro Kanban.
- Iniciar a geração dos produtos e serviços do ISP.

---

3. Sprint Backlog

Conjunto de tarefas selecionadas para execução durante a sprint atual.

Todas as atividades escolhidas na Sprint Planning serão registradas e acompanhadas através do quadro Kanban.

---

4. Daily Scrum

Reunião rápida para acompanhamento do progresso da equipe.

Perguntas Respondidas

- O que fizemos?
- Como fizemos?
- Quais dificuldades encontramos?
- Como superamos essas dificuldades?
- O que faremos até a próxima reunião?

---

5. Sprint Review

Objetivo

Apresentar os resultados obtidos ao final da sprint.

Avaliação

- O que funcionou bem.
- O que não funcionou.
- O que foi concluído.
- O que permanece pendente.
- Feedback dos participantes.

---

6. Sprint Retrospectiva

Objetivo

Avaliar o processo de trabalho da equipe e identificar melhorias para a próxima sprint.

Discussão

- Pontos positivos.
- Pontos negativos.
- Oportunidades de melhoria.
- Ações para a próxima sprint.

---

📌 Fluxo Kanban

A Fazer| Em Andamento| Em Validação| Concluído
Tarefas planejadas| Tarefas em execução| Testes e validações| Entregas aprovadas

---

🔄 Fluxo de Trabalho Resumido

flowchart LR
    A[Product Backlog] --> B[Sprint Planning]
    B --> C[Sprint Backlog]
    C --> D[Daily Scrum]
    D --> E[Desenvolvimento]
    E --> F[Sprint Review]
    F --> G[Sprint Retrospectiva]
    G --> B

---

🌳 Estratégia de Branches

gitGraph
    commit id: "Main"
    branch dev
    checkout dev
    commit id: "Nova Feature"
    commit id: "Testes"
    checkout main
    merge dev

Fluxo de Desenvolvimento

1. Criar uma Issue.
2. Criar uma branch baseada na "dev".
3. Desenvolver a funcionalidade.
4. Realizar testes e validações.
5. Mesclar na branch "dev".
6. Após aprovação, mesclar na branch "main".

Issue → Branch de Desenvolvimento → Dev → Validação → Main
