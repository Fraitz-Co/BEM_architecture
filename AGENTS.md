# AGENTS.md — BEM (Base Estrutural Multi-usuária)

> Você é um **Corpo** (uma LLM/agente) entrando num território sob a arquitetura BEM.
> Este arquivo é seu ponto de partida — leia-o primeiro, depois o `README.md` (a doutrina completa).
> A BEM é uma **arquitetura para você assimilar**: separa **o que você É** (mente durável no Notion)
> do **que você USA pra agir** (chaves na Alma). Você é descartável; a estrutura é durável.
> Este repo é genérico: os identificadores concretos (empresa, ticker, links) vivem no seu Notion privado.

## O contrato em 6 linhas
1. **Vault-first:** você NUNCA pede credencial ao humano. Toda chave vive na **Alma** (vault de segredos), aberta pelo **Elo** (`.<ticker>.elo.env` na raiz do território).
2. **Leia por NOME:** autentique no vault e leia o segredo pelo **nome exato** do catálogo (AGENTS.md da empresa + base de Credenciais no Notion). Nunca varra/liste o vault — muitos classificadores bloqueiam e é anti-padrão; busca por nome exato sempre passa.
3. **Notion é a fonte da verdade.** Prompts, Chats, Agentes e Tasks vivem lá. Registre o que fez ao terminar.
4. **Elo nunca em git/Notion/chat.** Antes de tornar um repo público, faça scan de segredos.
5. **Nunca improvise processo:** procure a **Skill**; achou → siga à risca; não achou → crie a Skill ANTES de executar.
6. **Nunca crie página crua no Notion:** use sempre o template padrão da base (com ícone) e preencha todas as propriedades/relações.

## Como abrir a Alma (vault-first — resumo operacional, exemplo Infisical)
- **Elo:** `.<ticker>.elo.env` na raiz do território (`INFISICAL_CLIENT_ID` / `_SECRET` / `_PROJECT_ID` + env).
- **Auth:** `POST https://app.infisical.com/api/v1/auth/universal-auth/login` → `accessToken`.
- **Ler 1 segredo:** `GET /api/v3/secrets/raw/<NOME>?workspaceId=$INFISICAL_PROJECT_ID&environment=<env>`.
- **Elo multi-bloco** (território que abre mais de uma Alma): **selecione o bloco pelo ticker**; NÃO faça `source` cru. Ver `README.md` → "Elo multi-bloco".

## Mapa do repo
- `README.md` — a doutrina completa: os 4 planos (Espírito/Alma/Elo/Corpo), SIM (Main/Skill/Information), quarteto (Prompts/Chats/Agentes/Tasks), multi-elo, taxonomia de chaves, segurança.
- `templates/empresa/` — o kit que cada projeto copia: `AGENTS.md`, `CLAUDE.md`, `BRIEFING.md`, `TASKS.md`, `CHATS.md`, `.claude/agents/`, e `elo.env.example`.
- `bem-doctor.sh` — checagem de saúde (elos/kits/espelhos).

## Convenções
- IDs por `unique_id` **nas propriedades** do Notion (`PROMPT-NN`, `CHAT-NN`, `IA-N`), referenciados na conversa — **não no título**.
- Tipos de prompt (SIM): **Main** (constituição) · **Skill** (procedimento) · **Information** (contexto).
- Git por projeto; pastas-pai (holding/raiz) não versionam — estrutura do pai é governança, não código.

---
*Doutrina canônica e viva: **Information — Arquitetura BEM** → https://fraitz.notion.site/PROMPT-19-Information-Arquitetura-BEM-Base-Estrutural-Multi-usu-rio-3795faf99abc81549d5cd3ffcc7da1d3 . Este repo é o espelho público e genérico — followthelink.*
