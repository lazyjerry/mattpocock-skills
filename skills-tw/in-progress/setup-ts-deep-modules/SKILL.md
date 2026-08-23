---
name: setup-ts-deep-modules
description: 在 TypeScript 專案中導入 dependency-cruiser，讓每個套件都成為深層模組（deep module），實作細節隱藏在子資料夾中，只能透過其進入點（entry-point）檔案存取。由使用者觸發。
disable-model-invocation: true
---

# Setup TS Deep Modules

讓這個 repo 中的每個套件都成為**深層模組（deep module）**：小介面背後藏著大量行為。套件的公開介面就是它的**進入點（entry points）**（也就是套件根目錄下的檔案），子資料夾中的一切都是隱藏的。這個 skill 會安裝 [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) 以及規則，讓進入點成為唯一的存取途徑，然後驗證這些規則確實有效。

關於相關詞彙（深層模組、介面、seam、深度），請呼叫 Skill 工具並帶入 "codebase-design"，並在整個過程中沿用其用語。

## 這套規則要求的架構

```
src/packages/
  <name>/
    index.ts        ← 一個進入點（公開）。從外部要匯入就是這個檔案。
    client.ts       ← 另一個進入點。套件可以暴露「多個」進入點。
    lib/             ← 實作內容：對外部隱藏，內部檔案間可自由互相匯入。
    tests/           ← 就近放置的測試 + fixtures（也是子資料夾，所以是私有的）。
```

公開介面是套件的**根目錄檔案**，而不是某個指定的 `index.ts`。依照慣例，實作放在 `lib/`，測試放在 `tests/`，讓每個套件都有相同的兩層資料夾架構。不過規則本身是通用的：*任何*子資料夾中的內容都是私有的，所以你永遠不需要為了新增資料夾而擴充設定檔。

四條規則，全部設為 `error`：

1. **進入點邊界**：套件外部的程式碼（app 程式碼或其他套件）只能匯入該套件的進入點（其根目錄檔案），絕不能匯入其子資料夾內的任何東西。
2. **套件內部自由**：套件自己的檔案之間可以自由互相匯入。
3. **測試只能透過進入點**：`<pkg>/tests/` 底下的檔案可以匯入任何套件的進入點以及自己 `tests/` 資料夾內的 fixtures，但絕不能匯入任何套件的子資料夾內部（就算是自己套件的也不行）。跨套件的整合測試沒問題，深層匯入則不行。
4. **禁止循環相依**：不允許有相依循環。

**是進入點，不是 barrel 檔。** 因為公開介面是*每一個*根目錄檔案，套件可以暴露好幾個小型進入點（`index.ts`、`client.ts`、`server.ts`），而不必把所有東西都塞進一個巨大的 `index.ts`。不鼓勵使用重新匯出整棵子樹的 barrel 檔；請保持進入點精簡，把實作藏在子資料夾裡。

分層（哪些套件可以依賴哪些套件）是一個「不同」的議題，設定檔中留了一段註解的預留位置，讓這個 repo 自行填入。

## 步驟

### 1. 偵測環境

- **套件管理工具**：`pnpm-lock.yaml` → pnpm、`yarn.lock` → yarn、`bun.lockb` → bun，否則就是 npm。之後所有指令都要用偵測到的這一個（`pnpm`/`yarn`/`npm run`/`bunx`）。
- **套件根目錄**：如果有 `src/` 就用 `src/packages`，否則用 `packages`。如果這個 repo 已經有明顯不同的慣例，要跟使用者確認這個選擇。
- **既有設定**：檢查是否有 `.dependency-cruiser.*` 檔案。如果已經存在，「不要」覆蓋它：把四條規則和相關選項合併進去，並告訴使用者你加了什麼。

**完成條件：** 套件管理工具、套件根目錄、以及既有設定的狀態都已確認。

### 2. 安裝 dependency-cruiser

用偵測到的套件管理工具，把 `dependency-cruiser` 安裝為 devDependency。

**完成條件：** `dependency-cruiser` 已列在 `devDependencies` 中。

### 3. 寫入設定檔

把 [`dependency-cruiser.config.cjs`](./dependency-cruiser.config.cjs) 複製到 repo 根目錄，命名為 `.dependency-cruiser.cjs`。把 `PACKAGES_ROOT` 設為步驟 1 偵測到的根目錄。這些規則是依路徑深度判斷、與副檔名無關的，所以不需要再調整其他東西。

**完成條件：** `.dependency-cruiser.cjs` 存在，`PACKAGES_ROOT` 正確，且四條禁止規則都在裡面。

### 4. 把它接進檢查流程

- 新增一個 `lint:boundaries` script：`depcruise <packages-root>`（或 `depcruise src`）。
- 把它併入 repo 既有的、會跑 typecheck 的總管檢查指令（例如 `check`/`ci`/`validate` script）。「不要」動 `tsconfig` 或新增 path alias。
- 如果沒有總管 script，就新增 `lint:boundaries`，並告訴使用者要把它加進 CI。

**完成條件：** `lint:boundaries` 存在，且與 typecheck 在同一個指令中一起執行。

### 5. 建立範例套件

建立一個要提交進版控的 `<packages-root>/example/`，作為可複製的範本：

- `index.ts` 是一個進入點。匯出一個函式，該函式委派給內部檔案（這樣套件才會明顯地是「深層」的，而不只是個轉手）。
- `lib/impl.ts`：位於「子資料夾」中的內部檔案，由 `index.ts` 匯入，外部無法存取。
- `tests/example.test.ts` 只匯入 `../index`（一個進入點），並針對這個公開函式做斷言。

告訴使用者這是一個起始範本，可以複製或刪除。

**完成條件：** 範例套件已存在，透過根目錄進入點暴露其行為，並把 `impl` 藏在子資料夾中。

### 6. 驗證規則確實有效

這是整個 skill 的完成標準：一個對違規行為不會失敗的設定檔毫無用處。

1. 執行 `lint:boundaries`。在乾淨的範例上必須「通過」。
2. 暫時在 `tests/example.test.ts` 中加入一個深層匯入（例如 `import { thing } from "../lib/impl"`）。再次執行 `lint:boundaries`；必須以 `tests-through-entrypoints` 「失敗」。
3. 還原這個深層匯入。再執行一次，必須再度「通過」。

**完成條件：** 你已經觀察到通過、然後在深層匯入時失敗、然後再度通過。如果步驟 2 沒有失敗，就代表規則沒有正確接上，必須先修好才能結束。

### 7. 記錄這個慣例

在**套件資料夾內**寫一份 `README.md`（`<packages-root>/README.md`，放在它所規範的套件旁邊），內容涵蓋：`src/packages/<name>/` 的架構（進入點在根目錄、`lib/` 放實作、`tests/` 放測試）、「只能透過套件的進入點（其根目錄檔案）匯入」、以及如何執行 `lint:boundaries`。要「明確不鼓勵 barrel 檔」：暴露好幾個小型進入點，而不是透過一個 index 重新匯出整棵子樹。內容保持簡潔，只要放上可複製的範本片段，加上四條規則各一段說明即可。

然後從 repo 的 agent 指示檔（如果有 `CLAUDE.md` 就用它，沒有就用 `AGENTS.md`，兩者都沒有就建立 `AGENTS.md`）加上一個**指引連結**指向它。一行就夠了，例如 `Packages are deep modules: see [src/packages/README.md](./src/packages/README.md) before adding or importing one.`。這樣才能讓 agent 主動發現這條邊界規則，而不是不小心踩到雷。

**完成條件：** `<packages-root>/README.md` 存在，且明確不鼓勵 barrel 檔，且 repo 的 `CLAUDE.md`/`AGENTS.md` 有連結指向它。

## 備註

- 設定檔中的 `$1` 反向參照（dependency-cruiser 的群組比對）就是讓一個套件能存取自己內部、而外部無法存取的關鍵。不要把它們拆成各套件各自獨立的規則。
- 公開或私有是由「深度」決定的：套件的根目錄檔案是進入點；子資料夾中的一切都是私有的。慣例上的子資料夾是 `lib/`（實作）和 `tests/`，但規則本身不會寫死這些名稱：任何子資料夾都是私有的，所以新增資料夾永遠不需要改設定。新增進入點就只是新增一個根目錄檔案（不用 barrel）。
- 套件是「扁平的」：根目錄下只有一層直屬子項目。套件內部可以想嵌多深就嵌多深；但套件不能包含另一個套件。
- 使用 `.cjs`（而非 `.js`），這樣即使 repo 是 `"type": "module"`，設定檔的 `module.exports` 也能正常運作。
