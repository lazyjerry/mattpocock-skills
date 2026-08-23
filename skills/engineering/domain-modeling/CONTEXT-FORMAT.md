# CONTEXT.md 格式

## 結構

```md
# {情境名稱}

{一到兩句話說明這個情境是什麼、為什麼存在。}

## 語言

**Order**:
{對這個詞的一到兩句話說明}
_避免使用_: Purchase, transaction

**Invoice**:
在出貨後寄給客戶、要求付款的請款單。
_避免使用_: Bill, payment request

**Customer**:
下訂單的個人或組織。
_避免使用_: Client, buyer, account
```

## 規則

- **要有明確立場。** 當同一個概念存在多個用詞時，選出最適合的一個，並把其他的列在 `_避免使用_` 底下。
- **定義要精簡。** 最多一到兩句話。定義它「是什麼」，而不是它「做什麼」。
- **只收錄這個專案情境特有的詞彙。** 一般性的程式設計概念（timeout、error type、utility pattern 等）即使專案中大量使用，也不應納入。加入詞彙前先問自己：這是這個情境獨有的概念，還是通用的程式設計概念？只有前者才該收錄。
- **依自然分群，把詞彙歸類在子標題底下。** 如果所有詞彙都屬於同一個內聚的領域，用一份扁平列表即可。

## 單一情境 vs 多重情境的儲存庫

**單一情境（大多數儲存庫）：** 在儲存庫根目錄放一份 `CONTEXT.md`。

**多重情境：** 在儲存庫根目錄放一份 `CONTEXT-MAP.md`，列出各個情境所在位置以及彼此之間的關聯：

```md
# 情境地圖

## 情境

- [Ordering](./src/ordering/CONTEXT.md)：接收並追蹤客戶訂單
- [Billing](./src/billing/CONTEXT.md)：產生請款單並處理付款
- [Fulfillment](./src/fulfillment/CONTEXT.md)：管理倉庫揀貨與出貨

## 關聯

- **Ordering → Fulfillment**：Ordering 會發出 `OrderPlaced` 事件；Fulfillment 接收這些事件後開始揀貨
- **Fulfillment → Billing**：Fulfillment 會發出 `ShipmentDispatched` 事件；Billing 接收這些事件後產生請款單
- **Ordering ↔ Billing**：共用 `CustomerId` 與 `Money` 的型別
```

技能會自動推斷適用哪種結構：

- 若存在 `CONTEXT-MAP.md`，則讀取它以找出各個情境
- 若只有根目錄的 `CONTEXT.md`，則為單一情境
- 若兩者皆不存在，則在第一個詞彙被確立時，才延遲建立根目錄的 `CONTEXT.md`

當存在多重情境時，需推斷目前討論的主題屬於哪一個情境。若無法判斷，則需詢問使用者。
