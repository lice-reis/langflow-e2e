import type { Page } from "@playwright/test";
import { adjustScreenView } from "../ui/adjust-screen-view";
import { selectGptModel } from "../mcp/select-gpt-model";
import { updateOldComponents } from "../flows/update-old-components";
import { addOpenAiInputKey } from "../mcp/add-open-ai-input-key";
import { unselectNodes } from "../ui/unselect-nodes";

export async function initialGPTsetup(
  page: Page,
  options?: {
    skipAdjustScreenView?: boolean;
    skipUpdateOldComponents?: boolean;
    skipSelectGptModel?: boolean;
    skipAddOpenAiInputKey?: boolean;
  },
) {
  if (!options?.skipAdjustScreenView) {
    await adjustScreenView(page);
  }
  if (!options?.skipUpdateOldComponents) {
    await updateOldComponents(page);
  }
  if (!options?.skipSelectGptModel) {
    await selectGptModel(page);
  }
  if (!options?.skipAddOpenAiInputKey) {
    await addOpenAiInputKey(page);
  }
  if (!options?.skipAdjustScreenView) {
    await adjustScreenView(page);
  }

  await unselectNodes(page);
}
