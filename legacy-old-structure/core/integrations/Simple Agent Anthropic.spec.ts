import * as dotenv from "dotenv";
import path from "path";
import { expect, test } from "../../fixtures";
import { awaitBootstrapTest } from "../../utils/await-bootstrap-test";
import { withEventDeliveryModes } from "../../utils/withEventDeliveryModes";

withEventDeliveryModes(
  "Simple Agent (Anthropic)",
  { tag: ["@release", "@starter-projects"] },
  async ({ page }) => {
    test.skip(
      !process?.env?.ANTHROPIC_API_KEY,
      "ANTHROPIC_API_KEY required to run this test",
    );

    if (!process.env.CI) {
      dotenv.config({ path: path.resolve(__dirname, "../../.env") });
    }

    await awaitBootstrapTest(page);

    await page.getByTestId("side_nav_options_all-templates").click();
    await page.getByRole("heading", { name: "Simple Agent" }).first().click();

    await page.waitForSelector('[data-testid="canvas_controls_dropdown"]', {
      timeout: 30000,
    });

    // New UI: "Setup Provider" button (no key) or model combobox (key already saved globally)
    const setupBtn = page.getByRole("button", { name: "Setup Provider" });
    if (await setupBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
      await setupBtn.click();
    } else {
      // Provider already configured — click model combobox → Manage Model Providers
      await page.getByTestId("model_model").first().click();
      await page.getByRole("button", { name: "Manage Model Providers" }).click();
    }
    await page.waitForSelector('[data-testid="provider-item-Anthropic"]', { timeout: 10000 });
    await page.getByTestId("provider-item-Anthropic").click();

    // "Save Configuration" only appears when no key is saved yet.
    // On subsequent runs (withEventDeliveryModes reuses the same backend),
    // the key is already stored and the dialog shows "Disconnect"/"Replace Configuration".
    const saveBtn = page.getByRole("button", { name: "Save Configuration" });
    if (await saveBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
      await page.getByPlaceholder("sk-ant-...").fill(process.env.ANTHROPIC_API_KEY || "");
      await saveBtn.click();
    }
    // else: key already saved — models are enabled, just close the dialog

    await page.getByRole("button", { name: "Close" }).click();

    await page.getByTestId("playground-btn-flow-io").click();

    await page
      .getByTestId("input-chat-playground")
      .last()
      .fill("Hello, tell me about Langflow.");

    await page.getByTestId("button-send").last().click();

    const stopButton = page.getByRole("button", { name: "Stop" });
    await stopButton.waitFor({ state: "visible", timeout: 30000 });
    await expect(stopButton).toBeHidden({ timeout: 120000 });

    const textContents = await page
      .getByTestId("div-chat-message")
      .last()
      .innerText();

    expect(textContents.length).toBeGreaterThan(30);

    // header-icon and icon-check appear only when the agent uses tools — soft-check
    const headerIcon = page.getByTestId("header-icon").last();
    if (await headerIcon.isVisible({ timeout: 5000 }).catch(() => false)) {
      await expect(page.getByTestId("icon-check").nth(0)).toBeVisible();
    }

    // duration-display is hidden in playground; ThinkingMessage shows "Finished in Xs" instead
    const finishedText = page.getByText(/Finished in/).last();
    await expect(finishedText).toBeVisible({ timeout: 10000 });
  },
);
