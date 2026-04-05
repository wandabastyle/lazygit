#!/usr/bin/env bash
set -euo pipefail

msg="$("$HOME/.config/nvim/scripts/git-commit-ai.py")"

if [ -z "${msg}" ]; then
  echo "No commit message generated"
  exit 1
fi

tmp_file="$(mktemp)"

cleanup() {
  rm -f "$tmp_file"
}

trap cleanup EXIT

printf '%s\n' "$msg" > "$tmp_file"

"${EDITOR:-nvim}" "$tmp_file"

final_msg="$(sed -e '/^[[:space:]]*$/d' "$tmp_file")"

if [ -z "${final_msg}" ]; then
  echo "Commit aborted: empty message"
  exit 1
fi

git commit -a -F "$tmp_file"
