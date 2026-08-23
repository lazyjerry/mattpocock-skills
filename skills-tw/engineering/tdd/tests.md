# 良好測試與不良測試

## 良好測試

**整合式測試**：透過真實介面測試，而非模擬內部元件。

```typescript
// GOOD: Tests observable behavior
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

特徵：

- 測試使用者/呼叫端在意的行為
- 只使用公開 API
- 內部重構後仍能通過
- 描述「做什麼」，而非「怎麼做」
- 每個測試只有一個邏輯性斷言

## 不良測試

**實作細節測試**：與內部結構耦合。

```typescript
// BAD: Tests implementation details
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

警訊：

- 模擬內部協作元件
- 測試私有方法
- 針對呼叫次數/順序做斷言
- 沒有行為變更卻因重構而測試失敗
- 測試名稱描述「怎麼做」而非「做什麼」
- 透過外部手段驗證，而非透過介面

```typescript
// BAD: Bypasses interface to verify
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// GOOD: Verifies through interface
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

**恆真測試**：預期值只是把實作邏輯重寫一遍，導致測試必然通過。

```typescript
// BAD: Expected value is recomputed the way the code computes it
test("calculateTotal sums line items", () => {
  const items = [{ price: 10 }, { price: 5 }];
  const expected = items.reduce((sum, i) => sum + i.price, 0);
  expect(calculateTotal(items)).toBe(expected);
});

// GOOD: Expected value is an independent, known literal
test("calculateTotal sums line items", () => {
  expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```
