# mattpocock-skills

## 1.2.3

### Patch Changes

- [#779](https://github.com/mattpocock/skills/pull/779) [`efce423`](https://github.com/mattpocock/skills/commit/efce423018fc6468a3239621f1c1bcaacc723801) Thanks [@mattpocock](https://github.com/mattpocock)! - 讓 `diagnosing-bugs` 遮蔽機密資訊。

  - 在 `SKILL.md` 加入 **Redact** 章節。這個技能會讓代理展示指令、輸出與擷取到的產物；這個章節把遮蔽變成處理每一項時的第一個動作：寫成 `<REDACTED>`、把迴圈建立在環境變數上讓憑證留在環境裡、擷取到的產物只引用帶有訊號的那幾行。
  - 第 1 階段的完成條件原本寫「貼上呼叫指令與它的輸出」。現在改成以遮蔽後的形式呈現，而且第 1 階段會向使用者索取**已遮蔽**的擷取產物。
  - 在 `scripts/hitl-loop.template.sh` 註記 `capture` 會把值印回終端機，所以它負責取得觀測值，而登入這件事仍然是 `step`。

- [#781](https://github.com/mattpocock/skills/pull/781) [`14bfbbd`](https://github.com/mattpocock/skills/commit/14bfbbd8654a8d2910299e1a004c19c1979687d8) Thanks [@mattpocock](https://github.com/mattpocock)! - 把 Claude Code 的工具與 agent-type 名稱從 `code-review`、`codebase-design`、`improve-codebase-architecture` 的子代理派工指示中拿掉，讓這個步驟在 Codex 與其他 harness 上也照著做得起來。

- [#783](https://github.com/mattpocock/skills/pull/783) [`c0fd1e9`](https://github.com/mattpocock/skills/commit/c0fd1e973e040347d424e09934099f1bd6c2dee0) Thanks [@mattpocock](https://github.com/mattpocock)! - wizard：移除時間估計。樣板拿掉了 `TOTAL_MINUTES` 與剩餘時間顯示，`stage` 只接受一個名稱，進度改以階段數計算。

## 1.2.2

### Patch Changes

- [#766](https://github.com/mattpocock/skills/pull/766) [`4aaccb5`](https://github.com/mattpocock/skills/commit/4aaccb58d40559d7e3c59a029b2290ae5ba538de) Thanks [@mattpocock](https://github.com/mattpocock)! - 讓 `writing-for-agents` 在 Codex 上重新可被模型觸發。

  - 從 `agents/openai.yaml` 拿掉 `policy.allow_implicit_invocation: false`。Codex 會把這個技能從模型可見的技能清單中濾掉，導致它的描述無法觸發它，只有明確提到 `$writing-for-agents` 才有用。
  - 更新過期的 `interface.display_name` 與 `interface.short_description`，它們還寫著舊的 `writing-great-skills` 技能名稱。
  - 在 `README.md` 與 `skills/productivity/README.md` 中，把這個技能從**使用者觸發**清單移到**模型觸發**清單。

## 1.2.0

### Minor Changes

- [#551](https://github.com/mattpocock/skills/pull/551) [`697d4ce`](https://github.com/mattpocock/skills/commit/697d4ce9742da558fd1ba6697c8e9775e2e302dd) Thanks [@mattpocock](https://github.com/mattpocock)! - 在每個技能的 Claude Code frontmatter 旁加上 Codex metadata，讓這一組技能不需要另外產生副本就能在兩種 harness 上使用。

  - 在每一份 `SKILL.md` 旁邊加上帶有 Codex UI metadata（`interface.display_name`、`interface.short_description`）的 `agents/openai.yaml`。
  - 為每一個使用者觸發的技能標上 `policy.allow_implicit_invocation: false`，這是 Codex 版的 `disable-model-invocation: true`，讓 Codex 把它排除在隱式觸發之外，同時明確的 `$skill` 觸發仍然有效。
  - 在 `.agents/invocation.md`、`CLAUDE.md` 與主推 bucket 的 README 中，記錄雙 harness 的觸發模型。
  - 加上指向 `CLAUDE.md` 的 symlink `AGENTS.md`，讓 Codex 讀到同一份儲存庫指示。

- [#593](https://github.com/mattpocock/skills/pull/593) [`0f2bdbd`](https://github.com/mattpocock/skills/commit/0f2bdbdb06220d2df3718b8f0483157c6c8a8600) Thanks [@mattpocock](https://github.com/mattpocock)! - 把 **`to-questionnaire`** 從 `in-progress/` 升級進 **Productivity** bucket，隨 plugin 出貨。它把一個你無法獨自回答的決策，變成一份 Markdown 問卷交給唯一能回答的人，非同步填寫，或在會議上一起走過。

  它的關鍵動作是：它拷問的是這次的**寄送**，不是主題本身。一般的拷問會質詢主題，而那正是你在這裡回答不了的，所以這場訪談只問問卷要寄給誰、你需要拿回什麼，然後把每一個問題都對準這兩者之間的落差。

  現在已接成主推技能：plugin 項目、頂層與 Productivity README 的**使用者觸發**區塊、`docs/productivity/to-questionnaire.md` 文件頁，以及 `ask-matt` 裡的一條獨立路由，把它定位成 `/grill-me` 的反向操作（挖別人，不是挖自己）。

- [#680](https://github.com/mattpocock/skills/pull/680) [`b3376f8`](https://github.com/mattpocock/skills/commit/b3376f8d39848dd08572ec2667da4739a67c8c04) Thanks [@mattpocock](https://github.com/mattpocock)! - 把 **`wizard`** 從 `in-progress/` 升級進 **Engineering** bucket，隨 plugin 出貨，並改成模型觸發。它會產生一支互動式 bash 腳本，帶著人類走完一段手動流程：第三方設定、一次性遷移、A→B 的狀態轉換，過程中打開每個網址、說明該點什麼、擷取那些值，並把它們寫進 `.env` 檔與 GitHub Actions secret。

  那種令人愉快的 UX 已經由內附的 `template.sh` 事先解決（含剩餘時間的進度、確認關卡、跨平台開網址（含 WSL）、隱藏式機密輸入、冪等的 `.env` upsert、能優雅降級的 `gh secret`／`gh variable` 寫入、結尾的略過摘要）。`STAGES` 標記以上的一切都是固定的函式庫，永遠不手改，這個技能的工作只有界定流程範圍並寫出它的**階段**。

  歸在 Engineering 而不是 Productivity：它會讀 `.env*`、`docker-compose*`、框架設定，以及 `.github/workflows/` 裡每一個 `secrets.*`／`vars.*` 參照來界定自己的範圍，會寫入 CI secret，並用 `bash -n` 與 `shellcheck` 驗證自己的產出。

  因為它是模型觸發，代理一碰到只有人類能執行的步驟就能立刻取用它，而不是把一堆編號步驟倒進聊天室，然後祈禱你會照做。輸入 `/wizard` 的行為跟以前完全一樣，模型觸發永遠只是*增加*代理能觸及的範圍。它的描述被寫成決定何時觸發的指標：它產出什麼、四個觸發分支（佈建基礎設施、設定憑證或 CI secret、操作不熟悉的第三方後台、一次性遷移或切換），以及一個明確的非觸發條件，也就是代理自己做得到的步驟不要叫它。代理做得到的工作就該由代理做；wizard 是為了那些你不會交給代理的點擊、核准與後台跑腿。在寫下任何一行之前的階段清單確認，現在同時也是代理在建置途中觸發它時的提案。

  現在已接成主推技能：plugin 項目、頂層與 Engineering README 的**模型觸發**區塊、`docs/engineering/wizard.md` 文件頁，以及 `ask-matt` 裡一條處理「只有人類能做的步驟」的獨立路由。改成模型觸發也讓它避開了 [#693](https://github.com/mattpocock/skills/issues/693)，該問題會讓使用者觸發的技能從 Claude 桌面版與網頁版的清單中消失。

- [#763](https://github.com/mattpocock/skills/pull/763) [`77d207e`](https://github.com/mattpocock/skills/commit/77d207ef03219cc603e2832e1159cbdd1c91818e) Thanks [@mattpocock](https://github.com/mattpocock)! - 把 **`prototype`** 技能圍繞兩個想法重塑：demo 是**單一份可分享的 HTML 檔**，而原型是**一份主要來源**。

  邏輯分支現在產出一份自足的檔案（純 HTML/CSS/JS，不需建置、不需伺服器），而不是終端機應用程式，非開發者可以雙擊打開，並用他們自己的領域語言操作它：一個有標籤的狀態面板、隨時可用的自由操作按鈕，以及一組分頁式的**導覽演練**，每一個都是一種情境，底下列著要依序按的按鈕。可攜的純邏輯模組仍然會被抬進真正的程式碼；HTML 外殼才是用完即丟的部分。

  用完即丟不再等於刪掉。原型回答完它的問題後不再被移除，而是以可執行的證據形式，被保存在 main 之外的用完即丟分支（`prototype/<name>`）上，並在實作議題上留下一個指向它的情境指標，讓 main 分支只保留已驗證的決策，而探索過程仍然找得到。答案（結論加問題）仍然會持久地記錄在議題／ADR／commit 裡。

- [#536](https://github.com/mattpocock/skills/pull/536) [`42a5b70`](https://github.com/mattpocock/skills/commit/42a5b70fcacc7baff1977b13f3919fb2f63af14e) Thanks [@mattpocock](https://github.com/mattpocock)! - 把這組技能以原生 **Claude Code plugin** 形式出貨，並列在 Claude Code 的官方 marketplace 上。你現在可以把主推的技能當成受管理的唯讀套件來訂閱，而不是複製一份可編輯的檔案：

  ```bash
  claude plugins install mattpocock-skills
  ```

  或者，在 session 裡面：

  ```
  /plugin install mattpocock-skills
  ```

  不需要先加任何 marketplace，官方 marketplace 是預設就設定好的。

  `.claude-plugin/plugin.json` 承載完整的 plugin metadata（版本、描述、作者、授權、關鍵字）與主推技能的明確清單。`skills.sh` 仍然是通用安裝程式（也是目前 Codex 與其他 harness 的路徑）；原生的 Codex plugin 暫緩，原因見 `.agents/adr/0002-ship-as-a-claude-code-plugin.md`。

- [#751](https://github.com/mattpocock/skills/pull/751) [`355fa74`](https://github.com/mattpocock/skills/commit/355fa7420b418af838998f7ec4365ceda1c8dfcc) Thanks [@mattpocock](https://github.com/mattpocock)! - 新增 **`wait-what`**，一個針對模型囉唆症的單字級糾正。訊息看不懂的當下就打它，代理會重講一次：補一點脈絡、用 ASD-STE100 簡化技術英文，以及你 `CONTEXT.md` 裡的通用語言。使用者觸發，全長三行。

  機制就在名字本身。追求精簡的技能常常敗在自己變胖，一份 400 行的技能還是留下一個囉唆的模型，所以這一份只有一個精準的前導詞，別無其他。用*輸出結果*命名的做法（`/tldr`、`/no-fluff`）會讓模型刪字，反而讓你更聽不懂；命名*聽者*的狀態則同時要到了兩件事：更少的字**以及**你缺的那塊脈絡。它也重複使用你全域 `CLAUDE.md` 裡已有的前導詞，讓技能、`CLAUDE.md` 與每一份 `CONTEXT.md` 都伸手拿同一批 token。

  它修的是一則訊息，不會預防下一則。行話的解藥是事先用 `/grill-with-docs` 建好的共用語言；這一個是你還沒有共用語言時可以先抓的東西。

- [#763](https://github.com/mattpocock/skills/pull/763) [`77d207e`](https://github.com/mattpocock/skills/commit/77d207ef03219cc603e2832e1159cbdd1c91818e) Thanks [@mattpocock](https://github.com/mattpocock)! - 把 `/wayfinder` 的單位命名為**決策工單**（decision ticket），並用子代理把研究工單燒掉。

  大家一直把 wayfinder 的工單讀成一般的*實作*工單（一段待執行的建置切片），但 wayfinder 是把它們當成**決策工單**在用：那是一些以決策作為解答的問題。技能描述與它的開頭第一句現在會引入這個術語（並說明什麼樣才算），`ask-matt`／engineering README 的簡介與文件頁也跟著一致，而術語一旦立好，日常用語仍然沿用「ticket」。`CONTEXT.md` 把**決策工單**登記為領域術語，所以「避免使用：ticket」的指引不再與 wayfinder 刻意的用詞相衝突。

  研究工單不再被擱置到另外開的 session。研究仍然是一種真正的工單類型，它是下游決策懸掛其上的、貨真價實的共享阻擋因素，而那份相依關係正是前緣的阻擋關係邊存在的意義。改變的是它被解決的方式：因為研究是 AFK 的，繪製地圖的過程不會停下來讀它。工單建好之後，繪製 session 會為每一張研究工單開一個 `/research` 子代理平行把它燒掉，並把發現記在用完即丟的 `research/<name>` 分支上，附帶一個情境指標。研究工單是「一個 session 一張工單」的唯一例外。

- [#763](https://github.com/mattpocock/skills/pull/763) [`77d207e`](https://github.com/mattpocock/skills/commit/77d207ef03219cc603e2832e1159cbdd1c91818e) Thanks [@mattpocock](https://github.com/mattpocock)! - **破壞性變更：**把 **`writing-great-skills`** 更名為 **`writing-for-agents`**、重整結構，並加入一個新的前導詞。

  這份參考文件現在涵蓋代理會讀的任何文件：技能、`AGENTS.md`／`CLAUDE.md`、透過指標抵達的文件，而不只是技能。`GLOSSARY.md` 併入 `SKILL.md`（每個術語只有一處權威說明；`_Avoid_` 同義詞清單與獨立的 Predictability 定義都拿掉了）；只跟技能有關的機制（frontmatter、模型觸發與使用者觸發之別、路由器技能、拆分時的觸發面切法）則揭露到新的 `SKILL-MECHANICS.md`。這個技能現在是**模型觸發**：建立或編輯技能、或修改 `AGENTS.md`／`CLAUDE.md` 時就會觸發。`ask-matt` 的指標也已更新。請用新名稱重新安裝；舊名稱已經消失（沒有別名）。

  修剪那一節多了 **cache** 的概念。單一事實來源現在延伸到文件之外、進到環境裡：`package.json` 的 scripts、設定檔、目錄配置、`--help` 輸出本身就是權威來源，所以一份重述它們的文件只是那次查詢的快取，唯有查詢成本很高時才值得佔用載入額度。正向的目標是：快取代理靠翻找找不到的東西（沒寫下來的慣例、某個選擇背後的理由、沒有任何設定檔會招認的坑），至於一個檔案、一道指令就查得到的東西就留給環境，那裡的東西不會過期。

- [#533](https://github.com/mattpocock/skills/pull/533) [`45afd80`](https://github.com/mattpocock/skills/commit/45afd8074a8b7de5fe073845d080fa9dd6c429fa) Thanks [@mattpocock](https://github.com/mattpocock)! - 在 **`improve-codebase-architecture`** 技能的 Explore 步驟加上 YAGNI 範圍篩選。它不再平均地掃整個儲存庫，而是把範圍收斂到改動實際落點的地方：你指定方向它就照做，否則它會讀最近約 20 筆 commit 訊息，把探索偏向正在積極開發的路徑。沒有人碰的程式碼裡的深化機會，是一次你永遠兌現不了的重構，槓桿只有在你持續編輯的地方才會回本，所以報告不再去整理儲存庫裡休眠的角落。

### Patch Changes

- [#763](https://github.com/mattpocock/skills/pull/763) [`77d207e`](https://github.com/mattpocock/skills/commit/77d207ef03219cc603e2832e1159cbdd1c91818e) Thanks [@mattpocock](https://github.com/mattpocock)! - 磨利 `/ask-matt`：路由器現在涵蓋階段邊界、wayfinder 的兩個常見錯誤，以及兩個它從未提及的技能。

  **階段邊界。** 一個**階段**（phase）是 session 內部的一塊工作，例如拷問、實作、QA，而兩個階段之間的邊界，就是你決定要拿已經建立起來的脈絡怎麼辦的地方。原本兩點式的 `Crossing sessions` 章節，換成一棵依序帶出全部五個選項的決策樹（**繼續**、`/clear`、`/handoff`、**子代理**、`/compact`），推理過程揭露在新的 `PHASE-BOUNDARIES.md` 裡。隨之而來的有三項修正：

  - **`/handoff` 被過度推銷了。** 它原本讀起來像是跨 context window 的通用橋樑。它其實很窄：只有在某樣東西必須*移動*時才需要它，例如換 harness、換目錄、交給同事，或在階段中途岔出的支線任務。它買到的是可攜性。
  - **`/compact` 是預設值，不是第一個伸手拿的東西。** 它坐在決策樹的最底部，排在上方那四個更便宜或更精準的問題之後。從它開始，會得到一個對摘要壓平掉的東西自信滿滿卻是錯的 session。
  - **有兩個分支根本不存在。** **繼續**是第一個該排除的選項，它是唯一能讓對話維持為主要來源、而不是主要來源的摘要的做法；而**子代理**負責處理任何範圍收得夠緊、能 AFK 執行的東西。

  脈絡衛生的逃生口現在寫的是 `/compact` 而不是 `/handoff`（同一個 harness、同一個目錄、位於邊界上，交接的條件不適用），聰明區間的數字也從約 120k token 更新為約 150k token。

  **Wayfinder 路由。** 面對這個最重、認知負擔最高的流程，大家最常犯的兩個錯：

  - **太早伸手拿它。** 它比一次拷問更慢也更密，所以被標成最重的流程，只保留給真的塞不進一個 session 的想法；範圍界定良好的功能該走 `/grill-with-docs`，不是這裡。
  - **在交接處迷路。** 地圖清晰之後，wayfinder 是交棒，不是建置：在 `/to-spec` 併回主流程（它會把地圖上互相連結的決策收斂成一份可建置的計畫），而不是把地圖直接繞進 `/implement`。直接進 `/implement` 只適用於後來發現規模其實很小的工作。

  **缺漏的路由。** `/grilling` 與 `/resolving-merge-conflicts` 原本完全不在路由器裡，現在補上了；而 `grill-me` 與 `grill-with-docs` 的分岔條件是你人在不在一個工作目錄裡。

- [#502](https://github.com/mattpocock/skills/pull/502) [`44eed54`](https://github.com/mattpocock/skills/commit/44eed545186ffd0263e8004867750b80cfddd215) Thanks [@mattpocock](https://github.com/mattpocock)! - 讓 `/setup-matt-pocock-skills` 更友善，並讓本機 Markdown 追蹤系統與現行規格一致。

  - **分流標籤**現在只有在安裝了 `triage` 技能時才會被問到，而且是一個建議回答「是」的單一問題（「保留預設的分流標籤嗎？」），不再是一連串覆寫式的盤問。沒安裝 `triage` 時，這一節與 `docs/agents/triage-labels.md` 都會略過。
  - **把外部 PR 當成需求入口**不再是設定時的問題。GitHub／GitLab 樣板仍然帶著這個旗標，預設關閉；使用者之後可以在 `docs/agents/issue-tracker.md` 裡自行打開。
  - **領域文件**不再詢問，直接預設為單一情境；只有在儲存庫出現 monorepo 訊號時才會提供多情境選項。
  - **本機 Markdown 工單**現在是一張工單一個檔案，放在 `.scratch/<feature>/issues/<NN>-<slug>.md` 底下，絕不再合成單一份 `tickets.md`。`/to-tickets` 與本機議題追蹤系統樣板現在說法一致，規格檔也改名為 `spec.md`（不是 `PRD.md`）以對齊 `/to-spec`。

  `setup-matt-pocock-skills` 與 `to-tickets` 的文件頁已重新同步。

- [#532](https://github.com/mattpocock/skills/pull/532) [`170ad48`](https://github.com/mattpocock/skills/commit/170ad48655825783d0193e850e31a9aac957bb95) Thanks [@mattpocock](https://github.com/mattpocock)! - 重寫 **`grilling`** 的措辭，讓它適用於一般用途。它的描述與內文不再把訪談限縮在軟體計畫上：「this plan」改成「this」、「enact the plan」改成「act on it」、「exploring the codebase」改成「exploring the environment」。技巧本身沒變；它現在讀起來就是對任何計畫、決策或想法的壓力測試。

- [#593](https://github.com/mattpocock/skills/pull/593) [`a4b2009`](https://github.com/mattpocock/skills/commit/a4b2009a1a3ac9575506c10b4c84f08f9bba7a38) Thanks [@mattpocock](https://github.com/mattpocock)! - 把 **`grilling`** 從一次一題改造成一輪一輪。它現在會描繪決策樹，並在單一輪次中把整個**前緣**（frontier，也就是前置條件都已確定的每一個問題）以編號一次問完，再依使用者的回答重新計算前緣，接著問下一輪。同樣的 13 個問題現在約 3 輪就問完，而不是 13 輪。環境能自行回答的事實會派給背景子代理，所以研究永遠不會卡住當輪；只有位在某次進行中探索下游的問題才會等它。前緣清空時，這場 session 就結束。

  一輪裡的每個問題都以固定形式輸出：`❓ **Q1** - **<title>**`，接著是內文（散文或多選項），最後是自成一行的 `➡️` 建議。一輪讀起來就是一份可快速掃視的編號清單，每則建議在視覺上與問題分開，所以你可以用編號回答，而不必把問題再引述一次。

  `grill-me`、`grill-with-docs` 與 `triage` 也改成一次跑一輪前緣，`triage` 的拷問步驟與 `grilling` 的 Codex `short_description` 現在也這麼寫，不再描述舊的節奏。想改回一次一題的退出方式（在你全域 `CLAUDE.md` 裡加一行）維持不變。

- [#752](https://github.com/mattpocock/skills/pull/752) [`c66bdee`](https://github.com/mattpocock/skills/commit/c66bdeeee002d81e3f8b21403c07f9a0d7bea6da) Thanks [@mattpocock](https://github.com/mattpocock)! - 從儲存庫移除六個技能。它們都不在 Claude Code plugin 裡，但六個都能透過 [skills.sh](https://skills.sh/mattpocock/skills) 安裝，因為它供應這個儲存庫裡的每一個技能，所以這裡說明的是哪些東西從那份清單上消失，以及它們各自去了哪裡。

  四個退役的技能，每一個都已經被做得更好的技能吸收：

  - **`ubiquitous-language`** → **`/domain-modeling`**，它會建立並維護整份領域模型，而不是從一次對話裡倒出一份詞彙表。
  - **`design-an-interface`** → **`/codebase-design`**。沒有東西遺失：「設計兩次」（design it twice）這個來自 Ousterhout 的技巧，也就是用平行子代理產出差異極大的設計，仍以 `DESIGN-IT-TWICE.md` 的形式包在那個技能裡出貨。
  - **`qa`** → **`/triage`** 與 **`/to-tickets`**。
  - **`request-refactor-plan`** → **`/to-spec`** 與 **`/improve-codebase-architecture`**。

  另外兩個從頭到尾都只屬於我自己，綁在我自己的機器上，從來就不是給別人用的。`personal/` bucket 跟著一起走：

  - **`edit-article`**
  - **`obsidian-vault`**，它把路徑寫死到我自己的 Obsidian vault。

  `skills/deprecated/` 仍然保留為一個 bucket，現在是空的。`skills/in-progress/` 沒有變動，現在則按它實際的樣子描述：一個 beta 頻道，刻意公開，可以透過 skills.sh 一次裝一個技能。

- [#734](https://github.com/mattpocock/skills/pull/734) [`a2f9333`](https://github.com/mattpocock/skills/commit/a2f9333669ff53db762c87ecda5a15442060a3be) Thanks [@mattpocock](https://github.com/mattpocock)! - 把 `to-prd` → `to-spec` 的更名收尾：「spec」現在是出貨文字裡唯一使用的術語。

  - **`to-spec`** 開頭不再寫「你可能把這份文件叫做 PRD」，這個括號註記已從技能與它的文件頁移除。本機 Markdown 追蹤系統樣板也拿掉同一句緩衝說法。
  - **`code-review`** 在它的 frontmatter 描述、雙軸摘要與規格來源搜尋順序中，都改成講源頭的議題／規格，而不是議題／PRD。兩份 README 都已重新同步。
  - **GitHub 與 GitLab 追蹤系統樣板**現在寫的是「這個儲存庫的議題與規格都以 GitHub／GitLab issue 的形式存在」，先前更新本機樣板時漏掉了它們，還停在「PRD」，於是這個過期術語被散播進每一個被寫入的儲存庫。
  - **`docs/engineering/research.md`** 原本指向 `https://aihero.dev/skills-to-prd`，那是更名後已失效的 slug；現在它跟其他十九份文件頁一樣連到 `to-spec`。

  CHANGELOG 與既有的 changeset 在記述這次更名本身時仍然會提到 PRD，這是正確的。

## 1.1.0

### Minor Changes

- [#406](https://github.com/mattpocock/skills/pull/406) [`930a450`](https://github.com/mattpocock/skills/commit/930a450089f77a49af09001d955db8452a4b867d) Thanks [@mattpocock](https://github.com/mattpocock)! - 讓 **`ask-matt`** 路由器跟上完整的技能組。它現在標出了先前漏掉的五個技能：**`tdd`**（作為 `implement` 驅動的紅綠引擎，織進主流程）、**`diagnosing-bugs`**（新增的「有東西壞了」入口，先前完全沒有針對 bug 的路由）、**`domain-modeling`** 與 **`codebase-design`**（新增的「底層詞彙」區塊），以及 **`grilling`**（共用的訪談原語）。`prototype` 被補寫成一條獨立路由，描述也從「使用者觸發的技能」放寬為「這些技能」。`CLAUDE.md` 加入一條維護規則，讓未來任何技能的新增／更名／移除或流程變動，都會觸發一次 `ask-matt` 複查，與既有的文件頁重新同步規則並列。

- [#464](https://github.com/mattpocock/skills/pull/464) [`639df6e`](https://github.com/mattpocock/skills/commit/639df6e7386dfddc739b2aecdeff37a876f2483b) Thanks [@mattpocock](https://github.com/mattpocock)! - 把 **`code-review`** 升級並強化。原本 in-progress 的 **`review`** 技能更名為 **`code-review`**，並從 `in-progress/` 移進 `engineering/`：它現在隨 plugin 出貨、列在頂層與 Engineering README（模型觸發），並在 `docs/engineering/code-review.md` 有文件頁。`/implement` 技能與文件都指向 `/code-review`。

  它的 Standards 軸線也獲得一組永遠開啟的 **Fowler 程式碼異味基準**：精選約 12 個高訊號的「Bad Smells in Code」（Mysterious Name、Duplicated Code、Feature Envy、Data Clumps、Primitive Obsession、Repeated Switches、Shotgun Surgery、Divergent Change、Speculative Generality、Message Chains、Middle Man、Refused Bequest），內嵌在 `SKILL.md` 裡，與儲存庫自己記載的規範並列作為固定基準，而不是新增第三條軸線。兩條約束規則讓它安全：儲存庫有記載的規範優先於這組基準，而且每一項異味都以判斷建議的形式回報，絕不當成硬性違規。

- [#464](https://github.com/mattpocock/skills/pull/464) [`639df6e`](https://github.com/mattpocock/skills/commit/639df6e7386dfddc739b2aecdeff37a876f2483b) Thanks [@mattpocock](https://github.com/mattpocock)! - 從兩個面向磨利 **`grilling`**。

  **一道確認關卡。** 在你確認雙方已經達成共識之前，代理不會開始執行計畫，這把技能既有的「共識」完成條件變成一道明確的停止關卡。`description` 也徵召了預訓練裡的前導詞 **`grill`**（「Grill the user relentlessly」）來讓觸發更精準，文件頁也已重新同步。

  **事實與決策之分。** 拷問現在把*事實*（自己查，去探索程式碼庫）與*決策*（每一個都拿去問人類並等他回答）分開。舊的那句籠統規則「如果某個問題可以靠探索程式碼庫回答，就去探索程式碼庫」是為真人在場的情境寫的，但一旦另一個技能在「解決工單」的框架裡跑拷問，它就會被讀成連*決策*也可以自行回答的許可。把兩者分開，可以避免拷問中的代理一路衝過去自問自答。

- [#463](https://github.com/mattpocock/skills/pull/463) [`af6d692`](https://github.com/mattpocock/skills/commit/af6d6922c3e2b5288eef155346cbe319e4ed3bd0) Thanks [@mattpocock](https://github.com/mattpocock)! - 在 **`writing-great-skills`** 加入兩個相鄰的 Steering 失敗模式，兩者都在講：你以為「關掉了」的語言其實仍在導引代理。**否定**（Negation），也就是那頭*大象*，是以禁止進行導引：指名*不要*做什麼，會把被禁的行為拖進脈絡裡，讓它*更*容易被取用而不是更不容易（*別想大象*），所以解方是改成提示**正向**行為。**負空間**（Negative Space），也就是那個空洞，是對「你留白的部分同樣在導引」這件事視而不見：技能每一個不作決定的地方，都不是保持中立，而是把決定權委派給代理的先驗，所以解方是把草稿裡的沉默讀出來，並刻意處理每一處遺漏（把它填起來，或明確留成一個真正的**分支**）。它們維持成兩則而不是一則，因為診斷方式與解方都不同，各自都有完整的 `GLOSSARY.md` 條目加上一則 `SKILL.md` 失敗模式要點，與其他每一個失敗模式的呈現方式一致。

- [`850873c`](https://github.com/mattpocock/skills/commit/850873cd73d5f81826ebf512ad35d2b1e113001f) Thanks [@mattpocock](https://github.com/mattpocock)! - 把 **`prototype`** 技能改成模型觸發，讓代理可以自行取用（其他技能也可以）。它的描述圍繞前導詞 *prototype* 重寫，也就是用來回答某個設計問題的用完即丟程式碼，每個分支各有一個觸發條件（狀態／邏輯的合理性檢查，或 UI 探索）。

- [#409](https://github.com/mattpocock/skills/pull/409) [`0d74d01`](https://github.com/mattpocock/skills/commit/0d74d01cbc64ca27778a49b38599f70c534e76a0) Thanks [@mattpocock](https://github.com/mattpocock)! - 新增 **`research`** 技能，一個小巧的模型觸發技能，它會開一個**背景代理**，對照**主要來源**（官方文件、原始碼、規格、第一方 API）調查某個問題，然後在儲存庫存放這類筆記的地方留下單一一份附引用的 Markdown 檔。這是可以外包的閱讀苦工：它在讀的時候你繼續工作，然後拿回一份可以拷問、規劃或據以設計的文件。已列在頂層與 Engineering README（模型觸發）、加進 `.claude-plugin/plugin.json`、在 `docs/engineering/research.md` 有文件頁，並在 `ask-matt` 裡列為一條獨立路由。

- [#469](https://github.com/mattpocock/skills/pull/469) [`a0329ba`](https://github.com/mattpocock/skills/commit/a0329ba95751f58566ed7ab484475917a68f1629) Thanks [@mattpocock](https://github.com/mattpocock)! - 把 **`to-issues`** 技能拆成精簡的 **Process** 與 **Reference** 兩節，並教它處理**大範圍重構**：一個單一的機械性改動（例如把某個欄位改名），其**波及範圍**會擴散到整個程式碼庫，一次打壞成千上萬個呼叫點，導致沒有任何垂直切片能綠燈落地。草擬步驟現在指向兩個放在一起的參考區塊：一般曳光彈用的**垂直切片規則**，以及**大範圍重構**，後者用 **expand–contract** 來切分改動（在舊形式旁邊擴充新形式、依波及範圍決定批次大小逐批遷移呼叫點，然後把舊形式收掉），讓 CI 一批一批都保持綠燈；真的做不到時，則只在最後一張整合驗證議題上收斂。議題內文樣板也移進 Reference。

- [#464](https://github.com/mattpocock/skills/pull/464) [`386d4ff`](https://github.com/mattpocock/skills/commit/386d4ff719a7c420ad1454232d0436b01f1b8c17) Thanks [@mattpocock](https://github.com/mattpocock)! - 統一規劃類技能。**`to-prd` 更名為 `to-spec`**，「spec」現在是貫穿全局的唯一術語（為了可發現性，它仍以「你可能把這份文件叫做 PRD」開頭）。**`to-plan` 與 `to-issues` 合併成單一的 `to-tickets` 技能，`to-issues` 已刪除。**

  `to-tickets` 把一份計畫、規格或對話拆成一組**工單**：曳光彈式的垂直切片，每一張都宣告自己的**阻擋關係邊**。同一份產物會依 `/setup-matt-pocock-skills` 設定的追蹤系統呈現兩種讀法：**本機檔案**（`tickets.md`）把關係邊寫成文字，你由上而下手動推進；**真實追蹤系統**則把它們寫成原生的阻擋連結，於是任何阻擋者都已完成的工單就落在前緣上，多個代理可以同時開跑。無論哪一種，關係邊都存在工單裡，介質只決定有沒有東西會平行地依它行動。

  發布時，父項 → 切片優先使用追蹤系統的**原生子議題**，`Blocked by` 優先使用**原生阻擋關係邊**（在追蹤系統支援的前提下），並保留 `## Parent`／`## Blocked by` 內文區塊作為備援。「What to build」樣板現在指向 `/prototype` 的程式碼位置，而不是把片段內嵌進去。

  `ask-matt` 的主流程現在路由為 `idea → /to-spec → /to-tickets → /implement`，並在 `docs/engineering/to-spec.md` 與 `docs/engineering/to-tickets.md` 提供給人看的文件頁。

- [#464](https://github.com/mattpocock/skills/pull/464) [`0557d57`](https://github.com/mattpocock/skills/commit/0557d57579d9b3d39839fdaf8d4a6542b17539ce) Thanks [@mattpocock](https://github.com/mattpocock)! - 在文件中把 wayfinder 的定位確定為**因應特定情境的入口**，而不是新的主要進入流程；以拷問為首的 *idea → ship* 鏈仍然是正門（把 wayfinder 加冕為預設主幹是 v2 等級的動作，不是 1.1）。**`ask-matt`** 路由器現在寫出 wayfinder 的具體觸發條件（全新專案，或大到塞不進一個 session 的大型功能建置），而兩個拷問正門（**`grill-me`**、**`grill-with-docs`**）則在遇到大到一個 session 裝不下的工作時，往*上*指向 wayfinder，讓這個入口從讀者實際起步的地方就找得到。

- [#464](https://github.com/mattpocock/skills/pull/464) [`639df6e`](https://github.com/mattpocock/skills/commit/639df6e7386dfddc739b2aecdeff37a876f2483b) Thanks [@mattpocock](https://github.com/mattpocock)! - 把 **`wayfinder`** 升級並重新定調，這是用來規劃一大塊、超出單一代理 session 所能承載的工作的技能。它從 `in-progress/` 移進 `engineering/`（plugin 項目、頂層與 Engineering README 的**使用者觸發**區塊、`docs/engineering/wayfinder.md` 文件頁，以及 `ask-matt` 裡的一條路由），正式成為成熟技能。讓它走到這一步的更名與重新定調如下：

  - **`decision-mapping` 更名為 `wayfinder`**，以 `/wayfinder` 觸發。「Decision map」既像行話又不準確，實際上只有一種工單類型真的是決策。重新定調後，它畫的是穿越一個迷霧問題的路線，給出一組彼此連貫的前導詞框架（**戰爭迷霧**、**前緣**、**地圖**），而不是在上面再疊一個生造的術語。
  - **以目的地作為前導詞。** Wayfinding 找的是通往某個目的地的*路*，它不會衝去把它蓋出來。指名目的地是製圖的第一個動作，它固定了範圍、形塑每一張工單，所以地圖多了一個每個 session 都以它為準的 `## Destination` 欄位，而分流會在任何工單存在之前先把它釘住。
  - **規劃，不執行。** 這張地圖產出的是**決策，不是交付物**；當「在有人開始建之前不再有東西要決定」時，它就完成了。個別工作可以在自己的 Notes 裡覆寫這一點。
  - **地圖是索引，不是儲存區。** 一項決策只存在於一個地方，也就是它的工單，所以地圖只做摘要與連結，絕不重述；把迷霧升級成工單時，會清掉那塊已升級的區域，才不會有東西同時留在兩個地方。
  - **預設就是協作的。** 地圖從本機 Markdown 檔搬到儲存庫的議題追蹤系統上：一個 `wayfinder:map` 議題，工單是它的子議題，也就是一個團隊可以一起盯的共享網址。Session 以低解析度載入地圖，需要時再放大到個別工單。Wayfinder 透過 `docs/agents/issue-tracker.md` 裡的指標維持與追蹤系統無關（GitHub、GitLab、本機 Markdown），而 `setup-matt-pocock-skills` 會佈下「Wayfinding operations」那一節。
  - **以指派認領，不用標籤。** 一個 session 藉由把工單指派給主導的開發者來認領它，被指派人*就是*認領本身，這讓標籤詞彙可以只留給 `wayfinder:<type>`。
  - **原生阻擋。** 阻擋關係優先使用追蹤系統的原生相依關係，它會在追蹤系統自己的 UI 上把前緣視覺化，讓人不必打開地圖就看得到哪些可以領。GitHub 與 GitLab 樣板寫明了原生做法，並保留內文慣例作為備援。
  - **迷霧與範圍外，分開。** 地圖有兩個名稱直白的區塊：`## Not yet specified`（範圍內的迷霧，會隨前緣推進而升級）與 `## Out of scope`（被判定超出目的地的工作，直接關閉，永不升級），這樣超出目的地的工作就不會被讀成可以領的前緣。
  - **第四種 `task` 工單類型。** 用於阻擋某個決策的實際手動工作（開通存取權限、搬資料、註冊某項服務），這是唯一一種*做事*而非做決策的類型，它靠解除某個決策的阻擋來換得存在的資格。
  - **HITL／AFK 工單分類。** 每一種工單類型不是 **HITL**（human in the loop，人在迴圈中，例如拷問、原型），就是 **AFK**（代理獨自作業，例如研究；task 兩者皆可）。HITL 工單只能透過即時往返來解決，所以「等人類」這件事直接從標籤推導出來，一個自問自答的拷問代理，依定義就是破壞了 HITL。（這修掉了學員回報 `/wayfinder` 拷問*它自己*而不是拷問人類的問題。）
  - **恢復無迷霧時的提早離開。** 如果一開始的廣度優先拷問沒有翻出任何迷霧，代表這趟旅程小到一個 session 就能裝下，所以它會停下來問你想怎麼進行，而不是去建一張沒人需要的地圖。

### Patch Changes

- [#464](https://github.com/mattpocock/skills/pull/464) [`639df6e`](https://github.com/mattpocock/skills/commit/639df6e7386dfddc739b2aecdeff37a876f2483b) Thanks [@mattpocock](https://github.com/mattpocock)! - 把 **`tdd`** 重塑成純參考型技能，並補上一個缺漏的反模式。

  **純參考。** red → green → refactor 迴圈已經由模型本身持有的前導詞錨定住，所以逐步的 Workflow 大多只是在重述這個迴圈。拿掉 Workflow 與每一輪的檢查清單；把其中唯一耐久的想法（垂直切片／曳光彈）併進反模式那一節與一份簡短的「迴圈規則」清單。引入 **seam**（接縫）作為「測試放哪裡」的前導詞：只在事先約定的接縫上測試，且在寫下任何測試之前先與使用者確認。也拿掉了 refactor 階段，TDD 現在是 red → green；重構屬於審查階段，所以重構規則與 `refactoring.md` 都移出去了（它們的家是 `code-review`）。

  **套套邏輯測試。** 新增套套邏輯測試（tautological test）這個反模式：一個斷言是用程式碼同樣算法重算一次的測試，天生必定通過，提供零信心，這與已經涵蓋的「與實作耦合」反模式不同。它以同級身分被加在同樣的幾個位置：一條 Philosophy 原則（期望值必須來自獨立的事實來源）、一道檢查清單關卡，以及 `tests.md` 裡一組 BAD／GOOD 對照範例。

- [`e00eadb`](https://github.com/mattpocock/skills/commit/e00eadb4bb32c3d5a631ead1a5ed5d6a7c5f74e2) Thanks [@mattpocock](https://github.com/mattpocock)! - 擴充 **`triage`** 技能，使其能分流外部 pull request，把 PR 視為附帶程式碼的議題，走同一套角色與狀態機。PR 與議題並行地就地流動（由各儲存庫的設定開關控制），探索階段只呈現外部 PR，原本只針對 bug 的「重現」步驟被一般化為單一的「驗證這項主張」步驟，另有一道冗餘檢查會把已經實作過的請求解決為 `wontfix`，而不汙染範圍外的知識庫。`setup-matt-pocock-skills` 針對 GitHub／GitLab 新增了「把 PR 當成需求入口」的開關。

- [#472](https://github.com/mattpocock/skills/pull/472) [`d869d45`](https://github.com/mattpocock/skills/commit/d869d45afc32beab1c2d1350f8de5e81589512cd) Thanks [@mattpocock](https://github.com/mattpocock)! - 修正 **`wayfinder`** 把議題追蹤系統文件路徑寫死的問題，這破壞了整套技能其餘部分所依賴的間接層。

  `to-issues`、`to-prd` 與 `triage` 從來不寫死路徑，它們透過 `setup-matt-pocock-skills` 寫進 `CLAUDE.md`／`AGENTS.md` 的 `### Issue tracker` 區塊來解析追蹤系統，那個區塊會指向追蹤系統文件實際所在的位置。Wayfinder 卻把 `docs/agents/issue-tracker.md` 這個字面路徑釘死，於是在把代理文件放在別處的儲存庫裡，它會靜默地退回本機 Markdown 追蹤系統，即使那個儲存庫的 `CLAUDE.md` 明明白白宣告使用 GitHub issues。它現在改用同一個指標來解析文件，並以名稱讀取其中的「Wayfinding operations」區塊，讓整套技能的間接層保持一致。

## 1.0.1

### Patch Changes

- [`d20ee26`](https://github.com/mattpocock/skills/commit/d20ee2684e2a9442698ac3c1e0f2c5b68c4cf296) Thanks [@mattpocock](https://github.com/mattpocock)! - 讓 **`teach`** 技能以重用為先。課程現在由 `./assets/` 裡可重用的**元件**組成：樣式表、測驗小工具、模擬器、圖表輔助工具。重用是預設值：代理在撰寫課程前先讀 `./assets/`、用現有的東西來組，並把任何新的、可重用的東西抽成元件，而不是內嵌進去。

## 1.0.0

### Major Changes

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) Thanks [@mattpocock](https://github.com/mattpocock)! - 新增 **`ask-matt`** 技能，一個使用者觸發的路由器，會指出適合你當下情況的技能或流程。

  **破壞性變更：**`ask-matt` 是在這個儲存庫其他使用者觸發技能之上做路由，所以它預期那些技能已經安裝。

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) Thanks [@mattpocock](https://github.com/mattpocock)! - 新增共用的設計類技能，並把既有技能重新接到它們身上。

  - 新的 **`codebase-design`** 技能：深層模組的詞彙（模組、介面、深度、接縫、轉接器）以及「把大量行為藏在小介面之後」的原則。原本住在 `improve-codebase-architecture/LANGUAGE.md` 的語言現在住在這裡，並一般化以便跨技能重用。
  - 新的 **`domain-modeling`** 技能：主動建立並磨利專案的領域模型，拿詞彙表對術語做壓力測試，並讓 `CONTEXT.md` 與 ADR 保持最新。
  - `improve-codebase-architecture` 現在從 `/codebase-design` 取得架構詞彙，從 `/domain-modeling` 取得領域模型。
  - `tdd` 現在在介面設計的指引上倚賴 `/codebase-design`，它內嵌的 `deep-modules.md`／`interface-design.md` 筆記已移除，改用共用技能。
  - `grill-with-docs` 現在透過 `/domain-modeling` 就地建立領域模型。

  **破壞性變更：**這些技能現在相依於新的 `codebase-design`／`domain-modeling` 技能，所以你必須把它們一起裝上。

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) Thanks [@mattpocock](https://github.com/mattpocock)! - 移除 **`caveman`** 與 **`zoom-out`** 技能。

  - `caveman` 是我在測試的另一個技能的複本，本來就不該公開。
  - `zoom-out` 實務上沒人用，所以從儲存庫移除。

  **破壞性變更：**兩個技能都已移除。

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) Thanks [@mattpocock](https://github.com/mattpocock)! - 把 **`diagnose`** 技能更名為 **`diagnosing-bugs`**。

  **破壞性變更：**改用 `/diagnosing-bugs` 觸發，舊的 `/diagnose` 名稱已不存在。

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) Thanks [@mattpocock](https://github.com/mattpocock)! - 以 **`writing-great-skills`** 取代 **`write-a-skill`**。

  - 移除 `write-a-skill`。
  - 新增 `writing-great-skills`（以及它的 `GLOSSARY.md`），一份把技能寫好、改好的參考文件：讓技能具備可預測性的詞彙與原則，並把無效指令一路追殺到句子層級。
  - 把 `grilling` 開放為模型觸發技能，也就是 `grill-me` 與 `grill-with-docs` 背後可重複使用的訪談迴圈。

  **破壞性變更：**`write-a-skill` 已移除，改用 `writing-great-skills`。

### Minor Changes

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) Thanks [@mattpocock](https://github.com/mattpocock)! - 新增 **`resolving-merge-conflicts`** 技能，一個用來解決進行中的 git merge 或 rebase 衝突的迴圈。獨立運作，不相依於其他技能。

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) Thanks [@mattpocock](https://github.com/mattpocock)! - 在文件中把技能分類法從 **Commands／Skills** 更名為**使用者觸發／模型觸發**，並新增 `docs/invocation.md` 定義這條分界：使用者觸發的技能只有在你打出它時才會被觸發，存在的目的是編排；模型觸發的技能則可以在任務對上時自動被觸及。一個使用者觸發的技能可以呼叫模型觸發的技能，但絕不能呼叫另一個使用者觸發的技能。

### Patch Changes

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) Thanks [@mattpocock](https://github.com/mattpocock)! - 收緊 **`review`** 技能：ref 檢查快速失敗、規則單一來源，並刪掉無效內容。
