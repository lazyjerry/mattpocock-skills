# 深化

給定其依賴關係，說明如何安全地深化一組淺層模組（shallow modules）。假設你已熟悉 [SKILL.md](SKILL.md) 中的詞彙：**module**、**interface**、**seam**、**adapter**。

## 依賴分類

在評估一個深化候選對象時，請對其依賴進行分類。這個分類會決定深化後的模組要如何跨越 seam 進行測試。

### 1. 行程內（In-process）

純運算、記憶體內狀態，沒有 I/O。永遠可以深化：合併模組，並直接透過新的 interface 進行測試。不需要 adapter。

### 2. 可本地替代（Local-substitutable）

擁有本地測試替身（test stand-in）的依賴（例如 Postgres 用 PGLite、檔案系統用記憶體內檔案系統）。若替身存在，就可以深化。深化後的模組會在測試套件中搭配該替身執行測試。此時 seam 是內部的，不會在模組的外部 interface 上開放 port。

### 3. 遠端但自有（Ports & Adapters）

跨越網路邊界的自有服務（微服務、內部 API）。在 seam 處定義一個 **port**（interface）。深層模組（deep module）擁有邏輯；傳輸層則以 **adapter** 的形式注入。測試使用記憶體內 adapter，正式環境則使用 HTTP/gRPC/queue adapter。

建議的表達方式：「在 seam 處定義一個 port，為正式環境實作一個 HTTP adapter，為測試實作一個記憶體內 adapter，這樣即使部署跨越網路，邏輯仍然集中在單一深層模組中。」

### 4. 真正的外部（Mock）

你無法掌控的第三方服務（Stripe、Twilio 等）。深化後的模組將外部依賴以注入的 port 形式接收；測試則提供一個 mock adapter。

## Seam 的紀律

- **只有一個 adapter，代表這是假設性的 seam。有兩個 adapter，才代表這是真實的 seam。** 除非至少有兩個 adapter 是合理的（通常是正式環境 + 測試），否則不要引入 port。只有單一 adapter 的 seam 只是多一層間接而已。
- **內部 seam 與外部 seam。** 一個深層模組除了在其 interface 處有外部 seam 外，也可以擁有內部 seam（僅供其自身實作使用，供自己的測試呼叫）。不要只因為測試會用到內部 seam，就透過 interface 把它們暴露出來。

## 測試策略：替換而非疊層

- 一旦在深化後模組的 interface 上已經有測試存在，原本針對淺層模組（shallow modules）所寫的舊單元測試就變成了無用的東西；請刪除它們。
- 在深化後模組的 interface 上撰寫新的測試。**interface 就是測試表面（test surface）**。
- 測試應該針對透過 interface 可觀察到的結果來斷言（assert），而不是針對內部狀態。
- 測試應該要能撐過內部重構，因為它們描述的是行為（behaviour），而不是實作方式。如果一個測試在實作改變時必須跟著修改，就代表它測到了 interface 以外的東西。
