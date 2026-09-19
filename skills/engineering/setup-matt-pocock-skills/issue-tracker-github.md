# 議題追蹤系統：GitHub

本儲存庫的議題（issues）與規格都以 GitHub issues 的形式存在。所有操作皆使用 `gh` CLI。

## 慣例

- **建立議題**：`gh issue create --title "..." --body "..."`。多行內容請使用 heredoc。
- **讀取議題**：`gh issue view <number> --comments`，用 `jq` 篩選留言，並一併取得標籤（labels）。
- **列出議題**：`gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'`，並依需求加上 `--label` 與 `--state` 篩選條件。
- **在議題上留言**：`gh issue comment <number> --body "..."`
- **套用／移除標籤**：`gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **關閉**：`gh issue close <number> --comment "..."`

從 `git remote -v` 推斷所屬儲存庫；在 clone 內執行時，`gh` 會自動處理這件事。

## 把 Pull Request 當作分流（triage）介面

**PR 是否為請求介面：否。**_（若此儲存庫將外部 PR 視為功能請求，請設為 `yes`；`/triage` 會讀取這個旗標。）_

設為 `yes` 時，PR 會走與議題相同的標籤與狀態流程，使用對應的 `gh pr` 指令：

- **讀取 PR**：`gh pr view <number> --comments`，以及 `gh pr diff <number>` 取得 diff。
- **列出待分流的外部 PR**：`gh pr list --state open --json number,title,body,labels,author,authorAssociation,comments`，只保留 `authorAssociation` 為 `CONTRIBUTOR`、`FIRST_TIME_CONTRIBUTOR` 或 `NONE` 的項目（排除 `OWNER`／`MEMBER`／`COLLABORATOR`）。
- **留言／貼標籤／關閉**：`gh pr comment`、`gh pr edit --add-label`/`--remove-label`、`gh pr close`。

GitHub 的議題與 PR 共用同一個編號空間，因此單獨的 `#42` 可能是議題也可能是 PR：先用 `gh pr view 42` 嘗試解析，失敗再退回 `gh issue view 42`。

## 當某個技能說「發布到議題追蹤系統」時

建立一個 GitHub 議題。

## 當某個技能說「取得相關工單」時

執行 `gh issue view <number> --comments`。

## 尋路操作

供 `/wayfinder` 使用。**地圖（map）** 是一個議題，其**子項（child）**議題則是各個工單。

- **地圖**：一個標記 `wayfinder:map` 標籤的單一議題，內容包含「備註／目前已定的決策／迷霧」的本文。使用 `gh issue create --label wayfinder:map`。
- **子工單**：以 GitHub 子議題（sub-issue）的形式連結至地圖的議題（透過 `gh api` 呼叫 sub-issues 端點）。若未啟用子議題功能，則將子項加入地圖本文中的工作清單（task list），並在子項本文最上方加上 `隸屬於 #<map>`。標籤為 `wayfinder:<type>`（`research`／`prototype`／`grilling`／`task`）。一旦被認領，該工單就會指派給負責執行的開發者。
- **阻塞（Blocking）**：使用 GitHub 原生的**議題依賴關係（issue dependencies）**，這是官方且在介面上可見的標準表示方式。以 `gh api --method POST repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>` 新增一條邊，其中 `<blocker-db-id>` 是阻塞方的數字**資料庫 id**（透過 `gh api repos/<owner>/<repo>/issues/<n> --jq .id` 取得，_不是_ `#number` 也不是 `node_id`）。GitHub 會回報 `issue_dependencies_summary.blocked_by`（僅計入尚未關閉的阻塞方，代表即時的放行條件）。若無法使用依賴關係功能，則退回在子項本文最上方加上 `受阻於：#<n>, #<n>` 這一行。當所有阻塞方都已關閉時，該工單即視為解除阻塞。
- **前緣（Frontier）查詢**：列出地圖下所有未關閉的子項（`gh issue list --state open`，範圍限定於該地圖的子議題／工作清單），排除任何仍有未關閉阻塞方（`issue_dependencies_summary.blocked_by > 0`，或 `受阻於` 那行中有未關閉的議題）或已有負責人的項目；依地圖中的順序，第一個符合條件者勝出。
- **認領**：`gh issue edit <n> --add-assignee @me`，作為此工作階段的第一個寫入動作。
- **解決**：先執行 `gh issue comment <n> --body "<answer>"`，再執行 `gh issue close <n>`，最後在地圖的「目前已定的決策」段落附加一個情境指標（要點＋連結）。
