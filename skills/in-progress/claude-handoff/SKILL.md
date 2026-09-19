---
name: claude-handoff
description: 將目前對話交接給一個新的背景代理，讓它立即接手工作。
argument-hint: "下一個工作階段要用來做什麼？"
disable-model-invocation: true
---

寫一份目前對話的交接摘要，讓一個新的代理能夠接續這項工作。不要儲存它，而是啟動一個以此摘要作為提示的背景代理：`claude --bg --name "<descriptive name>" "<handoff summary>"`。它會在目前的工作目錄中啟動並立即返回；使用者可透過 `claude agents` 來管理它。

務必加上 `-n`/`--name` 並搭配一個具描述性的名稱（例如 `--name "Fix login bug"`）；這會設定在工作清單、工作階段選擇器與終端機標題中顯示的名稱。

在摘要中納入「建議技能」（suggested skills）小節，建議該代理應該呼叫哪些技能。

不要重複其他文件已經記錄的內容（規格、計畫、架構決策紀錄、issue、commit、diff）。改用路徑或 URL 來參照它們即可。

務必遮蔽任何敏感資訊，例如 API 金鑰、密碼或個人識別資訊，因為此摘要將成為代理的提示內容。

如果使用者傳入了參數，請將其視為對下一個工作階段重點的描述，並據此調整摘要內容。
