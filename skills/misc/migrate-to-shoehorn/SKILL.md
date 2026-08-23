---
name: migrate-to-shoehorn
description: 將測試檔案從 `as` 型別斷言遷移到 @total-typescript/shoehorn。適用於使用者提到 shoehorn、想在測試中取代 `as`、或需要部分測試資料的情況。
---

# 遷移至 Shoehorn

## 為什麼要用 shoehorn？

`shoehorn` 讓你可以在測試中傳入部分資料，同時保持 TypeScript 型別檢查正常運作。它可以取代 `as` 斷言，提供型別安全的替代方案。

**僅限測試程式碼使用。** 絕對不要在正式環境程式碼中使用 shoehorn。

測試中使用 `as` 的問題：

- 養成不好的習慣，不用它反而更好
- 必須手動指定目標型別
- 雙重 as(`as unknown as Type`)用於刻意傳入錯誤資料時

## 安裝

```bash
npm i @total-typescript/shoehorn
```

## 遷移模式

### 只需少數屬性的大型物件

之前：

```ts
type Request = {
  body: { id: string };
  headers: Record<string, string>;
  cookies: Record<string, string>;
  // ...還有 20 個其他屬性
};

it("gets user by id", () => {
  // 只在意 body.id，但卻要偽造整個 Request
  getUser({
    body: { id: "123" },
    headers: {},
    cookies: {},
    // ...要偽造全部 20 個屬性
  });
});
```

之後：

```ts
import { fromPartial } from "@total-typescript/shoehorn";

it("gets user by id", () => {
  getUser(
    fromPartial({
      body: { id: "123" },
    }),
  );
});
```

### `as Type` → `fromPartial()`

之前：

```ts
getUser({ body: { id: "123" } } as Request);
```

之後：

```ts
import { fromPartial } from "@total-typescript/shoehorn";

getUser(fromPartial({ body: { id: "123" } }));
```

### `as unknown as Type` → `fromAny()`

之前：

```ts
getUser({ body: { id: 123 } } as unknown as Request); // 故意傳入錯誤型別
```

之後：

```ts
import { fromAny } from "@total-typescript/shoehorn";

getUser(fromAny({ body: { id: 123 } }));
```

## 各函式的使用時機

| 函式             | 使用情境                                   |
| ---------------- | ------------------------------------------ |
| `fromPartial()`  | 傳入仍能通過型別檢查的部分資料              |
| `fromAny()`      | 刻意傳入錯誤的資料(同時保留自動完成功能）  |
| `fromExact()`    | 強制要求完整物件(之後可換回 fromPartial）  |

## 工作流程

1. **蒐集需求** - 詢問使用者：
   - 哪些測試檔案有造成問題的 `as` 斷言？
   - 他們是否在處理只有部分屬性重要的大型物件？
   - 他們是否需要為了錯誤測試而傳入刻意錯誤的資料？

2. **安裝並遷移**:
   - [ ] 安裝：`npm i @total-typescript/shoehorn`
   - [ ] 找出含有 `as` 斷言的測試檔案：`grep -r " as [A-Z]" --include="*.test.ts" --include="*.spec.ts"`
   - [ ] 將 `as Type` 替換為 `fromPartial()`
   - [ ] 將 `as unknown as Type` 替換為 `fromAny()`
   - [ ] 加入來自 `@total-typescript/shoehorn` 的 import
   - [ ] 執行型別檢查以驗證結果
