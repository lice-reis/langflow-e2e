import type { Page } from "@playwright/test";
import { adjustScreenView } from "../ui/adjust-screen-view";

/**
 * Loads the Simple Agent template and configures the OpenAI provider.
 *
 * Handles both UI states:
 * - "Setup Provider" button visible: no key saved yet → opens dialog and saves key
 * - Model combobox visible: key already saved globally → proceeds without re-entering key
 *
 * Cleans existing flows first to avoid "flow must be unique" 400 error on template creation.
 */
export async function loadSimpleAgentWithOpenAI(page: Page): Promise<void> {
  await page.goto("/");
  await page.waitForSelector('[data-testid="mainpage_title"]', {
    timeout: 30000,
  });

  // Delete all existing flows to avoid "flow must be unique" 400 error
  const emptyPageDescription = page.getByTestId("empty_page_description");
  while ((await emptyPageDescription.count()) === 0) {
    const dropdown = page.getByTestId("home-dropdown-menu").first();
    if (!(await dropdown.isVisible({ timeout: 2000 }).catch(() => false)))
      break;
    await dropdown.click();
    await page.getByTestId("btn_delete_dropdown_menu").first().click();
    await page
      .getByTestId("btn_delete_delete_confirmation_modal")
      .first()
      .click();
    await page.waitForTimeout(500);
  }

  // Open new project modal (empty page has a different button)
  const newProjectBtn = page.getByTestId("new-project-btn");
  const emptyBtn = page.getByTestId("new_project_btn_empty_page");

  if (await newProjectBtn.isVisible({ timeout: 2000 }).catch(() => false)) {
    await newProjectBtn.click();
  } else {
    await emptyBtn.click();
  }

  await page.waitForSelector('[data-testid="modal-title"]', { timeout: 10000 });
  await page.getByTestId("side_nav_options_all-templates").click();
  await page.getByRole("heading", { name: "Simple Agent" }).first().click();

  await page.waitForSelector('[data-testid="canvas_controls_dropdown"]', {
    timeout: 30000,
  });

  await adjustScreenView(page);

  // New UI: "Setup Provider" button (no key) or model combobox (key already saved globally)
  const setupBtn = page.getByRole("button", { name: "Setup Provider" });
  if (await setupBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
    await setupBtn.click();
    await page.waitForSelector('[data-testid="provider-item-OpenAI"]', {
      timeout: 10000,
    });
    await page.getByTestId("provider-item-OpenAI").click();
    await page.getByPlaceholder("sk-...").fill(process.env.OPENAI_API_KEY || "");
    await page.getByRole("button", { name: "Save Configuration" }).click();
    await page.getByRole("button", { name: "Close" }).click();
  }
  // else: OpenAI already configured globally — model combobox is showing, proceed
}
