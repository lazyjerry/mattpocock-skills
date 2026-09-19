# 議題追蹤系統：本機 Markdown

本儲存庫的議題（issues）與規格文件（spec）以 Markdown 檔案的形式，存放於 `.scratch/` 目錄中。

## 慣例

- 每個功能一個目錄：`.scratch/<feature-slug>/`
- 規格文件為 `.scratch/<feature-slug>/spec.md`
- 實作議題以每張工單一個檔案的方式存放於 `.scratch/<feature-slug>/issues/<NN>-<slug>.md`，從 `01` 開始編號，絕不使用單一合併工單檔案
- 分流狀態記錄於每個議題檔案頂端附近的 `狀態：` 那一行（角色字串請參見 `triage-labels.md`）
- 留言與對話紀錄附加於檔案底部的 `## 留言` 標題之下

## 當某個技能說「發布到議題追蹤系統」時

在 `.scratch/<feature-slug>/` 底下建立新檔案（若目錄不存在則一併建立）。

## 當某個技能說「取得相關工單」時

讀取所參照路徑的檔案。使用者通常會直接提供路徑或議題編號。

## 尋路操作

供 `/wayfinder` 使用。**地圖（map）** 是一份檔案，其中每張工單對應一個**子項（child）**檔案。

- **地圖（Map）**：`.scratch/<effort>/map.md`（「備註／目前已定的決策／迷霧」內容主體）。
- **子工單（Child ticket）**：`.scratch/<effort>/issues/NN-<slug>.md`，從 `01` 開始編號，問題內容置於本文中。`類型：` 那一行記錄工單類型（`research`/`prototype`/`grilling`/`task`）；`狀態：` 那一行記錄 `claimed`/`resolved`。
- **阻擋（Blocking）**：頂端附近的 `受阻於：NN, NN` 那一行。當所列出的每個檔案都為 `resolved` 時，該工單即解除阻擋。
- **前緣（Frontier）**：掃描 `.scratch/<effort>/issues/` 中處於開放（open）、未被阻擋（unblocked）且未被認領（unclaimed）的檔案；編號較小者優先。
- **認領（Claim）**：在動手做任何工作之前，先設為 `狀態：claimed` 並存檔。
- **解決（Resolve）**：在 `## 答案` 標題下附加答案，設為 `狀態：resolved`，接著在 `map.md` 中地圖的「目前已定的決策」段落附加一個情境指標（要點＋連結）。
