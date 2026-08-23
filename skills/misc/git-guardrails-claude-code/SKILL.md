---
name: git-guardrails-claude-code
description: 設定 Claude Code hooks，在危險的 git 指令（push、reset --hard、clean、branch -D 等）執行前先攔截並阻擋。當使用者想要防止破壞性的 git 操作、新增 git 安全 hook，或封鎖 Claude Code 中的 git push/reset 時使用。
---

# 設定 Git Guardrails

設定一個 PreToolUse hook，在 Claude 執行危險的 git 指令之前就先攔截並阻擋。

## 會被阻擋的項目

- `git push`（包含 `--force` 等所有變化形式）
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`

當指令被阻擋時，Claude 會看到一則訊息，告知它沒有權限執行這些指令。

## 步驟

### 1. 詢問適用範圍

詢問使用者：要安裝在**僅此專案**（`.claude/settings.json`）還是**所有專案**（`~/.claude/settings.json`）？

### 2. 複製 hook 腳本

附帶的腳本位於：[scripts/block-dangerous-git.sh](scripts/block-dangerous-git.sh)

依據適用範圍，將它複製到目標位置：

- **專案**：`.claude/hooks/block-dangerous-git.sh`
- **全域**：`~/.claude/hooks/block-dangerous-git.sh`

用 `chmod +x` 讓它可以執行。

### 3. 將 hook 加入 settings

將以下內容加入對應的 settings 檔案：

**專案**（`.claude/settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

**全域**（`~/.claude/settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

如果 settings 檔案已經存在，請將此 hook 合併進現有的 `hooks.PreToolUse` 陣列中，不要覆蓋其他設定。

### 4. 詢問是否要自訂

詢問使用者是否想在阻擋清單中新增或移除任何模式。若有，請據此修改複製過去的腳本。

### 5. 驗證

執行一個簡單的測試：

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | <path-to-script>
```

應該要以結束碼 2 結束，並在 stderr 印出 BLOCKED 訊息。
