# 超出範圍的知識庫

儲存庫中的 `.out-of-scope/` 目錄用來存放被拒絕的功能請求的永久記錄。它有兩個用途：

1. **機構記憶**：為什麼某個功能被拒絕，這樣當議題被關閉時，這個推理過程就不會遺失
2. **去重**：當有新議題進來，且與先前的拒絕紀錄相符時，這個 skill 可以呈現先前的決定，而不是重新討論同一件事

## 目錄結構

```
.out-of-scope/
├── dark-mode.md
├── plugin-system.md
└── graphql-api.md
```

每個**概念**一個檔案，而不是每個議題一個檔案。多個要求相同功能的議題會被歸類在同一個檔案底下。

## 檔案格式

檔案應該以輕鬆、易讀的風格撰寫，比較像是簡短的設計文件，而不是資料庫項目。使用段落、程式碼範例來讓推理過程清楚且對第一次看到的人有用。

```markdown
# Dark Mode

This project does not support dark mode or user-facing theming.

## Why this is out of scope

The rendering pipeline assumes a single color palette defined in
`ThemeConfig`. Supporting multiple themes would require:

- A theme context provider wrapping the entire component tree
- Per-component theme-aware style resolution
- A persistence layer for user theme preferences

This is a significant architectural change that doesn't align with the
project's focus on content authoring. Theming is a concern for downstream
consumers who embed or redistribute the output.

```ts
// The current ThemeConfig interface is not designed for runtime switching:
interface ThemeConfig {
  colors: ColorPalette; // single palette, resolved at build time
  fonts: FontStack;
}
```

## Prior requests

- #42: "Add dark mode support"
- #87: "Night theme for accessibility"
- #134: "Dark theme option"
```

### 檔案命名

為概念取一個簡短、有描述性的 kebab-case 名稱：`dark-mode.md`、`plugin-system.md`、`graphql-api.md`。這個名稱應該要讓瀏覽目錄的人一看就能認出這是什麼被拒絕的內容，不必打開檔案。

### 撰寫理由

理由應該要言之有物：不是「我們不想要這個」，而是為什麼不想要。好的理由會引用：

- 專案範疇或理念（「這個專案聚焦在 X；主題化是下游關注的議題」）
- 技術限制（「支援這個功能需要 Y，這與我們的 Z 架構相衝突」）
- 策略性決定（「我們選擇使用 A 而不是 B，因為……」）

理由應該要能長久成立。避免引用暫時性的情況（「我們現在太忙了」）；那些不是真正的拒絕，而是延後處理。

## 何時查看 `.out-of-scope/`

在分流（第一步：蒐集脈絡）期間，讀取 `.out-of-scope/` 中的所有檔案。在評估新議題時：

- 檢查這個請求是否符合現有的某個超出範圍概念
- 比對方式是概念相似度，而不是關鍵字比對：「night theme」符合 `dark-mode.md`
- 如果有符合的項目，將其呈現給維護者：「這與 `.out-of-scope/dark-mode.md` 類似。我們之前因為 [理由] 拒絕過這個請求。你還是這麼認為嗎？」

維護者可以：

- **確認**：新議題會被加入現有檔案的「Prior requests」清單，然後關閉
- **重新考慮**：超出範圍的檔案會被刪除或更新，議題則進入正常的分流流程
- **不同意**：這些議題相關但不同，依照正常分流流程處理

## 何時寫入 `.out-of-scope/`

只有在**增強功能**（而非錯誤修正）被拒絕標記為 `wontfix` 時才寫入。這適用於增強功能的 PR，就跟適用於議題一樣：被拒絕的 PR 會被記錄在這裡，這樣同一個請求就不會以新程式碼的形式再次出現。

當某個內容因為**已經實作**而以 `wontfix` 關閉時，**不要**寫入這裡。那是已建置的功能，而不是被拒絕的功能；記錄下來會汙染去重檢查，產生錯誤的拒絕紀錄。反之，關閉時的留言應該指向該功能已經存在的地方。

流程如下：

1. 維護者決定某個功能請求超出範圍
2. 檢查是否已經有相符的 `.out-of-scope/` 檔案
3. 如果有：將新議題加入「Prior requests」清單
4. 如果沒有：建立新檔案，包含概念名稱、決定、理由和第一個先前的請求
5. 在議題上留言說明這個決定，並提及 `.out-of-scope/` 檔案
6. 以 `wontfix` 標籤關閉議題

## 更新或移除超出範圍的檔案

如果維護者改變心意，重新考慮先前被拒絕的概念：

- 刪除該 `.out-of-scope/` 檔案
- 這個 skill 不需要重新開啟舊議題；它們是歷史記錄
- 觸發重新考慮的新議題進入正常的分流流程
