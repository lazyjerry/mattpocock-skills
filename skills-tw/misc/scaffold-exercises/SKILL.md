---
name: scaffold-exercises
description: 建立包含各小節、練習題、解答與說明檔的練習題目錄結構，並通過檢查。適用於使用者想要建立練習題架構、建立練習題範本，或設定新課程小節的情境。
---

# Scaffold Exercises

建立能通過 `pnpm ai-hero-cli internal lint` 檢查的練習題目錄結構，然後使用 `git commit` 提交。

## 目錄命名規則

- **小節（Sections）**：位於 `exercises/` 底下的 `XX-section-name/`（例如 `01-retrieval-skill-building`）
- **練習題（Exercises）**：位於小節底下的 `XX.YY-exercise-name/`（例如 `01.03-retrieval-with-bm25`）
- 小節編號為 `XX`，練習題編號為 `XX.YY`
- 名稱一律採用 dash-case（小寫、以連字號分隔）

## 練習題變體

每個練習題至少需要下列其中一種子資料夾：

- `problem/` - 學生作答工作區，內含 TODO
- `solution/` - 參考解答實作
- `explainer/` - 概念說明內容，不含 TODO

在建立範本時，除非計畫另有指定，否則預設使用 `explainer/`。

## 必要檔案

每個子資料夾（`problem/`、`solution/`、`explainer/`）都需要一份 `readme.md`，且必須：

- **內容不得為空**（需有實際內容，即使只有一行標題也可以）
- 不含失效連結

在建立範本時，請建立一份包含標題與說明的簡易 readme：

```md
# Exercise Title

Description here
```

如果子資料夾中含有程式碼，則還需要一個 `main.ts`（超過 1 行）。但對於範本而言，只有 readme 也是可以接受的。

## 工作流程

1. **解析計畫內容** - 擷取小節名稱、練習題名稱與變體類型
2. **建立目錄** - 為每個路徑執行 `mkdir -p`
3. **建立 readme 範本** - 每個變體資料夾各建立一份含標題的 `readme.md`
4. **執行檢查** - 執行 `pnpm ai-hero-cli internal lint` 進行驗證
5. **修正錯誤** - 反覆修正直到檢查通過為止

## 檢查規則摘要

檢查工具（`pnpm ai-hero-cli internal lint`）會確認以下事項：

- 每個練習題都有對應的子資料夾（`problem/`、`solution/`、`explainer/`）
- `problem/`、`explainer/` 或 `explainer.1/` 至少存在一個
- 在主要子資料夾中存在非空的 `readme.md`
- 沒有 `.gitkeep` 檔案
- 沒有 `speaker-notes.md` 檔案
- readme 內沒有失效連結
- readme 內沒有 `pnpm run exercise` 指令
- 除非只有 readme，否則每個子資料夾都需要 `main.ts`

## 移動／重新命名練習題

在重新編號或搬移練習題時：

1. 使用 `git mv`（而非 `mv`）來重新命名目錄，以保留 git 歷史紀錄
2. 更新數字前綴以維持順序
3. 搬移後請重新執行檢查

範例：

```bash
git mv exercises/01-retrieval/01.03-embeddings exercises/01-retrieval/01.04-embeddings
```

## 範例：依計畫建立練習題範本

假設計畫內容如下：

```
Section 05: Memory Skill Building
- 05.01 Introduction to Memory
- 05.02 Short-term Memory (explainer + problem + solution)
- 05.03 Long-term Memory
```

建立：

```bash
mkdir -p exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer
mkdir -p exercises/05-memory-skill-building/05.02-short-term-memory/{explainer,problem,solution}
mkdir -p exercises/05-memory-skill-building/05.03-long-term-memory/explainer
```

接著建立 readme 範本：

```
exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer/readme.md -> "# Introduction to Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/explainer/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/problem/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/solution/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.03-long-term-memory/explainer/readme.md -> "# Long-term Memory"
```
