# Domain Docs（領域文件）

工程技能在探索程式碼庫時，該如何運用這個 repo 的領域文件。

## 探索前，請先閱讀這些

- **`CONTEXT.md`**：位於 repo 根目錄，或
- **`CONTEXT-MAP.md`**：若存在於 repo 根目錄，它會指向各個 context 對應的 `CONTEXT.md`。請閱讀與主題相關的每一份。
- **`docs/adr/`**：閱讀與你即將動手的區域有關的 ADR。在多 context 的 repo 中，也要檢查 `src/<context>/docs/adr/` 是否有該 context 專屬的決策文件。

如果上述檔案不存在，**請靜默略過**。不需要特別指出它們不存在，也不必主動建議先建立它們。`/domain-modeling` 技能（透過 `/grill-with-docs` 與 `/improve-codebase-architecture` 觸發）會在術語或決策真正確定時，才延遲建立這些檔案。

## 檔案結構

單一 context 的 repo（大多數情況）：

```
/
├── CONTEXT.md
├── docs/adr/
│   ├── 0001-event-sourced-orders.md
│   └── 0002-postgres-for-write-model.md
└── src/
```

多 context 的 repo（根目錄存在 `CONTEXT-MAP.md`）：

```
/
├── CONTEXT-MAP.md
├── docs/adr/                          ← 系統層級的決策
└── src/
    ├── ordering/
    │   ├── CONTEXT.md
    │   └── docs/adr/                  ← context 專屬的決策
    └── billing/
        ├── CONTEXT.md
        └── docs/adr/
```

## 使用術語表中的詞彙

當你的輸出要為某個領域概念命名時（例如在 issue 標題、重構提案、假設、測試名稱中），請使用 `CONTEXT.md` 中所定義的詞彙。不要偏離、改用術語表明確避免的同義詞。

如果你需要的概念尚未收錄在術語表中，這是一個訊號：要麼你正在發明這個專案並未使用的用語（應重新考慮），要麼確實存在一個真正的缺口（請將其記錄下來，交給 `/domain-modeling` 處理）。

## 標記出與 ADR 衝突之處

如果你的輸出與現有的 ADR 相牴觸，請明確指出，而不是默默地覆蓋它：

> _與 ADR-0007（事件溯源訂單）相牴觸，但值得重新討論，因為……_
