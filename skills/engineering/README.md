# 工程

我每天用來寫程式的技能。

## 使用者觸發

只有在你打字輸入時才能觸發（Claude Code：`disable-model-invocation: true`；Codex：在 `agents/openai.yaml` 中的 `policy.allow_implicit_invocation: false`）。

- **[ask-matt](./ask-matt/SKILL.md)**：詢問哪個技能或流程適合你目前的情況。這是本儲存庫中使用者觸發技能的路由器。
- **[grill-with-docs](./grill-with-docs/SKILL.md)**：一種盤問式討論，同時建構你專案的領域模型，精煉術語，並就地更新 `CONTEXT.md` 和 ADR。
- **[triage](./triage/SKILL.md)**：讓議題透過分流角色的狀態機逐一推進。
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)**：掃描程式碼庫，找出可以深化的機會，以視覺化的 HTML 報告呈現，接著針對你挑選的項目進行盤問式討論。
- **[setup-matt-pocock-skills](./setup-matt-pocock-skills/SKILL.md)**：為這些工程技能設定此儲存庫（議題追蹤系統、分流標籤、領域文件配置）。每個儲存庫只需執行一次。
- **[to-spec](./to-spec/SKILL.md)**：將目前的對話轉換成規格，並發布到議題追蹤系統。
- **[to-tickets](./to-tickets/SKILL.md)**：將任何計畫、規格或對話拆分成一組追蹤彈式（tracer-bullet）工單，每張工單都會宣告其阻擋邊（blocking edges），無論是以本機檔案中的文字形式，還是實際追蹤器上的原生阻擋連結形式。
- **[implement](./implement/SKILL.md)**：依規格或一組工單所描述的內容進行開發，在事先議定的接縫驅動 `/tdd`，並在提交前以 `/code-review` 收尾。
- **[wayfinder](./wayfinder/SKILL.md)**：將龐大的工作量（超出單一代理工作階段所能負荷的範圍）規劃成議題追蹤系統上一份共享的決策工單地圖，逐一解決，直到通往目的地的路徑清晰為止。

## 模型觸發

可由模型或使用者觸發（具備豐富的觸發語句，方便模型自行取用）。

- **[prototype](./prototype/SKILL.md)**：建立一次性的原型以回答設計上的疑問：可以是包含狀態/邏輯的單一可分享 HTML 檔案，或是數個可切換的 UI 變化版本。

- **[diagnosing-bugs](./diagnosing-bugs/SKILL.md)**：針對棘手臭蟲與效能回歸問題的嚴謹診斷迴圈：針對此臭蟲建立一個會「變紅」的回饋迴圈 → 最小化 → 假設 → 儀器化 → 修復 → 回歸測試。
- **[research](./research/SKILL.md)**：針對高可信度的主要來源調查某個問題，並將調查結果整理成一份附引註的 Markdown 檔案存放於儲存庫中，以背景代理方式執行。
- **[tdd](./tdd/SKILL.md)**：測試驅動開發，採用紅-綠-重構迴圈。一次一個垂直切片地建構功能或修復臭蟲。
- **[domain-modeling](./domain-modeling/SKILL.md)**：主動建構並精煉專案的領域模型，方式是挑戰術語、以情境進行壓力測試，並就地更新 `CONTEXT.md` 和 ADR。
- **[codebase-design](./codebase-design/SKILL.md)**：設計深度模組（deep modules）的共通紀律與詞彙：小介面、乾淨的接縫、可透過介面測試。
- **[code-review](./code-review/SKILL.md)**：針對自某個固定點以來的差異進行雙軸審查：**標準**（是否遵循儲存庫的程式碼規範，以及 Fowler 的程式碼異味基準？）與**規格**（是否忠實實作了源頭的議題/規格？），以平行子代理方式執行。
- **[resolving-merge-conflicts](./resolving-merge-conflicts/SKILL.md)**：逐個衝突區塊處理進行中的 git 合併或重定基底（rebase）衝突，依循可追溯至各方主要來源的意圖來解決，然後完成該操作，絕不使用 `--abort`。
- **[wizard](./wizard/SKILL.md)**：產生一個互動式 bash 精靈，引導使用者完成只有他們自己才能執行的步驟：佈建基礎設施、設定憑證或 CI 密鑰、操作不熟悉的第三方儀表板，或執行一次性的遷移或轉換切換。
