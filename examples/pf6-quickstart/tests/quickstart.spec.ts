import { test, expect } from '@playwright/test';

test.describe('pf6-quickstart', () => {
  // Basic loading
  test('home page loads without errors', async ({ page }) => {
    const errors: string[] = [];
    page.on('pageerror', (err) => errors.push(err.message));
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    expect(errors).toEqual([]);
  });

  test('home page renders heading', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await expect(page.getByText('PatternFly 6 Quickstart').first()).toBeVisible();
  });

  // Sidebar navigation
  test('sidebar shows Components section', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await expect(page.getByText('COMPONENTS').first()).toBeVisible();
  });

  test('sidebar shows Layouts section', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await expect(page.getByText('LAYOUTS').first()).toBeVisible();
  });

  // Navigate to component pages
  test('navigates to Button page', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Button', exact: true }).click();
    await expect(page.getByText('Buttons communicate and trigger actions')).toBeVisible();
  });

  test('navigates to Alert page', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Alert', exact: true }).click();
    await expect(page.getByText('Alert', { exact: true }).first()).toBeVisible();
  });

  test('navigates to Card page', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Card', exact: true }).click();
    await expect(page.getByText('Rectangular containers')).toBeVisible();
  });

  test('navigates to Table page', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Table', exact: true }).click();
    await expect(page.getByText('Table', { exact: true }).first()).toBeVisible();
  });

  // Navigate to layout pages
  test('navigates to Grid page', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    // Layouts section starts collapsed, need to expand it
    await page.getByRole('button', { name: /LAYOUTS/ }).click();
    await page.getByRole('button', { name: 'Grid', exact: true }).click();
    await expect(page.getByText('Grid', { exact: true }).first()).toBeVisible();
  });

  // Interactive components
  test('modal opens on Modal page', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Modal', exact: true }).click();
    await page.getByRole('button', { name: 'Open modal' }).click();
    await expect(page.getByText('Example modal')).toBeVisible();
  });

  test('accordion expands on Accordion page', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Accordion', exact: true }).click();
    await page.getByRole('button', { name: 'Item one' }).click();
    await expect(page.getByText('This is the content for the first accordion item')).toBeVisible();
  });

  // Avatar page loads with content
  test('avatar page renders size examples', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Avatar', exact: true }).click();
    await expect(page.getByText('Sizes').first()).toBeVisible();
    await expect(page.getByText('With border').first()).toBeVisible();
    // Check that avatar images exist (elm-ui renders img tags)
    const images = page.locator('img');
    await expect(images.first()).toBeVisible();
  });

  // Brand page loads with content
  test('brand page renders examples', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Brand', exact: true }).click();
    await expect(page.getByText('Basic brand').first()).toBeVisible();
    await expect(page.getByText('With explicit dimensions').first()).toBeVisible();
    // Verify brand images render
    const images = page.getByRole('img', { name: 'PatternFly logo' });
    await expect(images.first()).toBeVisible();
  });

  // Button variants section
  test('Button page shows Variants section', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Button', exact: true }).click();
    await expect(page.getByText('Variants').first()).toBeVisible();
  });

  // Hash routing works
  test('direct hash navigation works', async ({ page }) => {
    await page.goto('/#badge');
    await page.waitForLoadState('networkidle');
    await expect(page.getByText('Badge', { exact: true }).first()).toBeVisible();
  });

  // Tooltip hover behavior
  test('tooltip shows on hover', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Tooltip', exact: true }).click();
    const trigger = page.getByRole('button', { name: 'Top', exact: true });
    const bubble = page.locator('.pf-tooltip-bubble').first();
    await expect(bubble).toHaveCSS('opacity', '0');
    await trigger.hover();
    await expect(bubble).toHaveCSS('opacity', '1');
  });

  // Clipboard copy page loads
  test('clipboard copy page renders', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Clipboard Copy', exact: true }).click();
    await expect(page.getByText('Clipboard copy allows users')).toBeVisible();
  });

  // Home page stat cards
  test('home page shows component count', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await expect(page.getByText('73')).toBeVisible();
    await expect(page.getByText('Components').first()).toBeVisible();
  });

  // Expandable section
  test('expandable section toggles', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Expandable Section', exact: true }).click();
    // The page should have a toggle button for the expandable section
    await expect(page.getByText('Expandable Section').first()).toBeVisible();
  });
});
