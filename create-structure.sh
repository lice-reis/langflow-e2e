#!/usr/bin/env bash

set -euo pipefail

echo "=== Creating complete tests automation directory structure ==="
echo ""

# Phase 1: Create tests-automations main structure
echo "Phase 1: Creating tests-automations structure..."
mkdir -p tests/tests-automations/{regression,smoke}

# Regression substructure (vazio por enquanto - testes virão depois)
mkdir -p tests/tests-automations/regression/{ux,mcp,api}
mkdir -p tests/tests-automations/regression/ux/{flows,components,playground}
mkdir -p tests/tests-automations/regression/mcp/{tools,agents}
mkdir -p tests/tests-automations/regression/api/{auth,flows}

# Smoke substructure (vazio por enquanto)
mkdir -p tests/tests-automations/smoke/{ux,api}

echo "✓ tests-automations structure created (ready for tests)"

# Phase 2: Create helpers structure
echo ""
echo "Phase 2: Creating helpers structure..."
mkdir -p tests/helpers/{auth,flows,mcp,api,filesystem,ui,other}
echo "✓ helpers structure created"

# Phase 3: Create pages structure
echo ""
echo "Phase 3: Creating pages structure..."
mkdir -p tests/pages/{auth,flows,main,components}
echo "✓ pages structure created"

# Phase 4: Create fixtures and assets structure
echo ""
echo "Phase 4: Creating fixtures and assets structure..."
mkdir -p tests/fixtures
mkdir -p tests/assets/{flows,files,media}
echo "✓ fixtures and assets structure created"

# Phase 5: Copy helpers
echo ""
echo "Phase 5: Copying helpers to organized structure..."

# helpers/auth/
cp -f legacy-old-structure/utils/login-langflow.ts tests/helpers/auth/ 2>/dev/null || echo "  ⚠ login-langflow.ts not found"
cp -f legacy-old-structure/utils/auth-helpers.ts tests/helpers/auth/ 2>/dev/null || echo "  ⚠ auth-helpers.ts not found"
cp -f legacy-old-structure/utils/get-auth-token.ts tests/helpers/auth/ 2>/dev/null || echo "  ⚠ get-auth-token.ts not found"
cp -f legacy-old-structure/utils/add-new-user-and-loggin.ts tests/helpers/auth/ 2>/dev/null || echo "  ⚠ add-new-user-and-loggin.ts not found"

# helpers/flows/
cp -f legacy-old-structure/utils/add-flow-to-test-on-empty-langflow.ts tests/helpers/flows/ 2>/dev/null || echo "  ⚠ add-flow-to-test-on-empty-langflow.ts not found"
cp -f legacy-old-structure/utils/add-custom-component.ts tests/helpers/flows/ 2>/dev/null || echo "  ⚠ add-custom-component.ts not found"
cp -f legacy-old-structure/utils/add-legacy-components.ts tests/helpers/flows/ 2>/dev/null || echo "  ⚠ add-legacy-components.ts not found"
cp -f legacy-old-structure/utils/rename-flow.ts tests/helpers/flows/ 2>/dev/null || echo "  ⚠ rename-flow.ts not found"
cp -f legacy-old-structure/utils/lock-flow.ts tests/helpers/flows/ 2>/dev/null || echo "  ⚠ lock-flow.ts not found"
cp -f legacy-old-structure/utils/clean-all-flows.ts tests/helpers/flows/ 2>/dev/null || echo "  ⚠ clean-all-flows.ts not found"
cp -f legacy-old-structure/utils/run-chat-output.ts tests/helpers/flows/ 2>/dev/null || echo "  ⚠ run-chat-output.ts not found"
cp -f legacy-old-structure/utils/load-simple-agent-with-openai.ts tests/helpers/flows/ 2>/dev/null || echo "  ⚠ load-simple-agent-with-openai.ts not found"

# helpers/mcp/
cp -f legacy-old-structure/utils/select-gpt-model.ts tests/helpers/mcp/ 2>/dev/null || echo "  ⚠ select-gpt-model.ts not found"
cp -f legacy-old-structure/utils/select-anthropic-model.ts tests/helpers/mcp/ 2>/dev/null || echo "  ⚠ select-anthropic-model.ts not found"
cp -f legacy-old-structure/utils/add-new-api-keys.ts tests/helpers/mcp/ 2>/dev/null || echo "  ⚠ add-new-api-keys.ts not found"
cp -f legacy-old-structure/utils/add-open-ai-input-key.ts tests/helpers/mcp/ 2>/dev/null || echo "  ⚠ add-open-ai-input-key.ts not found"
cp -f legacy-old-structure/utils/remove-old-api-keys.ts tests/helpers/mcp/ 2>/dev/null || echo "  ⚠ remove-old-api-keys.ts not found"
cp -f legacy-old-structure/utils/open-add-mcp-server-modal.ts tests/helpers/mcp/ 2>/dev/null || echo "  ⚠ open-add-mcp-server-modal.ts not found"

# helpers/api/
cp -f legacy-old-structure/utils/build-data-transfer.ts tests/helpers/api/ 2>/dev/null || echo "  ⚠ build-data-transfer.ts not found"
cp -f legacy-old-structure/utils/get-all-response-message.ts tests/helpers/api/ 2>/dev/null || echo "  ⚠ get-all-response-message.ts not found"

# helpers/filesystem/
cp -f legacy-old-structure/utils/generate-filename.ts tests/helpers/filesystem/ 2>/dev/null || echo "  ⚠ generate-filename.ts not found"
cp -f legacy-old-structure/utils/clean-old-folders.ts tests/helpers/filesystem/ 2>/dev/null || echo "  ⚠ clean-old-folders.ts not found"
cp -f legacy-old-structure/utils/upload-file.ts tests/helpers/filesystem/ 2>/dev/null || echo "  ⚠ upload-file.ts not found"
cp -f legacy-old-structure/utils/convert-test-name.tsx tests/helpers/filesystem/ 2>/dev/null || echo "  ⚠ convert-test-name.tsx not found"

# helpers/ui/
cp -f legacy-old-structure/utils/simulate-drag-and-drop.ts tests/helpers/ui/ 2>/dev/null || echo "  ⚠ simulate-drag-and-drop.ts not found"
cp -f legacy-old-structure/utils/adjust-screen-view.ts tests/helpers/ui/ 2>/dev/null || echo "  ⚠ adjust-screen-view.ts not found"
cp -f legacy-old-structure/utils/zoom-out.ts tests/helpers/ui/ 2>/dev/null || echo "  ⚠ zoom-out.ts not found"
cp -f legacy-old-structure/utils/unselect-nodes.ts tests/helpers/ui/ 2>/dev/null || echo "  ⚠ unselect-nodes.ts not found"
cp -f legacy-old-structure/utils/open-advanced-options.ts tests/helpers/ui/ 2>/dev/null || echo "  ⚠ open-advanced-options.ts not found"
cp -f legacy-old-structure/utils/wait-for-open-modal.ts tests/helpers/ui/ 2>/dev/null || echo "  ⚠ wait-for-open-modal.ts not found"
cp -f legacy-old-structure/utils/go-to-settings.ts tests/helpers/ui/ 2>/dev/null || echo "  ⚠ go-to-settings.ts not found"

# helpers/other/
cp -f legacy-old-structure/utils/initialGPTsetup.ts tests/helpers/other/ 2>/dev/null || echo "  ⚠ initialGPTsetup.ts not found"
cp -f legacy-old-structure/utils/extract-and-clean-code.ts tests/helpers/other/ 2>/dev/null || echo "  ⚠ extract-and-clean-code.ts not found"
cp -f legacy-old-structure/utils/evaluate-input-react-state-changes.ts tests/helpers/other/ 2>/dev/null || echo "  ⚠ evaluate-input-react-state-changes.ts not found"
cp -f legacy-old-structure/utils/withEventDeliveryModes.ts tests/helpers/other/ 2>/dev/null || echo "  ⚠ withEventDeliveryModes.ts not found"
cp -f legacy-old-structure/utils/await-bootstrap-test.ts tests/helpers/other/ 2>/dev/null || echo "  ⚠ await-bootstrap-test.ts not found"

echo "✓ Helpers copied to organized structure"

# Phase 6: Copy pages
echo ""
echo "Phase 6: Copying pages to organized structure..."

cp -f legacy-old-structure/pages/BasePage.ts tests/pages/ 2>/dev/null || echo "  ⚠ BasePage.ts not found"
cp -f legacy-old-structure/pages/LoginPage.ts tests/pages/auth/ 2>/dev/null || echo "  ⚠ LoginPage.ts not found"
cp -f legacy-old-structure/pages/FlowEditorPage.ts tests/pages/flows/ 2>/dev/null || echo "  ⚠ FlowEditorPage.ts not found"
cp -f legacy-old-structure/pages/PlaygroundPage.ts tests/pages/flows/ 2>/dev/null || echo "  ⚠ PlaygroundPage.ts not found"
cp -f legacy-old-structure/pages/MainPage.ts tests/pages/main/ 2>/dev/null || echo "  ⚠ MainPage.ts not found"
cp -f legacy-old-structure/pages/components/SidebarComponent.ts tests/pages/components/ 2>/dev/null || echo "  ⚠ SidebarComponent.ts not found"

echo "✓ Pages copied to organized structure"

# Phase 7: Copy fixtures
echo ""
echo "Phase 7: Copying fixtures..."

cp -f legacy-old-structure/fixtures.ts tests/fixtures/ 2>/dev/null || echo "  ⚠ fixtures.ts not found"

echo "✓ Fixtures copied"

# Phase 8: Copy and organize assets
echo ""
echo "Phase 8: Copying and organizing assets..."

# Flows (JSON files)
for file in legacy-old-structure/assets/*.json; do
  [ -e "$file" ] && cp -f "$file" tests/assets/flows/ 2>/dev/null
done

# Files (Python and text)
for file in legacy-old-structure/assets/*.py legacy-old-structure/assets/*.txt; do
  [ -e "$file" ] && cp -f "$file" tests/assets/files/ 2>/dev/null
done

# Media (Audio and images)
for file in legacy-old-structure/assets/*.wav legacy-old-structure/assets/*.png; do
  [ -e "$file" ] && cp -f "$file" tests/assets/media/ 2>/dev/null
done

echo "✓ Assets copied and organized"

# Final summary
echo ""
echo "=========================================="
echo "✓ Structure migration completed!"
echo "=========================================="
echo ""
echo "Directory structure created:"
echo "tests/"
echo "├── tests-automations/"
echo "│   ├── regression/ux/ (flows, components, playground) - READY FOR TESTS"
echo "│   ├── regression/mcp/ (tools, agents) - READY FOR TESTS"
echo "│   ├── regression/api/ (auth, flows) - READY FOR TESTS"
echo "│   └── smoke/ (ux, api) - READY FOR TESTS"
echo "├── helpers/ (auth, flows, mcp, api, filesystem, ui, other) - ✓ POPULATED"
echo "├── pages/ (auth, flows, main, components) - ✓ POPULATED"
echo "├── fixtures/ - ✓ POPULATED"
echo "├── assets/ (flows, files, media) - ✓ POPULATED"
echo "└── legacy-old-structure/ - PRESERVED"
echo ""
echo "Next steps:"
echo "1. Review import statements in helpers and pages"
echo "2. Update relative imports if needed (e.g., ../utils/ → relative path)"
echo "3. Run 'npm run build' to validate TypeScript"
echo "4. Copy test files to tests-automations/ as you validate each one"
echo ""
