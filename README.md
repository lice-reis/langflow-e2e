# Langflow E2E — Testes de Regressão Automatizados

Repositório **standalone** de testes end-to-end do [Langflow](https://github.com/langflow-ai/langflow), construído com [Playwright](https://playwright.dev/).

> Este repositório é **independente do código-fonte do Langflow**. Os testes tratam o Langflow como uma caixa preta acessada via URL — você aponta para qualquer instância (local, Docker, staging, branch de PR) e os testes rodam sem precisar clonar ou buildar o Langflow.

---

## Sumário

1. [Por que um repositório separado?](#1-por-que-um-repositório-separado)
2. [Estrutura do projeto](#2-estrutura-do-projeto)
3. [Pré-requisitos](#3-pré-requisitos)
4. [Configuração inicial](#4-configuração-inicial)
5. [Como subir o Langflow](#5-como-subir-o-langflow)
6. [Rodando os testes](#6-rodando-os-testes)
7. [Tags — filtros por área](#7-tags--filtros-por-área)
8. [Matriz de execução por cenário](#8-matriz-de-execução-por-cenário)
9. [Como contribuir com novos testes](#9-como-contribuir-com-novos-testes)
10. [Workflows de CI (GitHub Actions)](#10-workflows-de-ci-github-actions)
11. [Sistema de alerta de staleness](#11-sistema-de-alerta-de-staleness)
12. [Regression Checklist](#12-regression-checklist)

---

## 1. Por que um repositório separado?

| | Testes dentro do monorepo | **Este repositório (standalone)** |
|---|---|---|
| Rodar contra outra versão/branch | Requer `git checkout` + rebuild | Muda 1 variável de ambiente |
| Clonar só os testes | Impossível (repo gigante) | `git clone langflow-e2e` |
| Rodar localmente | Requer instalar todo o Langflow | `PLAYWRIGHT_BASE_URL=http://... npx playwright test` |
| Atualizar testes sem mexer no Langflow | Não | Sim |
| CI desacoplado | Não | Sim |

O Langflow é subido **externamente** (Docker ou pip) e os testes apontam para ele via `PLAYWRIGHT_BASE_URL`. Nenhuma importação do código-fonte do Langflow existe aqui.

---

## 2. Estrutura do projeto

```
langflow-e2e/
├── tests/
│   ├── core/                   # Testes obrigatórios — devem passar em toda release
│   │   ├── features/           # Funcionalidades principais (135 specs)
│   │   ├── integrations/       # Templates + fluxos integrados (35 specs)
│   │   ├── unit/               # Componentes individuais de UI (21 specs)
│   │   └── regression/         # Bugs corrigidos que não podem regredir (5 specs)
│   ├── extended/               # Testes complementares — cobertura ampliada
│   │   ├── features/           # Features avançadas e edge cases (43 specs)
│   │   ├── integrations/       # Integrações estendidas (4 specs)
│   │   └── regression/         # Regressões de bugs complexos (20 specs)
│   ├── pages/                  # Page Objects — abstrações de páginas do Langflow
│   ├── utils/                  # Funções utilitárias compartilhadas entre testes
│   ├── fixtures.ts             # Fixture base com monitoramento de erros de backend
│   └── globalTeardown.ts       # Limpeza global ao final da suíte
├── scripts/
│   ├── start-langflow-docker.sh   # Sobe Langflow via Docker
│   ├── stop-langflow-docker.sh    # Para o container
│   ├── start-langflow-pip.sh      # Sobe Langflow via pip (branch/versão)
│   └── stop-langflow-pip.sh       # Para o processo pip
├── .github/workflows/
│   ├── nightly.yml             # Execução diária automática (03h BRT) contra nightly
│   ├── manual.yml              # Execução manual parametrizada por versão ou URL
│   └── file-watcher.yml        # Vigilância do source do Langflow (alerta de staleness)
├── playwright.config.ts        # Configuração do Playwright (sem deps do Langflow)
├── package.json
├── tsconfig.json
├── .env.example
└── REGRESSION_CHECKLIST.md     # Mapa de cobertura: o que existe e o que falta
```

### `tests/fixtures.ts` — o que faz

A fixture base estende o `test` padrão do Playwright com **monitoramento automático de erros de backend**. A cada teste, ela:

- Intercepta respostas HTTP `4xx`/`5xx` das APIs do Langflow
- Detecta erros de execução de flow em streams de eventos (SSE/polling)
- Reconhece exceções Python comuns (`TypeError`, `ValueError`, `NameError`, etc.)
- **Falha o teste automaticamente** se um erro de flow ocorrer, a menos que o teste chame `page.allowFlowErrors()` explicitamente

Isso significa que um teste que "passa" visualmente mas tem um erro silencioso no backend **vai falhar** — evitando falsos positivos.

---

## 3. Pré-requisitos

- **Node.js** 20+
- **npm** 9+
- **Docker** (para rodar o Langflow localmente via container) — ou uma instância já disponível via URL

---

## 4. Configuração inicial

```bash
# Clone o repositório
git clone https://github.com/lice-reis/langflow-e2e.git
cd langflow-e2e

# Instale as dependências (somente Playwright + dotenv)
npm install

# Instale os browsers do Playwright
npx playwright install chromium --with-deps

# Configure as variáveis de ambiente
cp .env.example .env
# Edite o .env conforme necessário (veja a seção abaixo)
```

### Variáveis de ambiente (`.env`)

| Variável | Padrão | Descrição |
|---|---|---|
| `PLAYWRIGHT_BASE_URL` | `http://localhost:7860/` | URL base do Langflow a ser testado |
| `LANGFLOW_SUPERUSER` | `langflow` | Usuário admin do Langflow |
| `LANGFLOW_SUPERUSER_PASSWORD` | `langflow` | Senha do admin |

---

## 5. Como subir o Langflow

Você **não precisa** clonar o repositório do Langflow. Escolha uma das opções abaixo:

### Opção A — Docker (recomendado para CI e testes locais rápidos)

```bash
# Imagem nightly (última build de desenvolvimento)
./scripts/start-langflow-docker.sh

# Versão estável específica
LANGFLOW_IMAGE_TAG=1.3.0 ./scripts/start-langflow-docker.sh

# Parar
./scripts/stop-langflow-docker.sh
```

O script aguarda o Langflow ficar disponível (`/health_check`) antes de retornar.

### Opção B — pip (para testar uma branch específica do Langflow)

```bash
# Instala e sobe a versão estável publicada
./scripts/start-langflow-pip.sh

# Parar
./scripts/stop-langflow-pip.sh
```

> **Dica para o time:** Para validar uma branch específica do Langflow, faça `git checkout` da branch no repositório do Langflow, suba o serviço com `uv run langflow run`, e nos testes aponte `PLAYWRIGHT_BASE_URL` para `http://localhost:7860`. Não é necessário alterar nada neste repositório.

### Opção C — instância externa (staging, QA, produção)

Sem scripts necessários. Apenas defina a variável:

```bash
PLAYWRIGHT_BASE_URL=https://staging.meusite.com npx playwright test
```

---

## 6. Rodando os testes

### Comandos principais

```bash
# Rodar toda a suíte
npm test

# Somente testes core (obrigatórios para release)
npm run test:core

# Somente testes extended
npm run test:extended

# Somente features (core + extended)
npm run test:features

# Somente testes de integração
npm run test:integrations

# Somente testes unitários de componentes
npm run test:unit

# Somente testes de regressão de bugs
npm run test:regression

# Filtrar por padrão de nome
npm run test:grep -- "login"

# Abrir o relatório HTML após rodar
npm run report
```

### Filtrar por tag

```bash
# Todos os testes de uma tag específica
npx playwright test --grep "@release"
npx playwright test --grep "@api"
npx playwright test --grep "@components"

# Combinando tags (OR)
npx playwright test --grep "@api|@regression"

# Excluir uma tag
npx playwright test --grep-invert "@regression"
```

### Modo debug e headed

```bash
# Abrir o navegador visualmente
npx playwright test --headed

# Modo debug (passo a passo)
npx playwright test --debug

# Rodar um único arquivo
npx playwright test tests/core/features/auto-login-off.spec.ts
```

---

## 7. Tags — filtros por área

Os testes usam tags do Playwright para permitir execução parcial por área de funcionalidade. As tags atuais são:

| Tag | Descrição | Quando usar |
|---|---|---|
| `@release` | Testes do caminho feliz críticos para release | Validação antes de qualquer deploy |
| `@regression` | Cobertura de bugs corrigidos | Garantir que regressões não voltem |
| `@api` | Interações com a API REST do Langflow | Mudanças em endpoints de backend |
| `@components` | Testes de componentes individuais do canvas | Mudanças em componentes específicos |
| `@workspace` | Testes de flows, pastas e canvas | Mudanças na área de trabalho |
| `@mainpage` | Testes da página principal / home | Mudanças na landing page |
| `@database` | Testes que dependem de estado persistido | Mudanças em banco de dados ou migrações |
| `@folder` | Testes de gerenciamento de pastas | Mudanças na funcionalidade de pastas |
| `@notes` | Testes de sticky notes | Mudanças no componente de notas |

### Como adicionar tags a um teste

```typescript
test(
  "admin desativa usuário — usuário não consegue mais logar",
  { tag: ["@release", "@api"] },
  async ({ page }) => {
    // ...
  }
);
```

> **Recomendação para novos testes:** Todo teste novo deve ter pelo menos uma tag funcional (`@release`, `@api`, `@components`, `@workspace` ou `@regression`). Isso garante que seja possível rodar subconjuntos relevantes sem executar a suíte completa.

---

## 8. Matriz de execução por cenário

| Cenário | Comando |
|---|---|
| **Validação completa antes de release** | `npm test` |
| **Smoke test rápido (caminho feliz)** | `npx playwright test --grep "@release"` |
| **Validar mudança em endpoint de API** | `npx playwright test --grep "@api"` |
| **Validar mudança em componente do canvas** | `npx playwright test --grep "@components"` |
| **Confirmar que bugs antigos não voltaram** | `npm run test:regression` |
| **Testar contra branch específica do Langflow** | `PLAYWRIGHT_BASE_URL=http://localhost:7860 npm test` (com branch no ar localmente) |
| **Testar contra staging** | `PLAYWRIGHT_BASE_URL=https://staging.empresa.com npm test` |
| **Testar contra versão Docker específica** | `LANGFLOW_IMAGE_TAG=1.3.0 ./scripts/start-langflow-docker.sh && npm test` |
| **Testar contra a nightly** | `./scripts/start-langflow-docker.sh && npm test` (usa `latest` do `langflow-nightly`) |
| **Rodar apenas um arquivo de teste** | `npx playwright test tests/core/features/login.spec.ts` |
| **Debug visual de um teste específico** | `npx playwright test --headed --debug tests/core/features/login.spec.ts` |

---

## 9. Como contribuir com novos testes

### Fluxo de trabalho

1. Escolha um item `[ ]` (não coberto) ou `[~]` (parcial) no [`REGRESSION_CHECKLIST.md`](./REGRESSION_CHECKLIST.md)
2. Crie uma branch: `git checkout -b test/nome-do-cenario`
3. Crie ou edite o arquivo `.spec.ts` na pasta correta:
   - `tests/core/features/` — funcionalidades principais
   - `tests/core/unit/` — componentes individuais de UI
   - `tests/core/integrations/` — fluxos completos com templates
   - `tests/core/regression/` — bugs corrigidos
   - `tests/extended/features/` — edge cases e features avançadas
4. Use sempre o `test` da fixture local, não do Playwright diretamente:
   ```typescript
   // ✅ Correto — usa monitoramento de erros de backend
   import { test, expect } from "../../fixtures";

   // ❌ Evitar — não monitora erros de backend
   import { test, expect } from "@playwright/test";
   ```
5. Adicione as tags adequadas ao teste
6. Marque o checklist: `[ ]` → `[x]` (ou `[~]` se cobertura parcial)
7. Abra um PR — garanta que os testes passam contra a `langflow-nightly:latest`

### Convenções de nomenclatura

| Tipo | Pasta | Exemplo de arquivo |
|---|---|---|
| Feature de UI | `tests/core/features/` | `canvas-copy-paste.spec.ts` |
| Componente isolado | `tests/core/unit/` | `dropdownComponent.spec.ts` |
| Fluxo integrado | `tests/core/integrations/` | `Basic Prompting.spec.ts` |
| Bug corrigido | `tests/core/regression/` | `generalBugs-shard-5.spec.ts` |

### Page Objects

As abstrações de páginas ficam em `tests/pages/`. Use-os para encapsular interações complexas e evitar duplicação entre specs:

```typescript
import { LoginPage } from "../../pages/LoginPage";

test("login com credenciais válidas", async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.login("admin", "admin");
  // ...
});
```

---

## 10. Workflows de CI (GitHub Actions)

### `nightly.yml` — Execução noturna automática

- **Gatilho:** Todos os dias às **03:00 BRT** (06:00 UTC) + disparo manual
- **Imagem:** `langflowai/langflow-nightly:latest`
- **O que faz:** Roda toda a suíte contra a última build de desenvolvimento
- **Falha:** Cria automaticamente uma issue no repositório com link para o relatório
- **Disparo manual:** Permite especificar uma tag da imagem nightly (ex: `1.5.1.dev36`)

### `manual.yml` — Execução manual parametrizada

- **Gatilho:** Apenas manual (`workflow_dispatch`)
- **Parâmetros:**
  - `langflow_target` — tag Docker (ex: `latest`, `1.3.0`) ou URL externa (ex: `https://staging.empresa.com`)
  - `langflow_image` — `nightly` (padrão) ou `stable`
  - `test_suite` — `all`, `core`, `extended`, `features`, `integrations`, `unit`, `regression`
  - `test_grep` — regex para filtrar testes (ex: `login|logout`)
- **Casos de uso:** Validar uma versão específica antes de release, testar contra staging, rodar uma área específica

### `file-watcher.yml` — Vigilância do source do Langflow

- **Gatilho:** Todos os dias às **05:00 BRT** (08:00 UTC) + disparo manual
- **O que faz:** Monitora o repositório oficial `langflow-ai/langflow` e detecta mudanças nas últimas 24h nas áreas críticas:
  - `src/backend/base/langflow/api/` — endpoints da API REST
  - `src/backend/base/langflow/components/` — componentes do Langflow
  - `src/frontend/src/pages/` — páginas do frontend
  - `src/frontend/src/components/` — componentes do frontend
  - `src/frontend/src/stores/` — estado global da UI
  - Arquivos de autenticação e execução de flows
- **Resultado:** Abre uma issue com as áreas alteradas, os commits detectados e o mapeamento para as seções do [`REGRESSION_CHECKLIST.md`](./REGRESSION_CHECKLIST.md)

---

## 11. Sistema de alerta de staleness

Um dos maiores riscos em testes E2E é o teste que **passa mas não testa mais o comportamento correto** — por exemplo, porque a UI mudou de nome e o seletor ainda funciona por coincidência.

Este repositório endereça isso com dois mecanismos:

### Mecanismo 1 — Falha ativa (`fixtures.ts`)

A fixture monitora ativamente erros de backend em **toda** execução. Se um flow falha silenciosamente no servidor mas a UI não mostra erro visível, o teste falha de qualquer forma.

### Mecanismo 2 — Alerta passivo (`file-watcher.yml`)

O workflow `file-watcher.yml` roda diariamente e verifica se arquivos críticos do Langflow foram alterados. Quando detecta mudanças, cria uma issue com:

- Quais áreas do código do Langflow mudaram
- Os commits das últimas 24h
- Quais seções do `REGRESSION_CHECKLIST.md` precisam de revisão

**Isso não significa que o teste vai falhar automaticamente** — significa que o time recebe um alerta para revisar proativamente se os testes ainda refletem o comportamento correto.

### Fluxo de resposta ao alerta

```
Issue criada pelo file-watcher
        ↓
QA revisa os commits listados
        ↓
Roda os testes da área afetada localmente
        ↓
Se passou mas parece errado → atualiza o teste
Se falhou → corrige ou reporta como bug
        ↓
Atualiza REGRESSION_CHECKLIST.md se necessário
        ↓
Fecha a issue
```

---

## 12. Regression Checklist

O arquivo [`REGRESSION_CHECKLIST.md`](./REGRESSION_CHECKLIST.md) é o mapa central de cobertura do time. Ele lista todos os cenários relevantes do Langflow organizados por área funcional, com o status de cada um:

| Símbolo | Significado |
|---|---|
| `[x]` | Cenário **automatizado** — arquivo mapeado ao lado |
| `[ ]` | Cenário **não automatizado** — precisa de cobertura |
| `[~]` | **Parcialmente** coberto — precisa expandir |
| `[!]` | Coberto mas **flaky / instável** — precisa estabilizar |

**Cobertura atual:** ~95% (228 de 241 cenários mapeados)

Áreas com maior gap de cobertura:
- Área 9 — Componentes Principais (6 cenários descobertos)
- Área 14 — Tratamento de Erros / Edge Cases (4 cenários descobertos)
- Área 5 — Configuração de Componentes (5 cenários descobertos)

---

## Contato e suporte

Dúvidas ou problemas? Abra uma issue neste repositório ou entre em contato com o time de QA.
