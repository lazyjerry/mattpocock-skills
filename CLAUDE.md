這是 [mattpocock/skills](https://github.com/mattpocock/skills) 的繁體中文精選分支，用途是當作 `ai-global add-skill` 的安裝來源。

## skills/ 的形狀是被安裝器決定的

`ai-global` 的 `add-skill` 只掃 `skills/` **一層深**，找 `skills/<dir>/SKILL.md`。掃不到就會退而把 `skills/` 底下的**檔案**當成資源裝進去。所以：

- `skills/` 底下只能放 skill 目錄本身，不能有 bucket 分層。
- 每個目錄名與其 `SKILL.md` frontmatter 的 `name:` 都必須是 `mattpocock-<原名>`。安裝後的目錄名取自 `name:`（`extract_meta_name`），不是資料夾名，兩邊不一致會裝出對不上的名字。
- `SKILL.md` 這個檔名寫死在安裝器與各家 harness 裡，不可改名。skill 內部的附屬檔（`template.sh`、`SKILL-MECHANICS.md` 等）也不可改名，內文有引用。
- `add-skill` 用 `git clone --depth 1 --single-branch`，只抓 default branch。要讓變更可安裝，就得推上 `main`。

`orig-skills/` 是上游的英文原版，留著供比對。安裝器掃不到它（只認 `skills` 與 `skill` 這兩個目錄名），
但那是因為 `skills/` 一定找得到東西才輪不到遞迴 fallback。`skills/` 若哪天被清空，遞迴 fallback 就會
把 `orig-skills/` 底下的 36 個 SKILL.md 全撈出來，所以 `skills/` 不能空著。

增刪 skill 一律跑 `scripts/curate-skills.sh`，不要手動搬目錄或改 frontmatter。白名單寫在該腳本的 `KEEP` 陣列裡。

## 連帶要同步的地方

- `.claude-plugin/plugin.json` 的 `skills` 陣列必須等於 `skills/` 的實際內容。改完跑 `claude plugin validate . --strict`。
- 頂層 `README.md` 的技能列表，每個名稱連到自己的 `SKILL.md`，並依觸發方式分成「模型觸發」與「使用者觸發」。
- `docs/` 底下保留對應的說明頁。
- skill 之間若以名稱互相引用（例如 `mattpocock-tdd` 引用 `mattpocock-codebase-design`），改名時要一起改，`curate-skills.sh` 會處理「名稱」形式的引用。

## 其他

每份 `SKILL.md` 不是使用者觸發（`disable-model-invocation: true` 加上 `agents/openai.yaml` 的 `policy.allow_implicit_invocation: false`）就是模型觸發。見 [.agents/invocation.md](./.agents/invocation.md)。

`scripts/link-skills.sh` 把 `skills/` 底下每個 skill 以 symlink 掛進本機的 `~/.claude/skills` 與 `~/.agents/skills`，供開發時直接驗證，不經過 `ai-global`。

本 repo 的中文散文一律不使用破折號。句子想用破折號時，改用逗號、冒號、句號、括號或連接詞，看句子實際需要哪一種，不要做無腦字元替換。
