#!/usr/bin/env bash
set -euo pipefail

# 把 skills/ 整理成 `ai-global add-skill` 可安裝的形狀。
#
# add-skill 只掃 skills/ 一層深、找 skills/<dir>/SKILL.md，掃不到就會退而把
# skills/ 底下的「檔案」當成資源裝進去。所以 bucket 目錄必須攤平。
# 安裝後的目錄名取自 frontmatter 的 name:，不是資料夾名，兩邊都要加前綴。

REPO="$(cd "$(dirname "$0")/.." && pwd)"
PREFIX="mattpocock-"

KEEP=(
  engineering/tdd
  engineering/diagnosing-bugs
  engineering/resolving-merge-conflicts
  engineering/wizard
  engineering/codebase-design
  engineering/domain-modeling
  engineering/research
  productivity/grilling
  productivity/handoff
)

cd "$REPO"
[ -d skills ] || { echo "error: 找不到 skills/" >&2; exit 1; }

staging="$(mktemp -d)"
trap 'rm -rf -- "$staging"' EXIT

for entry in "${KEEP[@]}"; do
  name="$(basename "$entry")"
  [ -d "skills/$entry" ] || { echo "error: 缺少 skills/$entry" >&2; exit 1; }
  mv "skills/$entry" "$staging/${PREFIX}${name}"
  sed -i '' "1,10s|^name: ${name}\$|name: ${PREFIX}${name}|" "$staging/${PREFIX}${name}/SKILL.md"
done

rm -rf skills
mkdir skills
mv "$staging"/* skills/

# 保留的 skill 之間若互相以「名稱」引用，一併改成前綴後的名稱
for entry in "${KEEP[@]}"; do
  name="$(basename "$entry")"
  find skills -name '*.md' -print0 \
    | xargs -0 sed -i '' "s|「${name}」|「${PREFIX}${name}」|g"
done

echo "完成，skills/ 現在是："
for d in skills/*/; do
  printf '  %-42s name: %s\n' "$d" "$(grep -m1 '^name:' "$d/SKILL.md" | cut -d' ' -f2)"
done
