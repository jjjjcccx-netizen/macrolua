#!/usr/bin/env bash
# 새 세션에서 Instagram agent skill과 내 인스타 파일을 복원합니다.
# 실행: bash instagram/restore.sh
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HOME/oaiwan-tools/instagram-agent-skill"

if [ -d "$SRC/.git" ]; then
  echo "원본 저장소 있음: $SRC (그대로 둠)"
else
  mkdir -p "$HOME/oaiwan-tools"
  git clone https://github.com/Jakeschincariol/instagram-agent-skill.git "$SRC"
fi

mkdir -p "$HOME/.claude/skills" "$HOME/.claude/instagram"
for d in "$SRC"/skills/ig-*; do
  n="$(basename "$d")"
  if [ -e "$HOME/.claude/skills/$n" ]; then
    echo "이미 있음, 건너뜀: $n"
  else
    cp -r "$d" "$HOME/.claude/skills/"
    echo "설치: $n"
  fi
done

for f in voice.md plan.md log.md swipe.md; do
  dst="$HOME/.claude/instagram/$f"
  if [ -e "$dst" ] && ! cmp -s "$HERE/$f" "$dst"; then
    cp "$dst" "$dst.bak-$(date +%Y%m%d%H%M%S)"
    echo "기존 $f 백업함"
  fi
  cp "$HERE/$f" "$dst"
  echo "복원: $f"
done
