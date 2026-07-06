# templates/ — Padrões oficiais BEM

A pasta `empresa/` É o molde da pasta de uma empresa — copie, renomeie os placeholders, preencha. O projeto mora DENTRO da empresa, igual na vida real.

```
empresa/                          ← vira <EMPRESA>/
  elo.env.example                 ← vira .<ticker>.elo.env (NUNCA vai pra git)
  project/                        ← vira <PROJETO>/
    AGENTS.md                     ← cérebro: aponta a doutrina BEM + Main da empresa
    CLAUDE.md                     ← uma linha: @AGENTS.md
    BRIEFING.md                   ← a tarefa de agora (estado vivo, sobrescreve)
    TASKS.md                      ← links dos PAC/TASK do Notion + checklist
    CHATS.md                      ← links dos CHAT-NN (memória no Espírito)
    .claude/agents/agente.md      ← agente híbrido: gancho local, identidade no PROMPT-NN
```

**Fora do template (por doutrina):** ADR/decisões e runbooks vivem nos Chats (Notion); PRD = PAC no Notion. Documentação de projeto mora no Espírito, não em arquivo solto.

## Pendente
Template de **SKILL.md** (Agent Skills specification, agentskills.io) — entra quando a spec for adotada pros PROMPTs Skill.
