import { expect, test, type Page } from '@playwright/test';

function watchRuntimeErrors(page: Page) {
  const errors: string[] = [];
  page.on('pageerror', (error) => errors.push(error.message));
  page.on('console', (message) => {
    if (message.type() === 'error') errors.push(message.text());
  });
  return errors;
}

test('desktop filters, cart state, quantity, remove, login, and checkout work', async ({ page }) => {
  const errors = watchRuntimeErrors(page);
  await page.setViewportSize({ width: 1440, height: 1000 });
  await page.goto('/');
  await expect(page).toHaveTitle(/Oosu Mall/);

  await page.getByTestId('select-category').selectOption('상의');
  await page.getByTestId('select-size').selectOption('M');
  await expect(page.getByTestId('card-product-001')).toBeVisible();
  await expect(page.getByTestId('card-product-122')).toHaveCount(0);
  await page.getByTestId('button-reset-filters').click();

  await page.getByTestId('button-increase-product-001').click();
  await page.getByTestId('button-add-cart-001').click();
  await expect(page.getByTestId('badge-cart-count')).toHaveText('2');
  await page.getByTestId('link-cart-icon').click();
  await expect(page.getByTestId('text-total-items')).toHaveText('2개');
  await page.getByTestId('button-increase-cart-001').click();
  await expect(page.getByTestId('text-total-items')).toHaveText('3개');
  await page.reload();
  await expect(page.getByTestId('text-total-items')).toHaveText('3개');
  await page.getByTestId('button-remove-cart-001').click();
  await expect(page.getByTestId('empty-cart-state')).toBeVisible();

  await page.goto('/account');
  await page.getByTestId('input-login-id').fill('user');
  await page.getByTestId('input-login-password').fill('password');
  await page.getByTestId('button-login').click();
  await expect(page.getByTestId('text-account-id')).toHaveText('user');

  await page.goto('/');
  await page.getByTestId('button-add-cart-122').click();
  await page.goto('/cart');
  await page.getByTestId('button-checkout').click();
  await expect(page.getByTestId('status-checkout-complete')).toBeVisible();
  expect(errors).toEqual([]);
});

test('mobile storefront and cart have no horizontal overflow', async ({ page }) => {
  const errors = watchRuntimeErrors(page);
  await page.setViewportSize({ width: 390, height: 844 });
  await page.goto('/');
  await expect(page.getByTestId('card-product-001')).toBeVisible();
  await expect.poll(() => page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true);
  await page.getByTestId('button-add-cart-001').click();
  await page.goto('/cart');
  await expect(page.getByTestId('panel-cart-summary')).toBeVisible();
  await expect.poll(() => page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true);
  expect(errors).toEqual([]);
});
