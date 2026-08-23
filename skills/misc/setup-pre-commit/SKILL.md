---
name: setup-pre-commit
description: 在目前的儲存庫中設定 Husky pre-commit hooks，搭配 lint-staged（Prettier）、型別檢查與測試。當使用者想要新增 pre-commit hooks、設定 Husky、設定 lint-staged，或是在 commit 時加入格式化、型別檢查、測試時使用。
---

# 設定 Pre-Commit Hooks

## 這個設定會建立什麼

- **Husky** pre-commit hook
- **lint-staged** 在所有已 staged 的檔案上執行 Prettier
- **Prettier** 設定檔（如果尚未存在）
- pre-commit hook 中的 **typecheck** 與 **test** 腳本

## 步驟

### 1. 偵測套件管理工具

檢查是否有 `package-lock.json`（npm）、`pnpm-lock.yaml`（pnpm）、`yarn.lock`（yarn）、`bun.lockb`（bun）。使用偵測到的那個。若不確定，預設使用 npm。

### 2. 安裝相依套件

安裝為 devDependencies：

```
husky lint-staged prettier
```

### 3. 初始化 Husky

```bash
npx husky init
```

這會建立 `.husky/` 目錄，並在 package.json 中加入 `prepare: "husky"`。

### 4. 建立 `.husky/pre-commit`

寫入這個檔案（Husky v9+ 不需要 shebang）：

```
npx lint-staged
npm run typecheck
npm run test
```

**調整**：將 `npm` 替換為偵測到的套件管理工具。如果儲存庫的 package.json 中沒有 `typecheck` 或 `test` 腳本，就省略對應的那一行，並告知使用者。

### 5. 建立 `.lintstagedrc`

```json
{
  "*": "prettier --ignore-unknown --write"
}
```

### 6. 建立 `.prettierrc`（如果尚未存在）

只有在沒有既有 Prettier 設定時才建立。使用以下預設值：

```json
{
  "useTabs": false,
  "tabWidth": 2,
  "printWidth": 80,
  "singleQuote": false,
  "trailingComma": "es5",
  "semi": true,
  "arrowParens": "always"
}
```

### 7. 驗證

- [ ] `.husky/pre-commit` 存在且可執行
- [ ] `.lintstagedrc` 存在
- [ ] package.json 中的 `prepare` 腳本為 `"husky"`
- [ ] `prettier` 設定存在
- [ ] 執行 `npx lint-staged` 以驗證是否正常運作

### 8. Commit

將所有已變更／新建的檔案加入 staging，並以以下訊息 commit：`Add pre-commit hooks (husky + lint-staged + prettier)`

這會觸發新設定的 pre-commit hooks：這是驗證一切正常運作的良好測試。

## 備註

- Husky v9+ 不需要在 hook 檔案中加入 shebang
- `prettier --ignore-unknown` 會略過 Prettier 無法解析的檔案（圖片等）
- pre-commit 會先執行 lint-staged（速度快，只處理已 staged 的檔案），接著才執行完整的 typecheck 與測試
