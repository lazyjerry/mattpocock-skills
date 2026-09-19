#!/usr/bin/env bash
set -euo pipefail

# 用法：scripts/sync-orig-skills.sh <上游 ref>   例：scripts/sync-orig-skills.sh v1.2.3
# 把 orig-skills/ 整棵換成上游 mattpocock/skills 在該 ref 的 skills/。
# 只動 orig-skills/；譯文 skills/ 要另外對照更新。

UPSTREAM="https://github.com/mattpocock/skills.git"
REF="${1:?請指定上游 ref（tag、分支或 commit）}"

REPO="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --quiet "$UPSTREAM" "$TMP/upstream"
SHA="$(git -C "$TMP/upstream" rev-parse --verify --quiet "$REF^{commit}")" || {
  echo "上游找不到 ref：$REF" >&2
  exit 1
}

# 先解到暫存目錄，確定成功才替換，避免中途失敗留下半棵樹
mkdir "$TMP/out"
git -C "$TMP/upstream" archive "$SHA" skills | tar -x -C "$TMP/out"

rm -rf "$REPO/orig-skills"
mv "$TMP/out/skills" "$REPO/orig-skills"

# 變數緊接全形字元時 bash 會把後續位元組併進變數名，一律用 ${} 包住
echo "orig-skills/ 已同步到 ${REF}（${SHA}）"
echo "檔案數：$(find "$REPO/orig-skills" -type f | wc -l | tr -d ' ')"
