# 撰寫 Agent Brief

Agent brief 是一則結構化留言，會在 issue 或 PR 移動到 `ready-for-agent` 狀態時張貼上去。這是 AFK agent 執行工作時所依據的權威規格文件。原始內文與討論串只是背景脈絡：agent brief 才是合約。

Brief 陳述**agent 該做什麼**，這適用於兩種情境：對於 issue 來說，是從零開始建構變更；對於 PR 來說，是**現有 diff**還缺少什麼：完成它、補上缺口、回應審查意見。原則相同，下方的 PR 範例會說明差異所在。

## 原則

### 耐久性優先於精確性

Issue 可能會在 `ready-for-agent` 狀態下停留數天甚至數週。在這段期間，程式碼庫會持續變動。撰寫 brief 時要讓它即使在檔案被重新命名、搬移或重構後依然有用。

- **應該**描述介面、型別與行為契約
- **應該**指出 agent 需要尋找或修改的特定型別、函式簽章或設定結構
- **不要**引用檔案路徑，因為路徑會過時
- **不要**引用行號
- **不要**假設目前的實作結構會維持不變

### 描述行為，而非流程

描述系統**應該**做什麼，而不是**該怎麼做**。Agent 會重新探索程式碼庫，並自行做出實作決策。

- **好的寫法：**「`SkillConfig` 型別應該接受一個型別為 `CronExpression` 的選填 `schedule` 欄位」
- **不好的寫法：**「打開 src/types/skill.ts，在第 42 行加上 schedule 欄位」
- **好的寫法：**「當使用者不帶任何參數執行 `/triage` 時，應該看到需要處理的 issue 摘要」
- **不好的寫法：**「在主要處理函式中加入一個 switch 陳述式」

### 完整的驗收標準

Agent 需要知道自己什麼時候算完成。每個 agent brief 都必須有具體、可驗證的驗收標準。每一項標準都應該能夠獨立驗證。

- **好的寫法：**「執行 `gh issue list --label needs-triage` 會回傳已完成初步分類的 issue」
- **不好的寫法：**「Triage 功能應該要正常運作」

### 明確的範圍界線

寫清楚哪些東西不在範圍內。這能避免 agent 做過頭或對相鄰功能做出假設。

## 範本

```markdown
## Agent Brief

**Category:** bug / enhancement
**Summary:** 一句話描述需要完成的事項

**Current behavior:**
描述目前發生的狀況。對於 bug 而言，這是損壞的行為。
對於 enhancement 而言，這是功能所建構的現狀。

**Desired behavior:**
描述 agent 完成工作後應該發生的狀況。
邊界情況與錯誤條件要具體說明。

**Key interfaces:**
- `TypeName`：需要變更什麼以及原因
- `functionName()` 的回傳型別：目前回傳什麼、應該回傳什麼
- 設定結構：任何需要的新設定選項

**Acceptance criteria:**
- [ ] 具體、可驗證的標準 1
- [ ] 具體、可驗證的標準 2
- [ ] 具體、可驗證的標準 3

**Out of scope:**
- 在這個 issue 中不應該變更或處理的事項
- 看似相關但其實是獨立的相鄰功能
```

## 範例

### 好的 agent brief（bug）

```markdown
## Agent Brief

**Category:** bug
**Summary:** Skill 描述截斷時會截到單字中間，產生破損的輸出

**Current behavior:**
當 skill 描述超過 1024 個字元時，無論單字邊界為何，都會在剛好
1024 個字元處被截斷。這會產生在單字中間結束的描述
（例如「Use when the user wants to confi」）。

**Desired behavior:**
截斷應該在 1024 個字元之前的最後一個單字邊界處進行，
並加上「...」來表示已截斷。

**Key interfaces:**
- `SkillMetadata` 型別的 `description` 欄位：不需要變更型別，
  但填入該欄位的驗證／處理邏輯需要遵守單字邊界
- 任何讀取 SKILL.md frontmatter 並擷取 description 的函式

**Acceptance criteria:**
- [ ] 少於 1024 個字元的描述維持不變
- [ ] 超過 1024 個字元的描述會在 1024 個字元前的最後一個單字邊界處截斷
- [ ] 截斷後的描述以「...」結尾
- [ ] 包含「...」在內的總長度不超過 1024 個字元

**Out of scope:**
- 變更 1024 字元限制本身
- 支援多行描述
```

### 好的 agent brief（enhancement）

```markdown
## Agent Brief

**Category:** enhancement
**Summary:** 新增 `.out-of-scope/` 目錄支援，用來追蹤被駁回的功能請求

**Current behavior:**
當功能請求被駁回時，issue 會被加上 `wontfix` 標籤並留言後關閉。
沒有任何永久記錄來保存這項決定或理由。
未來類似的請求需要維護者自行回想或搜尋先前的討論。

**Desired behavior:**
被駁回的功能請求應該記錄在 `.out-of-scope/<concept>.md`
檔案中，內容包含決定、理由，以及所有提出該功能請求的
issue 連結。在對新 issue 進行分類時，應該檢查這些檔案是否有相符項目。

**Key interfaces:**
- `.out-of-scope/` 中的 Markdown 檔案格式：每個檔案應該有一個
  `# Concept Name` 標題、一行 `**Decision:**`、一行 `**Reason:**`，
  以及一份包含 issue 連結的 `**Prior requests:**` 清單
- Triage 工作流程應該在一開始就讀取所有 `.out-of-scope/*.md` 檔案，
  並依概念相似度比對新進的 issue

**Acceptance criteria:**
- [ ] 將某功能以 wontfix 關閉時，會在 `.out-of-scope/` 中建立／更新對應檔案
- [ ] 該檔案包含決定、理由，以及指向被關閉 issue 的連結
- [ ] 若已存在相符的 `.out-of-scope/` 檔案，新 issue 會被附加到其
      「Prior requests」清單中，而不是建立重複項目
- [ ] 在 triage 過程中，既有的 `.out-of-scope/` 檔案會被檢查，
      並在新 issue 與先前的駁回項目相符時顯示出來

**Out of scope:**
- 自動比對（由人工確認相符與否）
- 重新開啟先前被駁回的功能
- Bug 回報（只有 enhancement 駁回項目會進入 `.out-of-scope/`）
```

### 好的 agent brief（PR）

對於 PR，「Current behavior」描述的是 diff 目前的狀態，brief 會要求 agent 完成或修正它，而不是從零開始建構。

```markdown
## Agent Brief

**Category:** enhancement
**Summary:** 完成貢獻者為 `triage list` 加上的 `--json` 輸出旗標

**Current behavior:**
這個 PR 新增了一個 `--json` 旗標，會將 issue 清單序列化為 JSON。
主要路徑可以運作，且 diff 也符合專案的指令結構。
還有兩個缺口：錯誤仍以人類可讀的文字輸出（而非 JSON），
而且這個新旗標沒有任何測試覆蓋。

**Desired behavior:**
使用 `--json` 時，所有輸出（包含錯誤）都應該是
標準輸出上格式正確的 JSON，指令的結束碼（exit code）維持不變。
當旗標不存在時，現有的人類可讀輸出應維持原樣不動。

**Key interfaces:**
- 該指令的錯誤路徑在使用 `--json` 時，應該輸出
  `{ "error": string }`，而非純文字錯誤訊息
- 重複使用 PR 中已經新增的序列化器（serializer）；不要再引入第二個

**Acceptance criteria:**
- [ ] `triage list --json` 在成功與錯誤情況下都能輸出有效的 JSON
- [ ] 結束碼（exit code）與非 JSON 指令一致
- [ ] 有測試涵蓋 `--json` 成功輸出以及至少一種錯誤情況
- [ ] 預設（非 JSON）輸出與原本逐位元組（byte-for-byte）完全相同

**Out of scope:**
- 為其他任何指令新增 `--json`
- 變更 PR 中已定義的成功回傳資料的 JSON 結構
```

### 不好的 agent brief

```markdown
## Agent Brief

**Summary:** 修一下 triage 的 bug

**What to do:**
Triage 那個東西壞了。看一下主要的檔案，把它修好。
問題大概在第 150 行附近的函式。

**Files to change:**
- src/triage/handler.ts (line 150)
- src/types.ts (line 42)
```

這是不好的示範，原因如下：
- 沒有 category
- 描述模糊（「triage 那個東西壞了」）
- 引用了會過時的檔案路徑與行號
- 沒有驗收標準
- 沒有範圍界線
- 沒有描述目前與期望的行為差異
