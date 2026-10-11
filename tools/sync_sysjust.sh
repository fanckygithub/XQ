#!/usr/bin/env bash
# 同步 github.com/sysjust-xq 官方範例到 01_XQ_example/sysjust-xq，並更新 00_XQ_Manual/sources.lock
# 用法：tools/sync_sysjust.sh   （在專案根目錄執行；只做本地鏡像，不 commit）
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$ROOT/01_XQ_example/sysjust-xq"
LOCK="$ROOT/00_XQ_Manual/sources.lock"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
# 格式：上游repo:本地資料夾
MAP="xscript_preset:XScript_Preset-main xs_blocks:XS_Blocks-main xqstrategy:XQStrategy-main vscode-xs:vscode-xs-master"
{
  echo "# 由 tools/sync_sysjust.sh 自動產生；格式：repo<TAB>commit<TAB>提交日期<TAB>同步日"
  for m in $MAP; do
    repo="${m%%:*}"; dir="${m##*:}"
    GIT_LFS_SKIP_SMUDGE=1 git clone -q --depth 1 "https://github.com/sysjust-xq/$repo" "$WORK/$repo"
    rm -rf "$DEST/$dir"; mkdir -p "$DEST/$dir"
    (cd "$WORK/$repo" && tar --exclude=.git -cf - .) | (cd "$DEST/$dir" && tar -xf -)
    printf '%s\t%s\t%s\t%s\n' "$repo" "$(git -C "$WORK/$repo" rev-parse HEAD)" \
      "$(git -C "$WORK/$repo" log -1 --format=%cI)" "$(date +%F)"
  done
} > "$LOCK.new"
mv "$LOCK.new" "$LOCK"
echo "已更新 $LOCK"; git -C "$ROOT" status --short 01_XQ_example 00_XQ_Manual | head -50
