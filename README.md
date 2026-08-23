<p>
  <a href="https://www.aihero.dev/s/skills-newsletter">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skills-repo-dark_2x.png">
      <source media="(prefers-color-scheme: light)" srcset="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png">
      <img alt="Skills" src="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png" width="369">
    </picture>
  </a>
</p>

# Skills For Real Engineers

[![skills.sh](https://skills.sh/b/mattpocock/skills)](https://skills.sh/mattpocock/skills)

My agent skills that I use every day to do real engineering - not vibe coding.

Developing real applications is hard. Approaches like GSD, BMAD, and Spec-Kit try to help by owning the process. But while doing so, they take away your control and make bugs in the process hard to resolve.

These skills are designed to be small, easy to adapt, and composable. They work with any model. They're based on decades of engineering experience. Hack around with them. Make them your own. Enjoy.

If you want to keep up with changes to these skills, and any new ones I create, you can join ~60,000 other devs on my newsletter:

[Sign Up To The Newsletter](https://www.aihero.dev/s/skills-newsletter)

## 安裝

這是一份繁體中文精選分支：從 Matt 的技能集裡挑出 9 個譯成中文，攤平掉 bucket 目錄，並統一加上 `mattpocock-` 前綴，避免與其他來源的技能撞名。

```bash
ai-global add-skill lazyjerry/mattpocock-skills
```

會裝進 `~/.ai-global/skills/` 並在 `source.md` 留下來源紀錄，之後用 `ai-global update-skills` 更新。`ai-global relink` 再把它們散佈到各個已設定的代理（Claude Code、Codex、Copilot、Cursor、Antigravity、OpenCode）。

英文原版在上游 [mattpocock/skills](https://github.com/mattpocock/skills)，未經改動。

## 為什麼有這些技能

每個技能想解決哪一種代理失效模式，Matt 在上游 README 寫得很完整：[mattpocock/skills](https://github.com/mattpocock/skills#why-these-skills-exist)。這份分支只保留其中 9 個，沒有重寫那段論述。

## 技能列表

依觸發方式分成兩類。**使用者觸發**只有你打字時才會啟動；**模型觸發**則是你或代理判斷任務相符時都可以取用。

### 模型觸發

- **[mattpocock-tdd](./skills/mattpocock-tdd/SKILL.md)**：測試驅動開發的紅綠重構循環。一次一個垂直切片。
- **[mattpocock-diagnosing-bugs](./skills/mattpocock-diagnosing-bugs/SKILL.md)**：困難錯誤與效能退化的診斷紀律：建立會變紅的回饋迴圈，再最小化、假設、儀器化、修復、回歸測試。
- **[mattpocock-resolving-merge-conflicts](./skills/mattpocock-resolving-merge-conflicts/SKILL.md)**：逐個 hunk 處理進行中的 merge 或 rebase 衝突，依可追溯至各方來源的意圖解決，絕不使用 `--abort`。
- **[mattpocock-wizard](./skills/mattpocock-wizard/SKILL.md)**：產生互動式 bash 精靈，帶人走完只有人類能做的步驟：佈建基礎設施、設定憑證或 CI 密鑰、操作陌生的第三方儀表板。
- **[mattpocock-codebase-design](./skills/mattpocock-codebase-design/SKILL.md)**：設計深層模組的共通詞彙：小介面背後藏大量行為，放在乾淨的接縫上，可透過介面測試。
- **[mattpocock-domain-modeling](./skills/mattpocock-domain-modeling/SKILL.md)**：主動建立並打磨專案的領域模型，挑戰術語、以情境壓力測試，就地更新 `CONTEXT.md` 與 ADR。
- **[mattpocock-research](./skills/mattpocock-research/SKILL.md)**：以背景代理針對第一手來源調查問題，把發現寫成一份附引註的 Markdown 存進儲存庫。
- **[mattpocock-grilling](./skills/mattpocock-grilling/SKILL.md)**：針對計畫、決策或想法不斷質詢使用者，把過程繪成決策樹，一回合問完整個前緣。

### 使用者觸發

- **[mattpocock-handoff](./skills/mattpocock-handoff/SKILL.md)**：把目前的對話彙整成交接文件，供下一個代理接手。
