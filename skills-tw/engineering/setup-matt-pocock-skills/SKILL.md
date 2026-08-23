---
name: setup-matt-pocock-skills
description: "設定此儲存庫以配合工程技能使用：設定議題追蹤系統、分流標籤詞彙，以及領域文件架構。在首次使用其他工程技能前先執行一次。"
disable-model-invocation: true
---

# 設定 Matt Pocock 的技能

搭建工程技能所預期的每個儲存庫設定：

- **議題追蹤系統**：議題存放的位置（預設為 GitHub；也內建支援本地 markdown）
- **分流標籤**：五種標準分流角色所使用的字串
- **領域文件**：`CONTEXT.md` 與 ADR 存放的位置，以及讀取這些文件時的規則

這是一個由提示詞驅動的技能，而非一套確定性的腳本。先探索、呈現找到的內容、與使用者確認，然後才寫入。

## 流程

### 1. 探索

檢視目前的儲存庫，了解其初始狀態。閱讀既有的內容；不要憑空假設：

- `git remote -v` 與 `.git/config`：這是 GitHub 儲存庫嗎？是哪一個？
- 儲存庫根目錄下的 `AGENTS.md` 與 `CLAUDE.md`：兩者是否存在其一？其中是否已經有 `## Agent skills` 區塊？
- 儲存庫根目錄下的 `CONTEXT.md` 與 `CONTEXT-MAP.md`
- `docs/adr/` 以及任何 `src/*/docs/adr/` 目錄
- `docs/agents/`：這個技能先前的輸出是否已經存在？
- `.scratch/`：代表已經在使用本地 markdown 議題追蹤慣例的跡象
- 是否已安裝 `triage` 技能？(在此技能旁邊是否有 `triage` 技能資料夾，或在可用技能中是否有 `triage`。)這將決定 B 節是否執行。
- Monorepo 跡象：`pnpm-workspace.yaml`、`package.json` 中的 `workspaces` 欄位，或帶有各自 `src/` 的已填充 `packages/*`。這些只會出現在真正大型的多套件儲存庫中；若不存在，則代表單一情境，而這是絕大多數儲存庫的情況。

### 2. 呈現發現並提問

摘要目前已有與缺少的內容。接著依序處理各節。一節一答，再進行下一節。

每一節都先給出建議答案，讓使用者能用一個字就接受。只有在選擇確實會分歧時才給出一行說明；若探索階段已經確定了答案，就直接略過該節(若未安裝 `triage` 則略過 B 節，若非 monorepo 則略過 C 節)。

**A 節：議題追蹤系統。**

> 說明：「議題追蹤系統」是此儲存庫議題存放的位置。像 `to-tickets`、`triage` 與 `to-spec` 這類技能會從中讀取並寫入。它們需要知道該呼叫 `gh issue create`、在 `.scratch/` 下寫入 markdown 檔案，還是遵循你描述的其他工作流程。請選擇你實際追蹤此儲存庫工作的地方。

預設立場：這些技能是為 GitHub 設計的。若某個 `git remote` 指向 GitHub，就提議這個選項。若某個 `git remote` 指向 GitLab(`gitlab.com` 或自架主機)，就提議 GitLab。否則（或使用者偏好其他選項時），提供以下選擇：

- **GitHub**：議題存放在此儲存庫的 GitHub Issues 中(使用 `gh` CLI)
- **GitLab**：議題存放在此儲存庫的 GitLab Issues 中(使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI)
- **本地 markdown**：議題以檔案形式存放在此儲存庫的 `.scratch/<feature>/` 下（適合個人專案或沒有遠端儲存庫的情況）
- **其他**（Jira、Linear 等）：請使用者用一段文字描述工作流程；此技能會將其記錄為自由格式文字

將選擇記錄於 `docs/agents/issue-tracker.md`。GitHub 與 GitLab 範本帶有一個「PR 作為請求來源」的旗標，預設為**關閉**。保持關閉且不需主動提及：若使用者想讓外部 PR 進入分流佇列，之後可以在檔案中自行開啟該旗標。

**B 節：分流標籤詞彙。** 若未安裝 `triage` 技能（探索階段已經告知你），就完全略過此節，因為未安裝的技能不需要標籤。

若已安裝，則只問一個問題：

> 你想保留預設的分流標籤嗎？(建議：**是**)

預設值是五種標準角色，每個標籤字串與其名稱相同：`needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human`、`wontfix`。若回答**是**，就原樣寫入。只有在使用者回答否時(通常是因為他們的追蹤系統已使用其他名稱，例如以 `bug:triage` 代替 `needs-triage`)，才收集覆寫值，讓 `triage` 套用既有標籤，而非建立重複標籤。

**C 節：領域文件。** 預設為**單一情境**(儲存庫根目錄下只有一個 `CONTEXT.md` 加 `docs/adr/`)。這適用於絕大多數儲存庫，無需詢問即可直接寫入。

只有在探索階段發現 monorepo 跡象時，才提供**多重情境**選項(根目錄下的 `CONTEXT-MAP.md` 指向各情境專屬的 `CONTEXT.md` 檔案)。此時再與使用者確認要採用哪種架構。

### 3. 確認並編輯

向使用者展示以下內容的草稿：

- 要加入 `CLAUDE.md` 或 `AGENTS.md`（視第 4 步的選擇規則而定，決定要編輯哪一個）的 `## Agent skills` 區塊
- `docs/agents/issue-tracker.md`、`docs/agents/domain.md` 與 `docs/agents/triage-labels.md` 的內容(最後一項僅在已安裝 `triage` 時提供)

在寫入前讓使用者能夠編輯。

### 4. 寫入

**選擇要編輯的檔案：**

- 若 `CLAUDE.md` 存在，編輯它。
- 否則若 `AGENTS.md` 存在，編輯它。
- 若兩者皆不存在，詢問使用者要建立哪一個；不要替他們決定。

當 `CLAUDE.md` 已存在時，絕不建立 `AGENTS.md`（反之亦然）；永遠編輯既有的那一個。

若所選檔案中已經有 `## Agent skills` 區塊，就地更新其內容，而非重複附加。不要覆寫使用者對周邊區段所做的編輯。

該區塊內容如下：

```markdown
## Agent skills

### Issue tracker

[議題追蹤位置的一行摘要]。詳見 `docs/agents/issue-tracker.md`。

### Triage labels

[標籤詞彙的一行摘要]。詳見 `docs/agents/triage-labels.md`。

### Domain docs

[版面配置的一行摘要：「single-context」或「multi-context」]。詳見 `docs/agents/domain.md`。
```

只有在已安裝 `triage` 且 B 節有執行時，才納入 `### Triage labels` 子區塊，並寫入 `docs/agents/triage-labels.md`。若未安裝，則兩者皆省略。

接著以此技能資料夾中的種子範本為起點，寫入文件檔案：

- [issue-tracker-github.md](./issue-tracker-github.md):GitHub 議題追蹤系統
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md):GitLab 議題追蹤系統
- [issue-tracker-local.md](./issue-tracker-local.md)：本地 markdown 議題追蹤系統
- [triage-labels.md](./triage-labels.md)：標籤對應(僅在已安裝 `triage` 時)
- [domain.md](./domain.md)：領域文件讀取規則與版面配置

對於「其他」議題追蹤系統，請根據使用者的描述從頭撰寫 `docs/agents/issue-tracker.md`。

### 5. 完成

告訴使用者設定已完成，以及哪些工程技能現在會讀取這些檔案。提及他們之後可以直接編輯 `docs/agents/*.md`；只有在想切換議題追蹤系統或從頭重新開始時，才需要重新執行此技能。
