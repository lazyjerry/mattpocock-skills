# 何時使用 Mock

Mock 只用在**系統邊界**：

- 外部 API（金流、電子郵件等）
- 資料庫（有時候啦，還是建議用測試用的資料庫）
- 時間／隨機性
- 檔案系統（有時候）

不要 mock：

- 自己寫的類別／模組
- 內部協作對象
- 任何你可以掌控的東西

## 設計出容易被 Mock 的介面

在系統邊界處，設計出容易被 mock 的介面。

**1. 使用依賴注入（Dependency Injection）**

把外部依賴當參數傳進來，而不是在內部自己建立：

```typescript
// 容易 mock
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// 難以 mock
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**2. 偏好 SDK 風格的介面，而不是通用的 fetcher**

針對每個外部操作建立專屬函式，而不是用一個含有條件邏輯的通用函式：

```typescript
// 好：每個函式都能各自獨立 mock
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// 不好：mock 時需要在 mock 內部寫條件邏輯
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

採用 SDK 風格的好處：
- 每個 mock 只回傳一種固定的資料結構
- 測試設定不需要條件邏輯
- 更容易看出一個測試會用到哪些 endpoint
- 每個 endpoint 都有各自的型別安全
