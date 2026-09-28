這是 [mattpocock/skills](https://github.com/mattpocock/skills) 的繁體中文分支。`skills/` 底下是譯好的中文版，`orig-skills/` 保留上游的英文原版供比對，兩邊的目錄名與 `SKILL.md` 的 `name:` 完全相同，只有人類可讀的文字譯過。下面的所有慣例都以 `skills/` 為準，`orig-skills/` 不套用。

技能依 bucket 資料夾組織在 `skills/` 底下：

- `engineering/`：日常的程式工作
- `productivity/`：日常的非程式流程工具
- `misc/`：留著但很少用，不對外主推
- `in-progress/`：beta：刻意公開、需要回饋，不隨 plugin 出貨
- `deprecated/`：已不再使用

`engineering/` 或 `productivity/`（**主推**的 bucket）裡的每一個技能，都必須在頂層 `README.md` 有一則參照，並在 `.claude-plugin/plugin.json` 的 `skills` 陣列中有一筆項目（Claude Code plugin 出貨的內容就是主推的那一組）。`misc/`、`in-progress/`、`deprecated/` 裡的技能則兩邊都不可出現。

安裝指令一律逐字複製自 [.agents/install-block.md](./.agents/install-block.md)。`.claude-plugin/marketplace.json` 讓這個儲存庫成為自己的單一 plugin marketplace（那是安裝區塊裡說明的備援做法，不是正式文件的路徑）。動過任一份 manifest 之後，執行 `claude plugin validate . --strict`。為什麼做成 Claude plugin、而（目前）沒有做 Codex 版本，寫在 [.agents/adr/0002-ship-as-a-claude-code-plugin.md](./.agents/adr/0002-ship-as-a-claude-code-plugin.md)。

頂層 `README.md` 裡的每一則技能項目，都必須把技能名稱連到它的 `SKILL.md`。

每個 bucket 資料夾都有一份 `README.md`，列出該 bucket 裡的每一個技能與一行描述，技能名稱連到它的 `SKILL.md`。主推 bucket 的 `README.md` 與頂層 `README.md` 會把項目分成**使用者觸發**（User-invoked）與**模型觸發**（Model-invoked）兩組；非主推 bucket 的 `README.md`（`misc/`、`in-progress/`）則用平鋪的清單。

`engineering/` 與 `productivity/` 裡的技能還有一份給人看的文件頁，位於 `docs/<bucket>/<skill-name>.md`（文件樹對應 `skills/` 底下那兩個 bucket 資料夾）。無論屬於哪個 bucket，發布網址都是 `https://aihero.dev/skills-<skill-name>`：文件路徑只是儲存庫的組織方式。當你在 `engineering/` 或 `productivity/` 新增、更名或改動某個技能的行為時，依照 [.agents/writing-docs.md](./.agents/writing-docs.md) 建立或重新同步它的文件頁。一份完成的頁面包含四個章節：**What it does**、**When to reach for it**、**Common questions**、**It's working if**。`writing-docs.md` 裡有樣板、章節順序，以及該去哪裡挖出那些問題。非主推 bucket（`misc/`、`in-progress/`、`deprecated/`）裡的技能**不會**有文件頁。

每一份 `SKILL.md` 不是使用者觸發（`disable-model-invocation: true` 加上 `agents/openai.yaml` 裡的 `policy.allow_implicit_invocation: false`，只有人類能觸發），就是模型觸發（模型或使用者都能觸發）。詳見 [.agents/invocation.md](./.agents/invocation.md)。

若要把每個技能（重新）連結到本機的 harness 技能目錄（`~/.claude/skills`、`~/.agents/skills`），執行 `scripts/link-skills.sh`。每一筆項目都是指向這個儲存庫的 symlink，所以 `git pull` 就能讓已安裝的技能保持最新；新增、移除或更名技能之後重跑一次這支腳本。

這個儲存庫的散文（`SKILL.md` 檔、docs、`README.md`、`CHANGELOG.md`、ADR、changeset、程式碼註解）一律不使用 em dash。當某個句子想用它時，改用逗號、冒號、句號、括號或連接詞重寫，看句子實際需要哪一種；絕不要做無腦的字元替換。

## 刻意偏離上游的地方

`skills/` 原則上只翻譯，但下列幾處是刻意改寫，不是誤譯。對照 `orig-skills/` 同步上游時保留這些差異，不要改回去；上游新增的 skill 也要先確認不在移除清單裡再補譯。

- **移除**：`engineering/research`、`misc/scaffold-exercises`，以及 `in-progress/` 底下所有技能（`claude-handoff`、`loop-me`、`setup-ts-deep-modules`、`writing-beats`、`writing-fragments`、`writing-shape`）。
- **移除整條議題追蹤流程**：`engineering/` 的 `wayfinder`、`to-spec`、`to-tickets`、`triage`、`implement`、`setup-matt-pocock-skills`。規格與工單改由規格驅動開發工具（OpenSpec、Spec Kit）處理。`spec-review` 不再依賴 `docs/agents/issue-tracker.md`，找 spec 時多看 `openspec/`。
- **未同步的文件**：剩下技能的 `docs/` 文件頁與 `.agents/` 維護說明仍會提到上面移除的技能。那些是上游的英文說明，連結指向 `aihero.dev` 的上游頁面，所以沒有逐一改寫；以 `skills/` 與 README 為準。
- **更名**：`engineering/code-review` 改名為 `engineering/spec-review`，避免蓋掉 Claude Code 內建的 `/code-review`。所有引用（技能本文、README、manifest、docs）都改用新名稱；docs 裡指向 `aihero.dev/skills-code-review` 的網址不動，那是上游同一個技能的發布頁。
- **`wait-what`**：重講的語言從 ASD-STE100 簡化技術英文改成繁體中文白話。
- **移除 `engineering/ask-matt`**：手動維護的靜態路由地圖只涵蓋本 repo，改由 dev-tools 的 `ask-jerry` 每次即時盤點本機實際安裝的 skills、agents、commands、rules 來路由。技能目錄、plugin 項目、README 列與文件頁一併移除，其他 docs 頁指向 `aihero.dev/skills-ask-matt` 的連結是上游英文說明，不改。
