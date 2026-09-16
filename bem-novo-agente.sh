#!/usr/bin/env bash
# bem-novo-agente: cria a pasta de um agente novo já no padrão da cartilha (AGENTES.md).
#
# Uso, de dentro da pasta do território:
#   bem-novo-agente <pasta> "<Nome do agente>" "<área>" [porta-cdp]
# Exemplo:
#   bem-novo-agente xqmt3-tech "Ada" "tecnologia" 9225
#
# O que ele faz: copia o molde, troca os marcadores, inicia o git em main e escreve
# PRIMEIROS-PASSOS.md com o que falta fazer no Notion.
# O que ele NÃO faz: tocar em segredo. Ele só confere que o Elo do território existe.

set -euo pipefail

PASTA="${1:-}"
AGENTE="${2:-}"
AREA="${3:-}"
PORTA="${4:-}"

if [[ -z "$PASTA" || -z "$AGENTE" || -z "$AREA" ]]; then
  cat >&2 <<'AJUDA'
uso: bem-novo-agente <pasta> "<Nome do agente>" "<área>" [porta-cdp]

  pasta   nome da pasta, minúsculo com hífen, começando pelo ticker: xqmt3-tech
  nome    o nome próprio do agente, como ele se apresenta: "Ada"
  área    a área da empresa que ele cuida: "tecnologia"
  porta   opcional, a porta de depuração do navegador dele: 9225

A cartilha completa está em AGENTES.md, no repositório do BEM.
AJUDA
  exit 2
fi

if [[ ! "$PASTA" =~ ^[a-z0-9]+-[a-z0-9-]+$ ]]; then
  echo "erro: a pasta deve ser minúscula com hífen e começar pelo ticker, tipo xqmt3-tech" >&2
  exit 2
fi

if [[ -e "$PASTA" ]]; then
  echo "erro: já existe '$PASTA' aqui. Agente não se sobrescreve." >&2
  exit 1
fi

TICKER_MIN="${PASTA%%-*}"
TICKER="$(printf '%s' "$TICKER_MIN" | tr '[:lower:]' '[:upper:]')"

# O molde vive junto deste script, no repositório do BEM.
AQUI="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MOLDE="$AQUI/templates/empresa/agente"
if [[ ! -d "$MOLDE" ]]; then
  echo "erro: não achei o molde em $MOLDE" >&2
  exit 1
fi

# O Elo do território: procura subindo a árvore, sem ler o conteúdo.
ELO=""
dir="$PWD"
while [[ "$dir" != "/" ]]; do
  for candidato in "$dir"/.*.elo.env; do
    [[ -e "$candidato" ]] || continue
    ELO="$candidato"
    break 2
  done
  dir="$(dirname "$dir")"
done

if [[ -z "$ELO" ]]; then
  echo "erro: nenhum Elo (.<ticker>.elo.env) encontrado subindo a partir daqui." >&2
  echo "      Rode de dentro da pasta do território. Sem Elo, o agente não abre o cofre." >&2
  exit 1
fi

# Caminho do Elo relativo à pasta nova, que é como o AGENTS.md vai citá-lo.
ELO_REL="$(python3 - "$ELO" "$PWD/$PASTA" <<'PY'
import os, sys
print(os.path.relpath(sys.argv[1], sys.argv[2]))
PY
)"

PORTA_TXT="${PORTA:-<definir com o dono>}"
HOJE="$(date +%d/%m/%Y)"

cp -r "$MOLDE" "$PASTA"

# BRIEFING e HANDOFF viajam como `.modelo` porque o .gitignore do molde (que é o mesmo
# que vai para o agente) proíbe versionar texto de sessão. Aqui eles viram os arquivos
# de verdade, já fora do git do agente novo.
for base in BRIEFING HANDOFF; do
  if [[ -f "$PASTA/$base.md.modelo" ]]; then
    mv "$PASTA/$base.md.modelo" "$PASTA/$base.md"
  fi
done

# Troca os marcadores. Só nos arquivos de texto do molde.
while IFS= read -r -d '' arquivo; do
  python3 - "$arquivo" "$PASTA" "$AGENTE" "$AREA" "$TICKER" "$ELO_REL" "$PORTA_TXT" <<'PY'
import sys
caminho, pasta, agente, area, ticker, elo, porta = sys.argv[1:8]
with open(caminho, encoding="utf-8") as f:
    texto = f.read()
troca = {
    "{{PASTA}}": pasta,
    "{{AGENTE}}": agente,
    "{{AREA}}": area,
    "{{TICKER}}": ticker,
    "{{EMPRESA}}": ticker,
    "{{ELO}}": elo,
    "{{VAULT}}": f"{ticker}-ALMA",
    "{{PORTA}}": porta,
    "{{CODIGO}}": "IA-NN (preencher depois de registrar no Notion)",
    "{{PACOTE}}": "PAC-NNN (preencher depois de criar o checklist)",
    "{{INIT}}": "INIT-NN (a iniciativa dos agentes da empresa)",
}
for de, para in troca.items():
    texto = texto.replace(de, para)
with open(caminho, "w", encoding="utf-8") as f:
    f.write(texto)
PY
done < <(find "$PASTA" -type f \( -name '*.md' -o -name '*.yml' \) -print0)

cat > "$PASTA/PRIMEIROS-PASSOS.md" <<PRIMEIROS
# PRIMEIROS PASSOS · $AGENTE

> Criado em $HOJE pelo bem-novo-agente. A pasta está no padrão, mas o agente ainda não existe
> de verdade: falta o registro no Espírito. Faça isto numa sessão aberta DENTRO desta pasta,
> depois apague este arquivo.

## 1. Registrar o agente no Notion

Base **Agentes de IA**. Criar a página com:

- Nome do Agente: \`IA-NN $AGENTE - $TICKER\` (o NN é o ID que a base gera sozinha: crie, leia o ID e renomeie)
- Status do Agente: Fase de Testes
- Aplicação: Interna
- No corpo: para que ele serve, o que é dele e o que não é

## 2. Criar o checklist dele

Base **Pacotes de Tarefas**. Criar \`PAC-NNN Frente d$([ "${AGENTE: -1}" = "a" ] && echo "a" || echo "o") $AGENTE (IA-NN)\` com:

- Categoria: Pacote de Projeto
- INIT: a iniciativa dos agentes da empresa
- Agente de IA: a página do passo 1

## 3. Fechar o AGENTS.md

Trocar no \`AGENTS.md\` desta pasta:

- o código \`IA-NN\` e o pacote \`PAC-NNN\` pelos números reais
- a seção "O que é meu e o que não é", com os vizinhos nomeados
- as origens autorizadas a pedir mexida em cofre
- a porta do navegador: $PORTA_TXT
- o catálogo de segredos, por NOME, nunca por valor

## 4. Conferir antes de operar

Passe o checklist do fim da cartilha (\`AGENTES.md\` do BEM). Qualquer item falhando, o agente
não entra em operação.
PRIMEIROS

(
  cd "$PASTA"
  git init -q -b main
  git add -A
  git commit -q -m "Agente $AGENTE: pasta no padrao da cartilha dos agentes"
)

echo "pronto: $PASTA"
echo "  agente : $AGENTE (área: $AREA)"
echo "  elo    : $ELO_REL"
echo "  git    : iniciado em main, primeiro commit feito"
echo
echo "Agora abra uma sessão DENTRO de $PASTA e siga o PRIMEIROS-PASSOS.md."
