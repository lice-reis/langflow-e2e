# Langflow — Regression Test Checklist

> **Repositório:** `/Users/daniellicnerski/orion-e2e/langflow`
> **Testes:** `src/frontend/tests/`
> **Config:** `src/frontend/playwright.config.ts`
> **Última atualização:** 2026-03-10

---

## Como usar este checklist

- `[ ]` → cenário **não automatizado** (precisa de cobertura)
- `[x]` → cenário **automatizado** (arquivo mapeado ao lado)
- `[~]` → **parcialmente** coberto (precisa expandir)
- `[!]` → coberto mas **flaky / instável** (precisa estabilizar)

---

## ÁREA 1 — Autenticação e Gerenciamento de Usuários

### 1.1 Login / Logout
- [x] Login com credenciais válidas (admin/admin) → `core/features/auto-login-off.spec.ts`
- [x] Login com credenciais inválidas — deve exibir mensagem de erro → `core/features/login-invalid-credentials.spec.ts`
- [x] Logout — deve redirecionar para tela de login → `core/features/logout-flow.spec.ts`
- [x] Auto-login ativado (LANGFLOW_AUTO_LOGIN=true) — deve pular tela de login → `core/features/auto-login-off.spec.ts`
- [x] Auto-login desativado — deve exibir tela de login → `extended/features/autoLogin.spec.ts`
- [x] Sessão expirada — deve redirecionar para login ao tentar ação autenticada → `core/features/session-expired.spec.ts`
- [x] Limpeza de sessão após logout → `core/regression/general-bugs-remove-session-after-logout.spec.ts`

### 1.2 Gerenciamento de Usuários (Admin)
- [x] Admin cria novo usuário → `core/features/auto-login-off.spec.ts`
- [x] Admin desativa usuário — usuário não consegue mais logar → `core/features/admin-user-management.spec.ts`
- [x] Admin ativa usuário inativo — usuário consegue logar após ativação → `core/features/admin-user-management.spec.ts`
- [x] Admin renomeia usuário → `core/features/admin-user-management.spec.ts`
- [x] Admin altera senha de usuário — usuário loga com nova senha → `core/features/admin-password-change.spec.ts`
- [x] Admin altera senha — senha antiga não funciona após troca → `core/features/admin-password-change.spec.ts`
- [x] Fluxo de isolamento: user A não vê flows de user B → `core/features/auto-login-off.spec.ts`
- [x] Configurações de usuário (user settings) → `extended/features/userSettings.spec.ts`

---

## ÁREA 2 — Gerenciamento de Flows (CRUD)

### 2.1 Criar Flow
- [x] Criar flow em branco (blank flow) → `core/features/` (awaitBootstrapTest)
- [x] Criar flow a partir de template (via modal "New Flow") → `core/integrations/`
- [x] Criar flow duplicando um existente → `core/features/duplicate-flow.spec.ts`
- [x] Criar flow via importação de arquivo JSON → `core/features/import-flow-json.spec.ts`

### 2.2 Visualizar e Editar Flow
- [x] Renomear flow pelo header do editor → `core/features/` (rename-flow util)
- [x] Editar nome e descrição do flow → `extended/features/edit-flow-name.spec.ts`
- [x] Auto-save do flow ao fazer alterações → `extended/features/auto-save-off.spec.ts`
- [x] Configurações do flow (flow settings) → `extended/features/flowSettings.spec.ts`

### 2.3 Deletar Flow
- [x] Deletar flow individual → `extended/features/deleteFlows.spec.ts`
- [x] Deletar múltiplos flows (bulk actions) → `extended/features/bulk-actions.spec.ts`
- [x] Confirmar que flow deletado não aparece na listagem → `core/features/api-flows-crud.spec.ts`

### 2.4 Exportar / Importar Flow
- [x] Exportar flow como JSON → `core/features/export-import-flow.spec.ts`
- [x] Importar flow via upload de arquivo JSON → `core/features/export-import-flow.spec.ts`
- [~] Importar flow com componentes desatualizados — deve mostrar aviso de atualização → `core/features/outdated-component-notification.spec.ts`
- [x] Importar JSON inválido — deve exibir mensagem de erro → `core/features/import-invalid-json.spec.ts`

### 2.5 Operações de Flow
- [x] Travar (lock) flow — impede edição → `core/features/flow-lock.spec.ts`
- [x] Destravar flow → `extended/features/lock-flow.spec.ts`
- [x] Mover flow entre pastas via API (PATCH folder_id) → `core/features/api-folders-crud.spec.ts`
- [x] Publicar flow (publish) → `core/features/publish-flow.spec.ts`
- [x] Salvar componentes do flow como template → `core/features/save-flow-as-template.spec.ts`

---

## ÁREA 3 — Gerenciamento de Pastas (Projetos)

### 3.1 CRUD de Pastas
- [x] Criar nova pasta → `core/features/folders.spec.ts`
- [x] Renomear pasta → `core/features/folders.spec.ts`
- [x] Deletar pasta vazia → `core/features/folders.spec.ts`
- [x] Deletar pasta com flows dentro → `core/features/folder-deletion-integrity.spec.ts`
- [x] Integridade após deleção — flows/pastas restantes não afetados → `core/features/folder-deletion-integrity.spec.ts`
- [x] Criar pasta após deletar todas as pastas → `core/features/folder-deletion-integrity.spec.ts`
- [x] Upload de flow por drag-and-drop na pasta → `core/features/folder-drag-drop-flow.spec.ts`
- [x] Mover flow para outra pasta → `core/features/folders.spec.ts`

### 3.2 Navegação de Pastas
- [~] Navegar entre pastas — flows corretos exibidos por pasta → `core/features/flow-navigation-folders.spec.ts`
- [x] Pesquisar flow por nome filtra resultados corretamente → `core/features/flow-navigation-folders.spec.ts`
- [x] Pastas na sidebar de navegação → `extended/features/integration-side-bar.spec.ts`

---

## ÁREA 4 — Canvas / Editor Visual

### 4.1 Sidebar de Componentes
- [x] Pesquisar componente por nome → `core/features/filterSidebar.spec.ts`
- [x] Hover sobre componente exibe tooltip/preview → `core/features/componentHoverAdd.spec.ts`
- [x] Pesquisa por teclado (keyboard shortcut) → `core/features/keyboardComponentSearch.spec.ts`
- [x] Filtrar componentes por categoria → `core/features/sidebar-category-filter.spec.ts`, `core/features/sidebar-filter-by-category.spec.ts`
- [x] Sidebar mostra contagem correta de providers → `core/features/sidebar-provider-count.spec.ts`

### 4.2 Adicionar Componentes ao Canvas
- [x] Arrastar componente da sidebar para o canvas (drag-and-drop) → `extended/features/dragAndDrop.spec.ts`
- [x] Duplo clique na sidebar adiciona componente ao canvas → `core/features/sidebar-add-component.spec.ts`
- [x] Hover + clique no botão "+" adiciona componente ao canvas → `core/features/sidebar-add-component.spec.ts`
- [x] Componente adicionado aparece com configurações padrão → `core/features/canvas-component-defaults.spec.ts`

### 4.3 Conexões entre Componentes
- [x] Conectar dois componentes compatíveis (desenhar edge) → `core/features/canvas-connect-components.spec.ts`
- [x] Impedir conexão entre tipos incompatíveis (edge inválida) → `core/features/canvas-incompatible-connection.spec.ts`
- [x] Deletar edge/conexão → `extended/features/twoEdges.spec.ts`
- [x] Filtrar edges por tipo de dado → `core/features/filterEdge-shard-0.spec.ts`
- [x] Reconectar edge já existente → `core/features/canvas-edge-reconnect.spec.ts`

### 4.4 Manipulação de Nós
- [x] Deletar componente do canvas → `extended/features/deleteComponents.spec.ts`
- [x] Copiar e colar componente (Ctrl+C / Ctrl+V) → `core/features/canvas-copy-paste.spec.ts`
- [x] Atalhos de teclado do canvas → `extended/features/langflowShortcuts.spec.ts`
- [x] Minimizar componente no canvas → `extended/features/minimize.spec.ts`
- [x] Mover componente dentro do canvas (drag no canvas) → `extended/regression/`
- [x] Selecionar múltiplos componentes via box selection (Shift+drag) → `core/features/canvas-multiselect.spec.ts`
- [x] Deletar múltiplos componentes selecionados → `core/features/canvas-multiselect.spec.ts`
- [x] Desselecionar nó clicando em área vazia do canvas → `core/features/canvas-deselect-node.spec.ts`
- [x] Desselecionar nó via Escape → `core/features/canvas-deselect-node.spec.ts`

### 4.5 Zoom e Navegação do Canvas
- [x] Zoom in aumenta escala do canvas → `core/features/canvas-zoom-fitview.spec.ts`
- [x] Zoom out diminui escala do canvas → `core/features/canvas-zoom-fitview.spec.ts`
- [x] Fit View (Ctrl+Shift+H) centraliza nós → `core/features/canvas-zoom-fitview.spec.ts`
- [x] Botão Fit View na toolbar → `core/features/canvas-zoom-fitview.spec.ts`
- [x] Scroll para navegar no canvas → `core/features/canvas-scroll-navigation.spec.ts`
- [~] Minimap (se habilitado) — feature flag-gated, not tested

### 4.6 Agrupamento (Group)
- [x] Criar grupo de componentes → `core/features/group.spec.ts`
- [x] Desagrupar componentes → `core/features/group-enter-exit.spec.ts`
- [x] Expandir/colapsar grupo → `core/features/group-expand-collapse.spec.ts`, `core/features/group-enter-exit.spec.ts`

### 4.7 Freeze e Estado
- [x] Congelar componente (freeze) → `core/features/freeze.spec.ts`
- [x] Freeze path (congela caminho inteiro) → `core/features/freeze-path.spec.ts`
- [x] Descongelar componente → `core/features/freeze-unfreeze-component.spec.ts`

### 4.8 Sticky Notes
- [x] Adicionar sticky note → `extended/features/sticky-notes.spec.ts`
- [x] Editar texto da sticky note
- [x] Mudar cor da sticky note → `core/features/note-color-picker.spec.ts`
- [x] Redimensionar sticky note → `extended/features/sticky-notes-dimensions.spec.ts`
- [x] Deletar sticky note (Delete key) → `core/features/canvas-sticky-note-delete.spec.ts`
- [x] Deletar sticky note (Backspace key) → `core/features/canvas-sticky-note-delete.spec.ts`
- [x] Múltiplas sticky notes independentes → `core/features/canvas-sticky-note-delete.spec.ts`

### 4.9 Right-Click e Menus
- [x] Menu de contexto por right-click no canvas → `core/features/right-click-dropdown.spec.ts`
- [x] Menu de contexto por right-click em componente → `core/features/canvas-right-click-component.spec.ts`
- [x] Ações do menu principal (actionsMainPage) → `core/features/actionsMainPage-shard-1.spec.ts`

### 4.10 Executar e Parar
- [x] Executar flow pelo botão Run → `core/features/run-flow.spec.ts`
- [x] Parar building do flow → `core/features/stop-building.spec.ts`
- [x] Botão Stop no Playground → `extended/features/stop-button-playground.spec.ts`

---

## ÁREA 5 — Configuração de Componentes

### 5.1 Painel de Parâmetros
- [x] Abrir opções avançadas do componente → `core/features/` (open-advanced-options util)
- [x] Editar campo de texto (input) → `core/unit/inputComponent.spec.ts`
- [x] Editar dropdown → `core/unit/dropdownComponent.spec.ts`
- [x] Editar área de texto (textarea) → `core/unit/textAreaModalComponent.spec.ts`
- [x] Editar campo de código → `core/unit/codeAreaModalComponent.spec.ts`
- [x] Editar campo float → `core/unit/floatComponent.spec.ts`
- [x] Editar campo int → `core/unit/intComponent.spec.ts`
- [x] Editar campo toggle → `core/unit/toggleComponent.spec.ts`
- [x] Editar key-pair list → `core/unit/keyPairListComponent.spec.ts`
- [x] Editar input list → `core/unit/inputListComponent.spec.ts`
- [x] Editar table input → `core/unit/tableInputComponent.spec.ts`
- [x] Editar slider → `core/unit/sliderComponent.spec.ts`
- [x] Editar tab component → `core/unit/tabComponent.spec.ts`

### 5.2 Tool Mode
- [x] Habilitar Tool Mode num componente → `extended/features/tool-mode.spec.ts`
- [x] Agrupar componentes em Tool Mode → `core/features/toolModeGroup.spec.ts`
- [x] Editar tools (edit-tools) → `extended/features/edit-tools.spec.ts`

### 5.3 Atualização de Componentes
- [x] Notificação de componente desatualizado → `extended/features/outdated-message.spec.ts`
- [x] Ação de atualizar componente → `extended/features/outdated-actions.spec.ts`
- [ ] Atualização com breaking change — deve alertar usuário
- [ ] Componente legado visível via configuração

### 5.4 Edição de Código
- [x] Editar código Python do componente customizado → `core/features/customComponentAdd.spec.ts`
- [x] Componente customizado completo → `core/unit/` (custom_component_full.ts)

---

## ÁREA 6 — Playground

### 6.1 Interações de Chat
- [x] Abrir Playground → (via playground-btn-flow-io)
- [x] Enviar mensagem de texto → (via input-chat-playground + button-send)
- [x] Receber resposta do LLM → (via div-chat-message)
- [x] Streaming de resposta (SSE) → `withEventDeliveryModes` (modo streaming)
- [x] Polling de resposta → `withEventDeliveryModes` (modo polling)
- [x] Resposta direta (direct) → `withEventDeliveryModes` (modo direct)
- [x] UX do Playground (playground-ux) → `core/features/playground-ux.spec.ts`
- [!] Enviar mensagem vazia — deve desabilitar botão enviar → `core/features/playground-empty-message-send.spec.ts` (**BUG: botão habilitado mesmo vazio**)
- [ ] Enviar mensagem enquanto resposta em curso — deve aguardar ou enfileirar

### 6.2 Histórico e Sessão
- [x] Configurar session ID customizado → `core/features/settings-message-history.spec.ts`
- [x] Trocar session ID — inicia nova conversa → `core/features/playground-session-id.spec.ts`
- [x] Deletar mensagem individual do histórico → `core/features/playground-message-delete.spec.ts`
- [x] Limpar histórico completo de sessão
- [x] Histórico persiste ao reabrir Playground → `core/features/playground-history-persist.spec.ts`

### 6.3 Features Avançadas do Playground
- [x] Modo fullscreen do Playground → `core/features/playground-fullscreen.spec.ts`
- [ ] Playground compartilhável (URL pública, sem autenticação)
- [x] Voice mode (assistente de voz) → `core/features/voice-assistant.spec.ts`
- [ ] Inspecionar steps de raciocínio do Agent
- [ ] Inspecionar tools usadas pelo Agent

### 6.4 Output Modal
- [x] Copiar output do componente → `extended/features/output-modal-copy-button.spec.ts`
- [x] Botão de copy no output → `extended/features/copy-button-in-output.spec.ts`

---

## ÁREA 7 — Templates (Starter Projects)

### 7.1 Templates Básicos
- [x] **Basic Prompting** (OpenAI) → `core/integrations/Basic Prompting.spec.ts`
- [x] **Basic Prompting** (Anthropic) → `core/integrations/Basic Prompting Anthropic.spec.ts`
- [x] **Simple Agent** (OpenAI) → `core/integrations/Simple Agent.spec.ts`
- [x] **Simple Agent** (Anthropic) → `core/integrations/Simple Agent Anthropic.spec.ts`
- [x] **Simple Agent** com memória → `core/integrations/Simple Agent Memory.spec.ts`
- [x] **Vector Store RAG** → `core/integrations/Vector Store.spec.ts`
- [x] **Memory Chatbot** → `core/integrations/Memory Chatbot.spec.ts`

### 7.2 Templates de Geração de Conteúdo
- [x] **Blog Writer** → `core/integrations/Blog Writer.spec.ts`
- [x] **Instagram Copywriter** → `core/integrations/Instagram Copywriter.spec.ts`
- [x] **Twitter Thread Generator** → `core/integrations/Twitter Thread Generator.spec.ts`
- [x] **SEO Keyword Generator** → `core/integrations/SEO Keyword Generator.spec.ts`
- [x] **Portfolio Website Code Generator** → `core/integrations/Portfolio Website Code Generator.spec.ts`
- [x] **SaaS Pricing** → `core/integrations/SaaS Pricing.spec.ts`

### 7.3 Templates de Análise e Processamento
- [x] **Document QA** → `core/integrations/Document QA.spec.ts`
- [x] **Invoice Summarizer** → `core/integrations/Invoice Summarizer.spec.ts`
- [x] **Financial Report Parser** → `core/integrations/Financial Report Parser.spec.ts`
- [x] **Image Sentiment Analysis** → `core/integrations/Image Sentiment Analysis.spec.ts`
- [x] **Text Sentiment Analysis** → `core/integrations/Text Sentiment Analysis.spec.ts`
- [x] **Youtube Analysis** → `core/integrations/Youtube Analysis.spec.ts`

### 7.4 Templates de Agentes
- [x] **Dynamic Agent** → `core/integrations/Dynamic Agent.spec.ts`
- [x] **Hierarchical Agent** → `core/integrations/Hierarchical Agent.spec.ts`
- [x] **Sequential Task Agent** → `core/integrations/Sequential Task Agent.spec.ts`
- [x] **Social Media Agent** → `core/integrations/Social Media Agent.spec.ts`
- [x] **Travel Planning Agent** → `core/integrations/Travel Planning Agent.spec.ts`
- [x] **Market Research** → `core/integrations/Market Research.spec.ts`
- [x] **Research Translation Loop** → `core/integrations/Research Translation Loop.spec.ts`
- [x] **Pokedex Agent** → `core/integrations/Pokedex Agent.spec.ts`
- [x] **Price Deal Finder** → `core/integrations/Price Deal Finder.spec.ts`
- [x] **News Aggregator** → `core/integrations/News Aggregator.spec.ts`

### 7.5 Templates Avançados
- [x] **Custom Component Generator** → `core/integrations/Custom Component Generator.spec.ts`
- [x] **Prompt Chaining** → `core/integrations/Prompt Chaining.spec.ts`
- [x] **Decision Flow** → `core/integrations/decisionFlow.spec.ts`
- [x] **Similarity** → `core/integrations/similarity.spec.ts`
- [x] **MCP Server** (starter projects) → `extended/features/mcp-server-starter-projects.spec.ts`

### 7.6 Shards de Starter Projects
- [x] Starter Projects Shard 1 → `core/integrations/starter-projects-shard1.spec.ts`
- [x] Starter Projects Shard 2 → `core/integrations/starter-projects-shard2.spec.ts`
- [x] Starter Projects Shard 3 → `core/integrations/starter-projects-shard3.spec.ts`
- [x] Starter Projects Shard 4 → `core/integrations/starter-projects-shard4.spec.ts`
- [x] Starter Projects (extended) → `extended/features/starter-projects.spec.ts`

---

## ÁREA 8 — Integrações LLM e Model Providers

### 8.1 OpenAI
- [x] Configurar API key OpenAI via GlobalVariables → `core/features/globalVariables.spec.ts`
- [x] Selecionar modelo GPT (GPT-4o-mini) → `utils/select-gpt-model.ts`
- [x] Executar flow com OpenAI → todos os testes de integration
- [x] Trocar versão do modelo GPT (dropdown) → `core/features/gpt-model-version.spec.ts`
- [x] Erro de API key inválida — exibir mensagem de erro → `core/features/llm-invalid-api-key-ui.spec.ts` (mocked)

### 8.2 Anthropic
- [x] Configurar API key Anthropic → `utils/select-anthropic-model.ts`
- [x] Selecionar modelo Claude → `core/integrations/Basic Prompting Anthropic.spec.ts`
- [x] Trocar entre modelos Claude (Sonnet, Haiku, Opus) → `core/features/claude-model-switch.spec.ts`
- [x] Erro de API key Anthropic inválida → `core/features/api-invalid-key.spec.ts` (API-level)

### 8.3 Gerenciamento de Providers
- [x] Modal "Manage Model Providers" → `core/features/modelProviderModal.spec.ts`
- [x] Contagem de providers disponíveis → `core/features/modelProviderCount.spec.ts`
- [x] Componente Language Model — configuração → `core/features/language-model-regression.spec.ts`
- [x] Componente Model Input → `core/features/modelInputComponent.spec.ts`
- [x] Adicionar novo provider via modal → `core/features/model-provider-api-key.spec.ts`, `core/features/model-provider-modal-actions.spec.ts`
- [x] Remover API key de provider existente → `core/features/remove-provider-api-key.spec.ts`

### 8.4 Variáveis Globais (API Keys)
- [x] Criar variável global → `core/features/globalVariables.spec.ts`
- [x] Usar variável global em componente (API key)
- [x] Editar variável global existente → `core/features/global-variable-edit.spec.ts`
- [x] Deletar variável global → `core/features/global-variables-crud.spec.ts`
- [x] Criar variável global do tipo "Generic" → `core/features/global-variables-crud.spec.ts`

---

## ÁREA 9 — Componentes Principais

### 9.1 Chat Input / Output
- [x] ChatInput recebe mensagem do usuário → `core/unit/chatInputOutput.spec.ts`
- [x] ChatOutput exibe resposta do LLM → `core/integrations/textInputOutput.spec.ts`
- [x] Chat Input/Output com autenticação de usuário → `core/integrations/chatInputOutputUser-shard-0.spec.ts`

### 9.2 Prompt Template
- [x] Prompt com variáveis em curly braces → `core/regression/generalBugs-prompt.spec.ts`
- [x] Modal do Prompt → `core/unit/promptModalComponent.spec.ts`
- [x] Porta dinâmica gerada ao adicionar variável no prompt → `core/features/prompt-dynamic-variables.spec.ts`
- [x] Remover variável do prompt apaga porta correspondente → `core/features/prompt-remove-variable.spec.ts`

### 9.3 API Request (HTTP)
- [x] Configurar URL e método HTTP → `core/features/api-component-regression.spec.ts`
- [x] Adicionar headers e body → `core/features/api-request-component-ui.spec.ts`
- [ ] Executar request GET e verificar resposta status 200
- [ ] Executar request POST com payload
- [ ] Erro de URL inválida

### 9.4 Webhook
- [x] Componente Webhook exibido no canvas → `core/unit/webhookComponent.spec.ts`
- [x] URL de webhook gerada automaticamente → `core/features/webhook-component-regression.spec.ts`
- [ ] Trigger via requisição HTTP externa
- [ ] Payload recebido propagado ao flow

### 9.5 Agent
- [x] Agent com tool calling → `core/features/agent-component-regression.spec.ts`
- [x] Agent exibe steps de raciocínio no Playground → `core/features/agent-reasoning-steps.spec.ts`
- [ ] Agent para ao atingir stop condition
- [ ] Agent com múltiplas tools configuradas
- [x] Composio (tool integration para Agent) → `core/features/composio.spec.ts`

### 9.6 Loop Component
- [x] Componente Loop no canvas → `extended/features/loop-component.spec.ts`
- [ ] Loop executa número correto de iterações
- [ ] Loop para ao atingir condição de saída

### 9.7 File Upload Component
- [x] Upload de arquivo via componente → `core/unit/fileUploadComponent.spec.ts`
- [x] Upload de arquivos de diferentes tipos (txt, pdf, json, py, wav) → `utils/upload-file.ts`
- [x] Limite de tamanho de arquivo → `extended/features/limit-file-size-upload.spec.ts`
- [x] Página de gerenciamento de arquivos → `extended/features/files-page.spec.ts`

### 9.8 Nested / Agrupamento
- [x] Componente aninhado (nested) → `core/unit/nestedComponent.spec.ts`
- [x] Entrar e sair de componente agrupado → `core/features/group-enter-exit.spec.ts`

---

## ÁREA 10 — API REST do Langflow

### 10.1 Health Check
- [x] GET `/api/v1/health_check` → status 200, db ok → `core/features/api-health-check.spec.ts`
- [x] GET `/api/v1/health` → retorna uptime e versão → `core/features/api-health-check.spec.ts`

### 10.2 CRUD de Flows via API
- [x] POST `/api/v1/flows/` → cria flow, retorna ID → `core/features/api-flows-crud.spec.ts`
- [x] GET `/api/v1/flows/` → lista flows do usuário → `core/features/api-flows-crud.spec.ts`
- [x] GET `/api/v1/flows/{id}` → retorna flow pelo ID → `core/features/api-flows-crud.spec.ts`
- [x] PATCH `/api/v1/flows/{id}` → atualiza nome/descrição → `core/features/api-flows-crud.spec.ts`
- [x] DELETE `/api/v1/flows/{id}` → remove flow, retorna 200 → `core/features/api-flows-crud.spec.ts`
- [x] GET `/api/v1/flows/{id}` após DELETE → deve retornar 404 → `core/features/api-flows-crud.spec.ts`

### 10.3 Execução de Flows via API
- [x] POST `/api/v1/run/{flow_id}` com `input_value` → retorna resposta → `core/features/api-run-flow.spec.ts`
- [x] POST com `tweaks` → parâmetros sobrescrevem configuração do flow → `core/features/api-run-with-tweaks.spec.ts`
- [x] POST com `session_id` customizado → `core/features/api-run-flow.spec.ts`
- [x] POST com `input_type: "chat"` e `output_type: "chat"` → `core/features/api-run-with-tweaks.spec.ts`
- [x] POST com API key inválida → retorna 401/403 → `core/features/api-run-flow.spec.ts`
- [x] POST para flow inexistente → retorna 404 → `core/features/api-run-flow.spec.ts`

### 10.4 Componentes via API
- [x] GET `/api/v1/all` → lista todos os componentes disponíveis → `core/features/api-run-flow.spec.ts`
- [x] POST `/api/v1/custom_component` → cria componente customizado → `core/features/api-custom-component.spec.ts`

### 10.5 Mensagens e Monitoramento
- [x] GET `/api/v1/monitor/messages` → retorna 200 com array → `core/features/api-monitor-messages.spec.ts`
- [x] GET com filtro de session_id retorna apenas mensagens da sessão → `core/features/api-monitor-messages.spec.ts`

### 10.6 Geração de Código de Integração
- [x] Gerar curl para execução via API → `extended/features/curlApiGeneration.spec.ts`
- [x] Gerar código Python para integração → `extended/features/pythonApiGeneration.spec.ts`
- [x] Modal de acesso à API (api-access-button) → `core/features/tweaksTest.spec.ts`

---

## ÁREA 11 — MCP Server

### 11.1 Configuração MCP
- [x] Aba MCP Server no flow → `extended/features/mcp-server-tab.spec.ts`
- [x] Adicionar MCP server via modal → `extended/features/mcp-server.spec.ts`
- [x] Starter project com MCP → `extended/features/mcp-server-starter-projects.spec.ts`
- [ ] Flow exposto como MCP server — verificar endpoint gerado
- [ ] Executar tool do MCP server via protocolo MCP

---

## ÁREA 12 — Observabilidade e Monitoramento

### 12.1 Traces
- [x] Visualizar traces de execução → `core/features/traces.spec.ts`
- [x] Trace API retorna transações paginadas → `core/features/traces-detail.spec.ts`
- [x] Trace exibe latência de cada componente → `core/features/traces-latency-tokens.spec.ts`
- [x] Trace exibe tokens consumidos → `core/features/traces-latency-tokens.spec.ts`

### 12.2 Notificações
- [x] Notificações do sistema → `extended/features/notifications.spec.ts`
- [x] Notificação de erro de execução → `core/features/execution-error-notification.spec.ts`
- [x] Notificação de componente desatualizado → `core/features/outdated-component-notification.spec.ts`

### 12.3 Estado do Usuário
- [x] Rastrear progresso do usuário → `core/features/user-progress-track.spec.ts`
- [x] Limpeza de estado do flow de usuário → `core/features/user-flow-state-cleanup.spec.ts`

---

## ÁREA 13 — Configurações e Opções

### 13.1 Settings Gerais
- [x] Acessar página de Settings → `core/features/settings-navigation.spec.ts`
- [x] Configurações de histórico de mensagens → `core/features/settings-message-history.spec.ts`
- [x] Alterar configurações de aparência/tema → `core/features/settings-theme-toggle.spec.ts`

### 13.2 Shortcut Keys
- [x] Atalhos de teclado funcionam no editor → `extended/features/langflowShortcuts.spec.ts`
- [~] Todos os atalhos documentados funcionam → `core/features/settings-navigation.spec.ts` (verifica seção Shortcuts carrega)

---

## ÁREA 14 — Tratamento de Erros e Edge Cases

### 14.1 Erros de Execução
- [x] Componente que levanta erro Python → `extended/features/validate-raise-errors-components.spec.ts`
- [x] Flow com erro exibe mensagem apropriada
- [x] Erro de rede durante execução — retry ou mensagem clara → `core/features/execution-error-notification.spec.ts`
- [x] Timeout de execução — mensagem clara ao usuário → `core/features/execution-error-notification.spec.ts`

### 14.2 Bugs Gerais (Regression)
- [x] Bugs gerais shard-4 → `core/regression/generalBugs-shard-4.spec.ts`
- [x] Bugs gerais shard-5 → `core/regression/generalBugs-shard-5.spec.ts`
- [x] Bugs gerais shard-9 → `core/regression/generalBugs-shard-9.spec.ts`
- [x] Bugs de agente (extended) → `extended/regression/`
- [x] Bugs de minimize, move, save → `extended/regression/`
- [x] Bugs de truncation, icons → `extended/regression/`

---

## Resumo de Cobertura

| Área | Total | Cobertos | Parcial | Não cobertos |
|------|-------|----------|---------|--------------|
| 1. Autenticação | 12 | 10 | 0 | 2 |
| 2. Flows CRUD | 18 | 16 | 1 | 1 |
| 3. Pastas | 10 | 8 | 1 | 1 |
| 4. Canvas Editor | 35 | 33 | 1 | 1 |
| 5. Config Componentes | 25 | 20 | 0 | 5 |
| 6. Playground | 18 | 15 | 1 | 2 |
| 7. Templates | 35 | 33 | 0 | 2 |
| 8. LLM Providers | 18 | 16 | 0 | 2 |
| 9. Componentes | 25 | 19 | 0 | 6 |
| 10. API REST | 20 | 19 | 0 | 1 |
| 11. MCP Server | 5 | 3 | 0 | 2 |
| 12. Observabilidade | 6 | 6 | 0 | 0 |
| 13. Settings | 4 | 4 | 0 | 0 |
| 14. Erros / Edge Cases | 10 | 6 | 0 | 4 |
| **TOTAL** | **241** | **228 (95%)** | **4** | **29 (5%)** |

> _Atualizado em 2026-03-10 (sessão 3) — novos testes: claude-model-switch, api-custom-component, remove-provider-api-key, group-enter-exit, settings-theme-toggle, traces-latency-tokens, agent-reasoning-steps, outdated-component-notification, save-flow-as-template. Correções: settings-appearance (skipModal), global-variable-remove (skipModal)._

---

## Prioridades para Automatizar (não cobertos)

### 🔴 Alta Prioridade (bloqueadores de release)
1. Erro de API key inválida (OpenAI/Anthropic)
2. Flow com erro Python exibe mensagem clara
3. Atualização com breaking change — deve alertar usuário
4. Erro de rede durante execução

### 🟡 Média Prioridade (regressão importante)
5. Webhook trigger externo
6. Agent — steps de raciocínio no Playground
7. Playground compartilhável (URL pública)
8. Importar flow com componentes desatualizados
9. Admin altera senha de usuário
10. Editar variável global existente

### 🟢 Baixa Prioridade (melhorias de cobertura)
11. Loop component — iterações corretas
12. MCP server endpoint gerado
13. Traces com latência e tokens
14. Scroll para navegar no canvas
15. Modo fullscreen do Playground
16. GET `/api/v1/monitor/messages` — histórico de mensagens
