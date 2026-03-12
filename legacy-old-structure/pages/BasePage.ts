import type { Page } from "@playwright/test";

export abstract class BasePage {
  constructor(protected readonly page: Page) {}

  async goto(path: string = "/") {
    await this.page.goto(path);
  }

  async waitForSelector(selector: string, timeout = 30000) {
    await this.page.waitForSelector(selector, { timeout });
  }

  async getByTestId(testId: string) {
    return this.page.getByTestId(testId);
  }
}
