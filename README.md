<p>
  <a href="https://www.aihero.dev/s/skills-newsletter">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skills-repo-dark_2x.png">
      <source media="(prefers-color-scheme: light)" srcset="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png">
      <img alt="Skills" src="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png" width="369">
    </picture>
  </a>
</p>

# 給真正工程師用的技能

[![skills.sh](https://skills.sh/b/mattpocock/skills)](https://skills.sh/mattpocock/skills)

這是我每天用來做真正工程工作的代理技能（agent skills），不是 vibe coding。

開發真正的應用程式很難。GSD、BMAD、Spec-Kit 這類做法試圖藉由接管流程來幫忙。但這麼做的同時，它們也拿走了你的控制權，讓流程裡的 bug 變得難以解決。

這些技能刻意做得小、容易調整、可以組合。它們在任何模型上都能用。它們建立在數十年的工程經驗之上。拿去改、變成你自己的，好好享受。

如果你想追蹤這些技能的更動，以及我新做的技能，可以加入我的電子報，跟大約 60,000 位開發者一起：

[訂閱電子報](https://www.aihero.dev/s/skills-newsletter)

## 安裝（30 秒完成）

兩種入口，兩種哲學。**[Claude Code plugin](https://code.claude.com/docs/en/plugins)** 把整組技能當成受管理的唯讀套件安裝，我一出貨就會更新，等於是訂閱而不是 fork。**[skills.sh](https://skills.sh/mattpocock/skills)** 則把可編輯的技能檔複製進你的專案，讓你能動手改、變成自己的。挑一種就好：兩種都裝，每個技能你會拿到兩份。

### 1. 取得技能

<details>
<summary><strong>Claude Code</strong></summary>

```bash
claude plugins install mattpocock-skills
```

或者，在 session 裡面：

```
/plugin install mattpocock-skills
```

它就在 Claude Code 的官方 marketplace 裡，不需要先加任何來源，更新也會自動抵達。

</details>

<details>
<summary><strong>Codex 與其他代理</strong></summary>

```bash
npx skills@latest add mattpocock/skills
```

挑你要的技能，以及要裝到哪些 coding agent 上。**安裝程式會讓你選擇要拿哪些技能，記得把 `setup-matt-pocock-skills` 選進去。**

原生的 Codex plugin 已在規劃中（見 [`.agents/adr/0002-ship-as-a-claude-code-plugin.md`](./.agents/adr/0002-ship-as-a-claude-code-plugin.md)）。

</details>

<details>
<summary><strong>給想自己動手的人</strong></summary>

在任何代理上都用同一支安裝程式，包含 Claude Code：

```bash
npx skills@latest add mattpocock/skills
```

它會把技能寫進你的儲存庫，成為你擁有、可以編輯的普通檔案。不會有東西在你背後自動更新；想要我最新的變更時，用 `npx skills update` 自己拉。

</details>

### 2. 執行 `/setup-matt-pocock-skills`

在你的代理裡，每個儲存庫執行一次。它會：

- 問你想用哪一種議題追蹤系統（GitHub、Linear，或本機檔案）
- 問你分流工單時會套用哪些標籤（`/triage` 會用到標籤）
- 問你想把我們建立的文件存到哪裡

### 3. 搞定，可以開工了。

## 為什麼會有這些技能

我做這些技能，是為了修掉我在 Claude Code、Codex 與其他 coding agent 上看到的常見失敗模式。

### #1：代理沒做出我要的東西

> 「沒有人確切知道自己要什麼。」
>
> David Thomas & Andrew Hunt，[The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**問題**。軟體開發最常見的失敗模式是認知不一致。你以為開發者懂你要什麼。然後你看到他們做出來的東西，才發現他根本沒聽懂你。

在 AI 時代也一樣。你和代理之間存在溝通落差。解法是一場**拷問（grilling）**：讓代理針對你要建的東西，問你細節問題。

**解法**是使用：

- [`/grill-me`](./skills/productivity/grill-me/SKILL.md)：用於非程式用途
- [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md)：跟 [`/grill-me`](./skills/productivity/grill-me/SKILL.md) 一樣，但多了一些好料（見下文）

這是我最受歡迎的兩個技能。它們幫你在動工前先跟代理對齊，並深入思考你要做的這次改動。每一次你想做改動時，都用它們。

### #2：代理太囉唆

> 有了通用語言（ubiquitous language），開發者之間的對話與程式碼的表達，全都源自同一份領域模型。
>
> Eric Evans，[Domain-Driven-Design](https://www.amazon.co.uk/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

**問題**：專案剛開始時，開發者跟他們要服務的對象（領域專家）通常講著不同的語言。

我在代理身上感受到同樣的張力。代理通常被丟進一個專案，然後被要求邊做邊搞懂那些行話。所以它會用 20 個字講一個字就能講完的事。

**解法**是一套共用語言。它是一份文件，幫代理解碼專案裡用的行話。

<details>
<summary>
範例
</summary>

這是一份 [`CONTEXT.md`](https://github.com/mattpocock/course-video-manager/blob/076a5a7a182db0fe1e62971dd7a68bcadf010f1c/CONTEXT.md) 範例，來自我的 `course-video-manager` 儲存庫。哪一句比較好讀？

- **之前**：「當課程某個章節裡的一堂課被『實體化』（也就是在檔案系統中取得一個位置）時會出問題」
- **之後**：「materialization cascade 有問題」

這種精簡會在一次又一次的 session 裡持續回本。

</details>

這已經內建在 [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) 裡。它是一場拷問，但同時幫你和 AI 建立共用語言，並把難以解釋的決策記錄成 ADR。

這有多強大很難用講的。它可能是這個儲存庫裡最酷的一項技巧。試試看就知道。

> [!TIP]
> 共用語言的好處遠不只減少囉唆：
>
> - **變數、函式與檔案的命名會一致**，都用共用語言
> - 結果是，**程式碼庫對代理來說更好導航**
> - 代理也**花更少 token 在思考上**，因為它有一套更精簡的語言可用

### #3：程式跑不動

> 「永遠踏出小而刻意的步伐。回饋的速率就是你的速限。絕不接下太大的任務。」
>
> David Thomas & Andrew Hunt，[The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**問題**：假設你和代理對要建什麼已經對齊了。那如果代理*還是*產出一堆垃圾呢？

該檢查你的回饋迴圈了。少了「它產出的程式實際跑起來如何」這種回饋，代理等於在盲飛。

**解法**：你需要那組常見的回饋迴圈：靜態型別、瀏覽器存取，以及自動化測試。

自動化測試方面，red-green-refactor 迴圈至關重要。也就是代理先寫一個會失敗的測試，再把測試修綠。這能給代理穩定的回饋強度，寫出好得多的程式碼。

我做了一個 **[`/tdd`](./skills/engineering/tdd/SKILL.md) 技能**，可以塞進任何專案。它鼓勵 red-green-refactor，並針對什麼是好測試、什麼是壞測試給代理充分的指引。

除錯方面，我也做了 **[`/diagnosing-bugs`](./skills/engineering/diagnosing-bugs/SKILL.md)**，把除錯的最佳實務包成一個有紀律的迴圈，一階段一階段把關。

### #4：我們蓋出了一團爛泥

> 「*每一天*都要投資在系統的設計上。」
>
> Kent Beck，[Extreme Programming Explained](https://www.amazon.co.uk/Extreme-Programming-Explained-Embrace-Change/dp/0321278658)

> 「最好的模組是深的。它們讓大量功能可以透過一個簡單介面被存取。」
>
> John Ousterhout，[A Philosophy Of Software Design](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

**問題**：大多數用代理蓋出來的應用程式都很複雜、難以修改。因為代理能大幅加快寫程式的速度，它們同時也加速了軟體的熵。程式碼庫以前所未見的速度變複雜。

**解法**是一種對 AI 輔助開發而言很激進的新做法：在意程式碼的設計。

這內建在這些技能的每一層裡：

- [`/to-spec`](./skills/engineering/to-spec/SKILL.md) 會在產出規格前，先問你這次動到哪些模組

而關鍵的是，[`/improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) 會掃描程式碼庫、找出可以深化的機會，把候選項交到你手上。我建議每隔幾天就在你的程式碼庫上跑一次。它是一次盤點，不是搶救：在一個真正老舊的程式碼庫上，它會找到實際的候選項，但不會幫你把爛泥理乾淨。

### 總結

軟體工程的基本功比以往任何時候都更重要。這些技能是我盡最大努力，把這些基本功濃縮成可重複的做法，幫你交付你職涯中最好的應用程式。好好享受。

## 參考

這些技能沿一個軸線劃分：誰可以觸發它們。**使用者觸發**的技能只有在你打出它時才會被觸發（例如 `/grill-me`）；它們的工作是編排。**模型觸發**的技能可以由你觸發，*也*可以在任務對上時由代理自行取用；它們承載可重複使用的紀律。一個使用者觸發的技能可以呼叫模型觸發的技能，但絕不能呼叫另一個使用者觸發的技能。

### Engineering

我每天用在程式工作上的技能。

**使用者觸發**

- **[ask-matt](./skills/engineering/ask-matt/SKILL.md)**：問哪一個技能或流程適合你的狀況。這個儲存庫裡使用者觸發技能的路由器。
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)**：拷問，同時建立專案的領域模型，磨利術語，並就地更新 `CONTEXT.md` 與 ADR。
- **[triage](./skills/engineering/triage/SKILL.md)**：讓議題在分流角色的狀態機裡逐一推進。
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)**：掃描程式碼庫尋找可深化的機會，以視覺化 HTML 報告呈現，然後針對你挑中的那一項進行拷問。
- **[setup-matt-pocock-skills](./skills/engineering/setup-matt-pocock-skills/SKILL.md)**：為這個儲存庫設定工程技能所需的組態（議題追蹤系統、分流標籤、領域文件配置）。使用其他工程技能前，每個儲存庫執行一次。
- **[to-spec](./skills/engineering/to-spec/SKILL.md)**：把目前的對話變成一份規格並發布到議題追蹤系統。不做訪談，只綜合你們已經討論過的內容。
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)**：把任何計畫、規格或對話拆成一組曳光彈（tracer-bullet）工單，每張都宣告自己的阻擋關係邊，寫成本機檔案裡的文字，或真實追蹤系統上原生的阻擋連結。
- **[implement](./skills/engineering/implement/SKILL.md)**：實作某份規格或某組工單描述的工作，在事先約定的接縫上驅動 `/tdd`，並在提交前以 `/code-review` 收尾。
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)**：把一大塊超出單一代理 session 所能承載的工作，規劃成議題追蹤系統上一份共享的決策工單地圖，然後一次解決一張，直到通往目的地的路徑清晰為止。

**模型觸發**

- **[prototype](./skills/engineering/prototype/SKILL.md)**：做一個用完即丟的原型來回答某個設計問題，可以是回答狀態／邏輯問題的單一可分享 HTML 檔，或是同一路由下可切換的數個差異極大的 UI 變體。
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)**：針對難纏 bug 與效能退化的有紀律診斷迴圈：建立一個會對這個 bug 亮紅燈的回饋迴圈 → 最小化 → 建立假設 → 加測點 → 修復 → 回歸測試。
- **[research](./skills/engineering/research/SKILL.md)**：以高可信度的第一手資料來源調查問題，並把發現整理成儲存庫裡一份附引用的 Markdown 檔，以背景代理執行。
- **[tdd](./skills/engineering/tdd/SKILL.md)**：以 red-green-refactor 迴圈進行的測試驅動開發。一次一個垂直切片地建功能或修 bug。
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)**：主動建立並磨利專案的領域模型：拿詞彙表挑戰術語、用邊界情境壓力測試，並就地更新 `CONTEXT.md` 與 ADR。
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)**：設計深層模組的共用紀律與詞彙：小介面背後藏著大量行為，放在乾淨的接縫上，並且能透過那個介面測試。
- **[code-review](./skills/engineering/code-review/SKILL.md)**：對自某個固定點以來的差異做雙軸審查：**Standards**（是否遵循儲存庫的程式碼規範，外加 Fowler 的程式碼異味基準？）與 **Spec**（是否忠實實作了源頭的議題／規格？），以平行子代理執行，兩邊互不汙染。
- **[resolving-merge-conflicts](./skills/engineering/resolving-merge-conflicts/SKILL.md)**：一個 hunk 一個 hunk 地處理進行中的 git merge 或 rebase 衝突，依各方主要來源所追溯出的意圖來解決，然後把操作完成（絕不 `--abort`）。
- **[wizard](./skills/engineering/wizard/SKILL.md)**：產生一支互動式 bash 精靈，帶著人類走完只有人類能做的步驟：佈建基礎設施、設定憑證或 CI secret、操作不熟悉的第三方後台，或執行一次性的遷移或切換。

### Productivity

通用的流程工具，不限於程式。

**使用者觸發**

- **[grill-me](./skills/productivity/grill-me/SKILL.md)**：針對一個計畫或設計接受不留情面的訪談，直到設計樹的每一個分支都被解決。
- **[handoff](./skills/productivity/handoff/SKILL.md)**：把目前的對話壓縮成一份交接文件，讓另一個代理能接手繼續。
- **[teach](./skills/productivity/teach/SKILL.md)**：跨多個 session 教使用者一項新技能或概念，把目前的目錄當成有狀態的教學工作區。
- **[to-questionnaire](./skills/productivity/to-questionnaire/SKILL.md)**：把一個你無法獨自回答的決策，變成一份 Markdown 問卷交給唯一能回答的人，非同步填寫，或在會議上一起走過。它拷問的是這次的「寄送」（要給誰、你需要拿回什麼），而不是主題本身。
- **[wait-what](./skills/productivity/wait-what/SKILL.md)**：訊息看不懂的當下就丟這個。代理會補上你缺的脈絡、用白話重講一次，並使用你 `CONTEXT.md` 裡的詞彙。

**模型觸發**

- **[grilling](./skills/productivity/grilling/SKILL.md)**：針對計畫、決策或想法不留情面地訪談使用者，直到設計樹的每一個分支都被解決。這是 `grill-me`、`grill-with-docs`、`triage`、`wayfinder` 與 `improve-codebase-architecture` 背後可重複使用的訪談原語。
- **[writing-for-agents](./skills/productivity/writing-for-agents/SKILL.md)**：為代理撰寫文件：技能、AGENTS.md／CLAUDE.md，以及任何代理會透過指標抵達的文件。
