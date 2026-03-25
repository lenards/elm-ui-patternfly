import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  globalSetup: './tests/setup.ts',
  use: {
    baseURL: 'http://localhost:8002',
  },
  webServer: {
    command: 'npx serve . -p 8002 -s',
    url: 'http://localhost:8002',
    reuseExistingServer: !process.env.CI,
    timeout: 30000,
  },
});
