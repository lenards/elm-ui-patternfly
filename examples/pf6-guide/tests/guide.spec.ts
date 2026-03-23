import { test, expect } from '@playwright/test';

test.describe('pf6-guide', () => {
  test('page loads without errors', async ({ page }) => {
    const errors: string[] = [];
    page.on('pageerror', (err) => errors.push(err.message));

    await page.goto('/');
    await page.waitForLoadState('networkidle');

    expect(errors).toEqual([]);
  });

  test('renders the home page heading', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await expect(page.getByText('PatternFly 6').first()).toBeVisible();
  });

  test('navigates to Primitives section', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Primitives' }).click();
    await expect(page.getByText('Button')).toBeVisible();
  });

  test('navigates to Forms section', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Forms' }).click();
    await expect(page.getByText('TextInput')).toBeVisible();
  });

  test('navigates to Feedback section', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Feedback & Status' }).click();
    await expect(page.getByText('Alert')).toBeVisible();
  });

  test('navigates to Navigation section', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Navigation' }).click();
    await expect(page.getByText('Breadcrumb')).toBeVisible();
  });

  test('navigates to Overlays section', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Overlays' }).click();
    await expect(page.getByText('Modal', { exact: true }).first()).toBeVisible();
  });

  test('navigates to Content section', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Content' }).click();
    await expect(page.getByText('CodeBlock')).toBeVisible();
  });

  test('navigates to Data section', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Data' }).click();
    await expect(page.getByText('Table')).toBeVisible();
  });

  test('modal opens and closes', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Overlays' }).click();
    await page.getByRole('button', { name: 'Open modal' }).click();
    await expect(page.getByText('Confirm action')).toBeVisible();
    await page.getByRole('button', { name: 'Cancel' }).click();
    await expect(page.getByText('Confirm action')).not.toBeVisible();
  });

  test('accordion expands and collapses', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Overlays' }).click();
    await page.getByRole('button', { name: 'What is PatternFly?' }).click();
    await expect(page.getByText('PatternFly is an open source design system')).toBeVisible();
    await page.getByRole('button', { name: 'What is PatternFly?' }).click();
    await expect(page.getByText('PatternFly is an open source design system')).not.toBeVisible();
  });

  test('text input accepts typing', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.getByRole('button', { name: 'Forms' }).click();
    const input = page.locator('input').first();
    await input.fill('hello');
    await expect(input).toHaveValue('hello');
  });

  test('content area is scrollable — last section reachable', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // Navigate to a section with lots of content
    await page.getByRole('button', { name: 'Primitives' }).click();

    // The Divider section heading should be reachable by scrolling
    // Use exact match to avoid matching "Above divider" / "Below divider" text
    const dividerHeading = page.getByText('Divider', { exact: true }).first();
    await expect(dividerHeading).toBeAttached();
    await dividerHeading.scrollIntoViewIfNeeded();
    await expect(dividerHeading).toBeVisible();
  });

  test('content area scroll position resets between sections', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // Scroll to the bottom of Primitives
    await page.getByRole('button', { name: 'Primitives' }).click();
    const dividerHeading = page.getByText('Divider', { exact: true }).first();
    await expect(dividerHeading).toBeAttached();
    await dividerHeading.scrollIntoViewIfNeeded();

    // Switch section — top content should be visible without scrolling
    await page.getByRole('button', { name: 'Forms' }).click();
    await expect(page.getByText('TextInput')).toBeVisible();
  });
});
