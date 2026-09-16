# templates/ — Padrões oficiais BEM

A pasta `empresa/` É o molde da pasta de uma empresa — copie, renomeie os placeholders, preencha. O projeto mora DENTRO da empresa, igual na vida real.

```
empresa/                          ← vira <EMPRESA>/
  elo.env.example                 ← vira .<ticker>.elo.env (NUNCA vai pra git)
  project/                        ← vira <PROJETO>/
    AGENTS.md                     ← cérebro: aponta a doutrina BEM + Main da empresa
    CLAUDE.md                     ← uma linha: @AGENTS.md
    BRIEFING.md                   ← a tarefa de agora (estado vivo, sobrescreve) · NUNCA vai pra git
    HANDOFF.md                    ← estado da última sessão (nasce vazio) · NUNCA vai pra git
    TASKS.md                      ← links dos PAC/TASK do Notion + checklist
    CHATS.md                      ← links dos CHAT-NN (memória no Espírito)
    .claude/agents/agente.md      ← agente híbrido: gancho local, identidade no PROMPT-NN
```

A pasta `empresa/agente/` é o molde de **pasta de agente**, usado pelo `bem-novo-agente` (na raiz deste repositório). Ele copia o molde, troca os marcadores, inicia o git em `main` e escreve um `PRIMEIROS-PASSOS.md` com o que falta registrar no Notion. A norma que o molde cumpre está em `../AGENTES.md`.

```
empresa/agente/                   ← vira <ticker>-<area>/
  AGENTS.md                       ← quem é o agente, as leis, como ele organiza tarefa
  CLAUDE.md                       ← uma linha: @AGENTS.md
  BRIEFING.md  HANDOFF.md         ← texto de sessão, fora do git
  TASKS.md     CHATS.md           ← rascunho da fila e os CHAT-NN
  .gitignore                      ← protege segredo, dado de pessoa e texto de sessão
  .claude/skills/                 ← procedimento repetível
  scripts/README.md               ← o que é perene e o que é descartável
```

**Fora do template (por doutrina):** ADR/decisões e runbooks vivem nos Chats (Notion); PRD = PAC no Notion. Documentação de projeto mora no Espírito, não em arquivo solto.

**Briefing e handoff moram no disco, não no repo.** São texto de sessão com IA: o
`.gitignore` do kit os ignora e o registro durável vai pro CHAT do Notion. Os dois
arquivos aqui em `templates/` são molde vazio, por isso continuam versionados.
Ver `../README.md` → "Texto de sessão com IA nunca vai pro git".

## Pendente
Template de **SKILL.md** (Agent Skills specification, agentskills.io) — entra quando a spec for adotada pros PROMPTs Skill.
