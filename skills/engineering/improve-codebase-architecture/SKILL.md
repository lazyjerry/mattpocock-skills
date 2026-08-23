---
name: improve-codebase-architecture
description: 掃描程式碼庫，找出可以深化的機會，以視覺化 HTML 報告呈現，然後針對你選中的項目進行 grill 深談。
disable-model-invocation: true
---

# 改善程式碼庫架構

找出架構上的摩擦點，並提出**深化機會**：將淺層模組（shallow module）轉化為深層模組（deep module）的重構方案。目標是可測試性與 AI 可導覽性（AI-navigability）。

此指令會參考專案的領域模型（domain model），並建立在共享的設計詞彙之上：

- 呼叫 Skill 工具並使用 "codebase-design"，取得架構詞彙（**module**、**interface**、**depth**、**seam**、**adapter**、**leverage**、**locality**）與其原則（刪除測試 deletion test、「介面就是測試表面」、「一個 adapter 是假設性的 seam，兩個才是真實的」）。在每個建議中都精確使用這些詞彙，不要偏移到「component」、「service」、「API」或「boundary」等說法。
- `CONTEXT.md` 中的領域語言為好的 seam 命名；`docs/adr/` 中的 ADR 記錄了此指令不應重新爭論的決策。

## 流程

### 1. 探索

**先界定範圍再掃描：YAGNI。** 深化一個模組的效益在於讓未來對它的變更更容易，所以要特別重視最近變動過的部分。在動手掃描前先決定 *要看哪裡*:

- 如果使用者已指定方向（某個模組、子系統、痛點），就採用它，並跳過下方的推論步驟。
- 否則，回溯一段夠長的 commit 歷史(`git log --oneline`)，找出程式碼庫的熱點，也就是那些反覆出現的檔案與區域，讓這些路徑優先吸引你的注意力。如果變更分散且沒有明顯熱點，就擴大搜尋範圍。

先閱讀專案的領域詞彙表(`CONTEXT.md`)以及你要處理區域中的任何 ADR。

接著派出一個 sub-agent 走查程式碼庫。不要遵循僵化的規則；要有機地探索，並記錄你感受到摩擦的地方：

- 哪裡理解一個概念需要在許多小模組之間來回跳轉？
- 哪些模組是**淺層**的，介面複雜度幾乎和實作一樣高？
- 哪裡的純函式只是為了可測試性而被抽出來，但真正的 bug 卻藏在呼叫它們的方式裡（缺乏 **locality**）?
- 哪些緊密耦合的模組會跨越 seam 洩漏細節？
- 程式碼庫的哪些部分沒有測試，或難以透過目前的介面進行測試？

對任何你懷疑是淺層的部分套用**刪除測試（deletion test）**：刪除它會讓複雜度集中，還是只是把它移到別處？「是，會集中」就是你要找的訊號。

### 2. 以 HTML 報告呈現候選項目

寫一個自成一體（self-contained）的 HTML 檔案到作業系統的暫存目錄，確保不會有任何東西留在 repo 裡。從 `$TMPDIR` 解析暫存目錄，若無則退回 `/tmp`(Windows 上為 `%TEMP%`)，並寫入 `<tmpdir>/architecture-review-<timestamp>.html`，讓每次執行都產生新檔案。為使用者開啟它(Linux 上用 `xdg-open <path>`,macOS 上用 `open <path>`,Windows 上用 `start <path>`)，並告知他們絕對路徑。

報告使用 **透過 CDN 引入的 Tailwind** 進行排版與樣式設計，並在圖表/流程/序列能可靠傳達結構時使用 **透過 CDN 引入的 Mermaid**。混合使用 Mermaid 與手繪的 CSS/SVG 視覺效果：當關係是圖形（graph-shaped）時使用 Mermaid（呼叫圖、依賴關係、序列），而想呈現更具編輯感的內容時使用手刻的 div/SVG（量體圖、剖面圖、collapse 動畫）。每個候選項目都要有**前後對照視覺化**。要具視覺化效果。

針對每個候選項目，呈現一張卡片，包含：

- **Files**：涉及哪些檔案/模組
- **Problem**：目前的架構為何造成摩擦
- **Solution**：用白話文描述會有什麼改變
- **Benefits**：以 locality 與 leverage 的角度說明，以及測試會如何改善
- **Before / After diagram**：並排、手繪風格，呈現淺層性與深化過程
- **Recommendation strength**:`Strong`、`Worth exploring`、`Speculative` 三者之一，以徽章（badge）呈現

在報告結尾加上一個**Top recommendation(首選建議)**區塊：說明你會優先處理哪個候選項目，以及原因。

**領域相關內容使用 CONTEXT.md 的詞彙，架構相關內容使用 `/codebase-design` 的詞彙。** 如果 `CONTEXT.md` 定義了「Order」，就要說「Order intake module」，而不是「FooBarHandler」，也不是「Order service」。

**與 ADR 衝突時**：如果某個候選項目與現有 ADR 衝突，只有在摩擦感真的強到值得重新檢視該 ADR 時才呈現它。在卡片上清楚標示（例如以警告提示呈現：_「與 ADR-0007 衝突，但因為……而值得重新開啟討論」_）。不要列出 ADR 所禁止的每一個理論上的重構方案。

詳見 [HTML-REPORT.md](HTML-REPORT.md)，裡面有完整的 HTML 骨架、圖表模式與樣式指引。

先不要提出介面設計。檔案寫入完成後，詢問使用者：「你想深入探討這些項目中的哪一個？」

### 3. Grilling 循環

一旦使用者選定候選項目，呼叫 Skill 工具並使用 "grilling"，與他們一起走過決策樹：限制條件、依賴關係、深化後模組的樣貌、seam 背後藏著什麼、哪些測試會保留下來。

副作用會在決策逐漸成形時即時發生；呼叫 Skill 工具並使用 "domain-modeling"，隨時保持領域模型的最新狀態：

- **為深化後的模組命名時，用到了 `CONTEXT.md` 中沒有的概念？** 把該詞彙加進 `CONTEXT.md`。如果檔案不存在就順手建立它。
- **對話過程中把一個模糊的詞彙定義得更清楚了？** 就地更新 `CONTEXT.md`。
- **使用者以有理有據的理由拒絕了該候選項目？** 提議建立 ADR，說法可以是：_「要不要我把這個記錄成 ADR，這樣未來的架構檢視就不會重複提出同樣的建議？」_ 只有在該理由真的能幫助未來的探索者避免重複提出同樣建議時才提議；略過短暫性的理由（「現在不太值得」）與不言自明的理由。
- **想探索深化後模組的其他介面方案？** 呼叫 Skill 工具並使用 "codebase-design"，運用其中 design-it-twice 的平行 sub-agent 模式。
