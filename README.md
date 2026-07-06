# BEM — Base Estrutural Multi-usuário

> Separação radical entre **o que você É** e **o que você USA pra agir**. A mente durável vive no Notion; o corpo (a LLM) é descartável. Infra é mínima — o valor é estrutura, curadoria e expertise.

Doutrina canônica: uma página **Information** no seu Notion (a "Arquitetura BEM"). Este repo é o template/arquivos genéricos — os identificadores concretos (nomes de empresa, tickers, links) vivem no seu Notion privado, nunca aqui.

## Os 4 planos
- **Espírito** — Notion (a mente/herança) + Sistema Mental (banco, git, CDN/DNS, automação).
- **Alma** — vault de segredos (ex.: Infisical) com as chaves. Uma por empresa. **Spin-off/subsidiária PODE ter Alma própria**; quando tem, o pai a alcança por um bloco extra no Elo (ver "Elo multi-bloco") ou por uma chave de visitante dedicada (ver "Multi-elo"). Um spin-off leve, sem cofre próprio, também pode simplesmente usar a Alma do pai — é escolha, não regra.
- **Elo** — `.<ticker>.elo.env` na raiz da empresa, abre a Alma. Nunca em git.
- **Corpo** — a LLM (denso = tem mãos no PC; sutil = só nuvem). Descartável.

## SIM — tipos de Prompt
**Main** (constituição) · **Skill** (procedimento) · **Information** (contexto). Skills vivem no Espírito (Notion) + repo (`SKILL.md`), nunca soltas no projeto.

## Quarteto parada dura
Prompts · Chats · Agentes · Tasks (as 4 bases do Notion).

## Estrutura de pastas

```
Projetos/
  README.md                      ← aponta a doutrina (a Information de Arquitetura).
  <EMPRESA>/
    .<ticker>.elo.env            ← Elo → Alma (fora de git)
    <PROJETO>/
      AGENTS.md                  ← cérebro: aponta a doutrina (método) + Main da empresa
      CLAUDE.md                  ← uma linha: @AGENTS.md (Claude Code não lê AGENTS.md nativo)
      BRIEFING.md                ← a tarefa de agora (estado vivo, sobrescreve)
      TASKS.md                   ← links dos PAC/TASK do Notion + checklist da sessão
      CHATS.md                   ← links dos CHAT-NN do projeto (memória no Espírito)
      [código]
      .mcp.json   assets/(brand/)   ← só sob demanda
```

**Fora:** `.bem/`, `.windsurfrules`/`.cursorrules` (AGENTS.md cobre; Windsurf/Cursor leem nativo), `decisions/` e `runbooks/` (vivem nos Chats), `docs/prds/` (PRD = PAC no Notion). Design system: referência vai no Espírito ou `assets/brand/`; se for biblioteca compartilhada, é projeto próprio.

## Modelo de AGENTS.md (enxuto)

```markdown
# AGENTS.md — <PROJETO>

Empresa: <EMPRESA>
Elo: ../.<ticker>.elo.env → vault <TICKER>-ALMA

## Como operar aqui
- Método (BEM): <link da doutrina de Arquitetura no seu Notion>
- Constituição (quem eu sou): <Main da empresa: PROMPT-NN> → <link>

## Antes de agir, sempre
1. BRIEFING.md   2. TASKS.md   3. CHATS.md

Regra: nunca exponho segredo; abro a Alma pelo Elo; registro no Espírito ao terminar.
```

## Codex CLI no WSL: Elo por território

No WSL, cada território empresarial deve ser aberto pelo wrapper local correto do Codex CLI. O objetivo é impedir que um Corpo/CLI entre em um projeto usando Elo/Alma de outra empresa.

Estrutura operacional:

```text
~/Projetos/
  <HOLDING-A>/
    .<ticker-a>.elo.env
  <HOLDING-B>/
    .<ticker-b>.elo.env
    <SPINOFF-1>/
      .<ticker-spinoff-1>.elo.env
    <SPINOFF-2>/
      .<ticker-spinoff-2>.elo.env
```

Wrappers locais:

```text
~/.local/bin/codex-<ticker-a>
~/.local/bin/codex-<ticker-b>
~/.local/bin/codex-<ticker-spinoff-1>
~/.local/bin/codex-<ticker-spinoff-2>
```

Regras de território:

```text
codex-<ticker-a>          -> só dentro de ~/Projetos/<HOLDING-A>
codex-<ticker-b>          -> só dentro de ~/Projetos/<HOLDING-B>
codex-<ticker-spinoff-1>  -> só dentro de ~/Projetos/<HOLDING-B>/<SPINOFF-1>
codex-<ticker-spinoff-2>  -> só dentro de ~/Projetos/<HOLDING-B>/<SPINOFF-2>
```

Cada wrapper deve:

1. Verificar se o usuário está dentro do território correto.
2. Bloquear execução em território errado.
3. Procurar o `.elo.env` correspondente na raiz do território.
4. Dar erro claro se o Elo não existir.
5. Carregar o Elo (ver ressalva em "Elo multi-bloco"): Elo single-bloco → `set -a`, `source "$ELO_FILE"`, `set +a`; Elo multi-bloco → extrair só o bloco do território (nunca `source` cru).
6. Executar o Codex CLI com `exec codex "$@"`.

Template de wrapper:

```bash
#!/usr/bin/env bash
set -euo pipefail

TERRITORY="$HOME/Projetos/NOME-DO-TERRITORIO"
ELO_FILE="$TERRITORY/.nome-do-territorio.elo.env"

case "$PWD" in
  "$TERRITORY"|"$TERRITORY"/*) ;;
  *)
    echo "Erro: este comando só pode rodar dentro de $TERRITORY" >&2
    echo "Diretório atual: $PWD" >&2
    exit 1
    ;;
esac

if [ ! -f "$ELO_FILE" ]; then
  echo "Erro: Elo não encontrado em $ELO_FILE" >&2
  exit 1
fi

set -a
source "$ELO_FILE"
set +a

exec codex "$@"
```

`~/.local/bin` precisa estar no PATH:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Cada wrapper precisa ter permissão de execução:

```bash
chmod +x ~/.local/bin/NOME-DO-COMANDO
```

Este padrão evita replicar secrets por projeto, mantém o Elo centralizado na raiz do território, reduz risco de vazamento em Git e impede erro humano ao abrir Codex com credencial errada.

### Elo multi-bloco — um território que abre mais de uma Alma

Um Elo pode ter **mais de um bloco** quando um território (holding) precisa abrir a própria Alma **e** a de spin-offs/subsidiárias aninhados. O primeiro bloco é a Alma do próprio território (dono); os seguintes são as Almas que ele também alcança. Cada bloco começa por uma linha-rótulo com o ticker, seguida das vars:

```text
<TICKER-PAI>
INFISICAL_CLIENT_ID=...
INFISICAL_CLIENT_SECRET=...
INFISICAL_PROJECT_ID=...
INFISICAL_API_URL=https://app.infisical.com
INFISICAL_ENVIRONMENT=prod

<TICKER-FILHO>:
INFISICAL_CLIENT_ID=...
INFISICAL_CLIENT_SECRET=...
INFISICAL_PROJECT_ID=...
INFISICAL_API_URL=https://app.infisical.com
INFISICAL_ENVIRONMENT=prod
```

**Ressalva dura:** um Elo multi-bloco **NÃO** pode ser consumido por `source` cru — as vars `INFISICAL_*` se repetem e só o último bloco sobra (abriria a Alma errada). Consumo correto = um **leitor que SELECIONA o bloco pelo ticker** (é exatamente assim que um Corpo/IA opera vault-first: escolhe o bloco, autentica, lê o segredo por NOME). O wrapper de território, diante de um Elo multi-bloco, deve extrair só o bloco do território — nunca `source` o arquivo inteiro.

**Alternativa single-bloco:** manter um Elo por Alma (um `.<ticker>.elo.env` por território, inclusive nos subterritórios aninhados) e deixar o aninhamento de pastas resolver quem abre o quê. O spin-off aninhado (`<HOLDING>/<SPINOFF>/.<ticker-spinoff>.elo.env`) tem seu próprio Elo single-bloco; o Elo do pai pode, opcionalmente, carregar o bloco do filho para alcançá-lo de fora.

## Agentes — híbrido Corpo + Espírito
- Agente permanente = arquivo `.md` mínimo na pasta da ferramenta (`.claude/agents/`, `.gemini/agents/`): nome, ferramentas e "missão: ver PROMPT-NN".
- A identidade completa (skills, tom, instruções) vive no Espírito (Notion, PROMPT-NN). O `.md` local é só o gancho que a ferramenta exige.
- Subagente/teammate nasce com o `.md` como system prompt — já nasce sendo o agente. Morre ao fim da tarefa; só o relatório fica.

## Agentes — o ofício é compartilhado, a obra é da empresa
Um agente é um **ofício** (dba, copywriter, devops…), não o cargo de uma empresa. O ofício é universal; o que muda entre projetos é o **contexto** (ferramentas, voz da marca, base de código, aprendizados de campo). Separar errado gera um de dois males: **poluição de contexto** (instrução de um projeto vazando no outro, degradando a LLM) ou **duplicação burra** (mesmo ofício copiado N vezes, manutenção em N lugares e um sempre desatualiza).

Três níveis de fronteira:
- **Por empresa/holding (holdings diferentes):** squads separadas, bases de Prompts separadas (Notion diferente). O ofício renasce em cada casa com a stack daquela casa. O devops de uma holding e o de outra são agentes distintos — ferramentas, vault e convenções diferentes.
- **Entre spin-offs da mesma holding:** o agente-ofício é **um só, compartilhado**. O que difere — voz da marca, design system, aprendizados do projeto — entra como **Skill / Information carregada por projeto**, nunca como agente novo. O copywriter é um; cada marca é uma Skill de voz diferente. Mesmo agente, skill diferente. A skill que não é do projeto não carrega, logo não polui.
- **Papel que só existe num projeto** (ex.: um integrador de uma ferramenta específica daquele projeto): nasce por projeto e vive ali.

**Regra de bolso:** o ofício é do pedreiro, a parede é da empresa. Muda só a obra (ferramenta, voz, base) → mesma mão, material diferente: **mesmo agente, skill por projeto**. Muda o ofício inteiro → mão nova: **agente próprio**. O **Main carrega só o ofício**; voz, design system e aprendizados de campo são Skill/Information por projeto — jamais colados dentro do Main (poluem todo projeto que usar aquele agente).

## Como um projeto nasce — o trio de planejamento
Todo `AGENTS.md` de projeto compõe três camadas: a **Information do projeto** (o BRIEFING) + a **doutrina BEM** (o método) + o **Main do orquestrador** da empresa.

A partir daí, todo projeto começa pelo trio de planejamento, antes de qualquer execução:
- **gestor-de-projetos** — quebra o trabalho em tasks, preenche o briefing, escreve os prompts bons pros executores e levanta as TASKs no Notion. Dono da decomposição.
- **arquiteto-solucoes** — fundo em ferramentas, automações, bases do Notion e programação. Decide QUE ferramenta/integração realiza cada etapa (construir vs contratar, custo, ponto de falha). Dono da solução técnica.
- Os dois juntos transformam briefing → plano de tasks executável, validado pelo dono/decisor.
- **agent-builder** — a partir do plano, cria os prompts dos executores e os próprios agentes, na base da empresa certa. Dono da fábrica de agentes.

Depois os **executores** rodam as tasks — cada um carregando só as Skills daquele projeto (algumas sim, outras não). Ofício compartilhado, contexto por projeto.

## Multi-elo — pessoas carregam chaves, não cofres
- Alma = da empresa (uma por projeto). Elo = da pessoa ou máquina (um por cabeça). Todos os elos abrem a mesma Alma, cada um com seu nível.
- Onboarding: criar identidade no vault → token → `.<ticker>.elo.env` na máquina da pessoa, entregue por canal seguro (nunca git).
- Offboarding: revogar o elo da pessoa; a Alma fica intacta pra quem ficou.
- Permissões por elo: dev abre só ambiente dev; chaves pesadas (service_role) restritas a quem precisa.
- **Acesso se CONCEDE à identidade, nunca se COPIA a credencial.** Dentro da mesma organização de vault: a identidade de máquina mora na org, e cada vault só adiciona o nome dela na lista de acesso (uma chave, N portas, cada porta com seu papel). Cofre não guarda chave de outro cofre.
- **Entre organizações (prédios separados): o dono emite chave de visitante DEDICADA.** Identidade criada na org do dono, exclusiva pro visitante externo, escopo mínimo. O visitante guarda essa credencial no vault DELE — isso é o elo dele pro prédio alheio, não é cópia. O pecado é copiar identidade compartilhada (auditoria cega, revogação em dominó); chave dedicada preserva quem-fez-o-quê e revoga com um clique.

## Taxonomia de chaves
- **Chave pública** (anon / `NEXT_PUBLIC_*`): pode aparecer no navegador; a proteção real é RLS/regras do banco.
- **Chave privada** (service_role, API keys pagas): só no servidor, nunca no cliente.
- **Usuário final NUNCA recebe chave**: cliente → backend (chave mora aqui) → API externa. Quem distribui chave no front paga a festa dos outros.

## Espelhamento de estrutura
- **Git por projeto:** cada projeto tem seu próprio repo; pastas-pai (holding, raiz) NÃO versionam. Estrutura do pai é governança, não código.
- Governança (kit BEM: AGENTS/BRIEFING/CHATS/TASKS/CLAUDE.md) espelha entre máquinas e locais.
- Código de projeto NÃO espelha — vive onde roda. Reprodutibilidade vem de lockfile + Docker, não de cópia de pasta.
- `docker-compose.yml` e `Dockerfile` são Corpo e VÃO pro git; `.env` e elo jamais.
- **Ritual de sincronização dos espelhos:** doutrina só muda via agente, e o agente atualiza TODOS os espelhos na mesma tacada (Notion → README local → GitHub). Automação até doer.

## Segurança
Elo nunca em git/Notion/chat. Vault é cofre de verdade. Scan de segredos antes de tornar repo público.

**Vault-first — o Corpo nunca pede credencial.** Todo Corpo vai à Alma ANTES de pedir qualquer segredo ao humano: Elo → autentica no vault → lê o segredo pelo NOME no catálogo (mantido no AGENTS.md da empresa + base-espelho no Notion de Credenciais). Só fala de credencial com o humano quando o NOME não está no catálogo — e aí pede só o NOME (nunca o valor), uma vez, e fixa. Pedir ao humano credencial que já vive na Alma é falha grave.
*Nota de fábrica:* alguns classificadores de segurança de LLM bloqueiam VARRER/listar o vault (anti-exfiltração) — por isso o catálogo de NOMES é a solução; busca por nome exato sempre passa, varredura não.

---
*Canônico: a Information de Arquitetura no seu Notion e este repo são espelhos. Este repo é genérico por design — nenhum identificador concreto (nome de empresa, ticker, link) mora aqui.*
