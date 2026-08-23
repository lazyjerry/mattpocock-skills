# 議題追蹤系統：GitLab

本專案的議題（issue）與規格書都以 GitLab issue 的形式存在。所有操作請使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI。

## 慣例

- **建立議題**：`glab issue create --title "..." --description "..."`。多行說明請使用 heredoc。若要開啟編輯器，可傳入 `--description -`。
- **讀取議題**：`glab issue view <number> --comments`。若需要機器可讀的輸出，請使用 `-F json`。
- **列出議題**：`glab issue list -F json`，並依需求加上適當的 `--label` 篩選。
- **在議題上留言**：`glab issue note <number> --message "..."`。GitLab 把留言稱為「notes」。
- **套用／移除標籤**：`glab issue update <number> --label "..."` / `--unlabel "..."`。多個標籤可用逗號分隔，或重複使用該旗標。
- **關閉議題**：`glab issue close <number>`。`glab issue close` 不接受附加關閉留言，因此請先用 `glab issue note <number> --message "..."` 發布說明，再執行關閉。
- **合併請求（Merge Requests）**：GitLab 把 PR 稱為「merge requests」。請使用 `glab mr create`、`glab mr view`、`glab mr note` 等指令，用法與 `gh pr ...` 相同，只是把 `pr` 換成 `mr`、把 `comment`/`--body` 換成 `note`/`--message`。

請從 `git remote -v` 推斷所在的儲存庫；當在複製下來的儲存庫中執行時，`glab` 會自動判斷。

## 將合併請求作為分類（triage）介面

**MR 作為請求介面：否。** _（若本專案將外部合併請求視為功能請求，請設為 `yes`；`/triage` 會讀取此旗標。）_

當設為 `yes` 時，MR 會套用與議題相同的標籤與狀態流程，使用對應的 `glab mr` 指令：

- **讀取 MR**：`glab mr view <number> --comments`，以及 `glab mr diff <number>` 可查看差異內容。
- **列出待分類的外部 MR**：`glab mr list -F json`，然後只保留作者不是專案成員／擁有者的 MR（也就是外部貢獻者的 MR，而非維護者正在進行中的工作）。
- **留言／加標籤／關閉**：`glab mr note`、`glab mr update --label`/`--unlabel`、`glab mr close`。

與 GitHub 不同，GitLab 對議題與 MR 是分開編號的，因此一旦知道維護者指的是哪個介面，`#42` 就不會有歧義。

## 當某個 skill 說「publish to the issue tracker」時

請建立一個 GitLab 議題。

## 當某個 skill 說「fetch the relevant ticket」時

請執行 `glab issue view <number> --comments`。

## 尋路（Wayfinding）操作

供 `/wayfinder` 使用。**地圖（map）**是一個議題，其**子項（child）**議題則是各張工單（ticket）。

- **地圖**：一個標記為 `wayfinder:map` 的單一議題，內容包含 Notes / Decisions-so-far / Fog 三個區塊。建立方式：`glab issue create --label wayfinder:map`。（在具備原生 epic 功能的 GitLab 方案中，也可用 epic 來承載地圖；不過用加標籤的議題在任何方案都適用。）
- **子工單**：一個議題，其描述開頭帶有 `Part of #<map>`，並標記 `wayfinder:<type>`（`research`/`prototype`/`grilling`/`task`）。一旦被認領，該工單會指派給負責推進的開發者。
- **阻擋關係（Blocking）**：使用 GitLab 的**原生阻擋連結（native blocking link）**，這是標準且在 UI 上可見的呈現方式。可用 `/blocked_by #<n>` 快速指令加入，方式是發布一則 note（`glab issue note <child> --message "/blocked_by #<blocker>"`）。原生阻擋連結是 Premium/Ultimate 方案的功能；在免費方案（或無法使用該功能時），改用描述開頭的 `Blocked by: #<n>, #<n>` 這一行作為替代方案。當所有阻擋項目都已關閉時，該工單即視為已解除阻擋。
- **前緣查詢（Frontier query）**：`glab issue list -F json`，範圍限定在該地圖的子項議題內，並排除任何有未解除阻擋項目的議題：包含指向未關閉議題的原生 `blocked_by` 連結（`glab api projects/:id/issues/:iid/links`）、描述中 `Blocked by` 那行所指向的未關閉議題，或是已有指派人的議題；依地圖中的順序，第一個符合條件者優先。
- **認領**：`glab issue update <n> --assignee @me`，這是該工作階段的第一個寫入動作。
- **解決**：`glab issue note <n> --message "<answer>"`，接著執行 `glab issue close <n>`，最後在地圖的 Decisions-so-far 區塊附加一個內容指標（gist 連結）。
