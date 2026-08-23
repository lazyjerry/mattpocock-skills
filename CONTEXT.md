# Matt Pocock Skills

一組由 Claude Code 載入的代理技能（agent skills，包含斜線指令與行為）。技能依 bucket 分類存放，並透過 `/setup-matt-pocock-skills` 產生的各儲存庫設定來使用。

## 詞彙

**議題追蹤系統**（Issue tracker）：
負責承載某個儲存庫議題的工具：GitHub Issues、Linear、本機 `.scratch/` Markdown 慣例，或類似的東西。`to-tickets`、`to-spec`、`triage` 這類技能會讀寫它。
_避免使用_：backlog manager、backlog backend、issue host

**議題**（Issue）：
**議題追蹤系統**裡單一個被追蹤的工作單位：一個 bug、任務、規格，或由 `to-tickets` 產出的切片。
_避免使用_：工單（ticket，僅在引用外部系統自己稱之為 ticket 時使用，或用於下述的**決策工單**）

**決策工單**（Decision ticket）：
`wayfinder` 的單位：`wayfinder:map` 底下的子**議題**，內容是一個*問題*，其解答是一項決策，而不是待執行的建置切片。**決策**這個修飾詞正是它與實作工單的區別所在；`wayfinder` 先引入這個詞，之後就以「ticket」稱之。

**分流角色**（Triage role）：
分流過程中套用在**議題**上的標準狀態機標籤（例如 `needs-triage`、`ready-for-afk`）。每個角色都透過 `docs/agents/triage-labels.md` 對應到**議題追蹤系統**裡真實的標籤字串。

## 關係

- 一個**議題追蹤系統**承載多個**議題**
- 一個**議題**同一時間只帶有一個**分流角色**
- 一張**決策工單**是一個**議題**（`wayfinder:map` 的子項）

## 已標記的歧義

- 「backlog」過去同時被用來指承載議題的*工具*，以及裡面的*工作總量*。已解決：工具稱為**議題追蹤系統**；「backlog」不再作為領域詞彙使用。
- 「backlog backend」／「backlog manager」。已解決：一律收斂為**議題追蹤系統**。
