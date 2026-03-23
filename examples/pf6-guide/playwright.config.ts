import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  globalSetup: './tests/setup.ts',
  use: {
    baseURL: 'http://localhost:8001',
  },
  webServer: {
    command: 'npx serve . -p 8001 -s',
    url: 'http://localhost:8001',
    reuseExistingServer: !process.env.CI,
    timeout: 30000,
  },
});
