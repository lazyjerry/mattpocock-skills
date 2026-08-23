---
name: mattpocock-resolving-merge-conflicts
description: "當你需要解決進行中的 git merge/rebase 衝突時使用。"
---

1. **檢視目前狀態**，了解 merge/rebase 的進度。檢查 git 歷史紀錄，以及有衝突的檔案。

2. **找出每個衝突的主要來源。** 深入了解每項變更背後的原因，以及原始意圖為何。閱讀 commit 訊息，查看 PR，並確認原始的 issue/ticket。

3. **逐一解決每個 hunk。** 盡可能保留雙方的意圖。若無法相容，則採用符合此次 merge 目標的版本，並記錄取捨的原因。**不要**自行發明新的行為。務必完成解決；絕不使用 `--abort`。

4. 找出專案的**自動化檢查**並執行，通常依序為 typecheck、測試、格式化。修正 merge 過程中造成的任何問題。

5. **完成 merge/rebase。** 將所有變更加入暫存區並提交。若是 rebase，則持續進行 rebase 流程，直到所有 commit 都完成 rebase。
