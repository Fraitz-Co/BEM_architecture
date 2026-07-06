# AGENTS.md — <PROJETO>

Empresa: <EMPRESA>
Elo: ../.<ticker>.elo.env → vault <TICKER>-ALMA

## Princípio da Alma — VAULT-FIRST (ler primeiro, vale sempre)
O Corpo NUNCA pede credencial ao humano. Toda credencial vive na Alma (vault <TICKER>-ALMA), aberta pelo Elo.
Antes de qualquer ação que precise de segredo, vou ao Vault PRIMEIRO e busco pelo NOME no catálogo
(seção "Segredos na Alma", abaixo). Só falo de credencial com o humano se o NOME não estiver no catálogo —
e aí peço só o NOME (nunca o valor), uma única vez, e fixo no catálogo pra nunca mais perguntar.
Pedir credencial que já vive na Alma é falha grave.

## Como operar aqui
- Método (BEM): <link da doutrina de Arquitetura BEM no seu Notion>
- Constituição (quem eu sou): <Main da empresa: PROMPT-NN> → <link>

## Antes de agir, sempre
1. BRIEFING.md — a tarefa de agora
2. TASKS.md — pacotes + tarefas + checklist
3. CHATS.md — memória das conversas no Notion

Regra: nunca exponho segredo; abro a Alma pelo Elo; registro no Espírito ao terminar.

## Codex CLI (facultativo)
Wrapper de território disponível: `codex-<ticker>` — carrega o Elo certo e bloqueia execução fora do território. Receita pra criar um wrapper novo: README do BEM_architecture, seção "Codex CLI no WSL: Elo por território".


## Segredos na Alma — CATÁLOGO (busca por NOME, nunca varrer)
Mecânica: auth `POST /api/v1/auth/universal-auth/login` → ler 1 segredo por nome exato em
`GET /api/v3/secrets/raw/<NOME>?workspaceId=$INFISICAL_PROJECT_ID&environment=$INFISICAL_ENVIRONMENT`.
Alguns classificadores de segurança de LLM BLOQUEIAM varrer/listar o vault em lote — por isso este catálogo existe.
Base-espelho no Notion: <link da base de Credenciais da empresa>.
- `<TICKER>_<SERVICO>` — <descrição de uso>
