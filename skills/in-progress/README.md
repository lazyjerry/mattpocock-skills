# 進度中

Beta 版。這些技能之所以公開，是為了讓你實際試用並回報有什麼問題。它們不包含在 plugin 或最上層的 README 中，直到晉升到穩定的分類為止；它們沒有文件頁面，而且可能隨時變動或消失，恕不另行通知。

Plugin 不會提供這些技能。要安裝，請直接執行：

```bash
npx skills@latest add mattpocock/skills --skill=<name>
```

- **[loop-me](./loop-me/SKILL.md)**：透過多個 session，把使用目前目錄作為有狀態的工作區，逼問自己整理出可實作的工作流程規格。使用者主動觸發。
- **[writing-beats](./writing-beats/SKILL.md)**：以「劇情節拍（beats）」的方式建構文章，採用選擇你自己的冒險（choose-your-own-adventure）風格。挑選一個起始節拍，只寫該節拍，然後轉向下一個節拍，直到文章自然結束。
- **[writing-fragments](./writing-fragments/SKILL.md)**：一種逼問式（grilling）session，會從你身上挖掘出片段（各種異質的寫作素材），並附加到單一文件中，作為未來文章的素材。
- **[writing-shape](./writing-shape/SKILL.md)**：把一份原始素材的 markdown 檔案，逐段塑造成一篇文章，並在每個步驟中論證格式選擇。
- **[claude-handoff](./claude-handoff/SKILL.md)**：透過 `claude --bg`，將目前的對話交接給一個全新的背景 agent，讓它立即接手工作，並附上交接摘要作為初始資訊。使用者主動觸發。
- **[setup-ts-deep-modules](./setup-ts-deep-modules/SKILL.md)**：在 TypeScript 專案中接入 dependency-cruiser，讓每個套件成為一個深層模組（deep module）：實作細節隱藏在子資料夾中，只能透過其進入點檔案存取，測試也是透過這些進入點來驗證。使用者主動觸發。
- **[implement-spec](./implement-spec/SKILL.md)**：在單一分支上實作整份規格。將工單（tickets）視為任務圖（task graph）而非清單來處理，於就緒前緣（ready frontier）跨多個實作者子代理（implementer subagent）並行執行，以達到最大並行度，並將結果落地為單一 PR。使用者主動觸發。
