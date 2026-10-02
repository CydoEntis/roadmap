#!/usr/bin/env sh
# Installs the roadmap skill from GitHub for Claude Code and Codex, or updates it.
# Every machine runs what is on GitHub; edits happen in a separate clone and ship by
# pull request, so no installed copy is ever edited in place.
set -eu

repo=https://github.com/CydoEntis/roadmap.git
branch=${ROADMAP_BRANCH:-master}
dir=${ROADMAP_HOME:-$HOME/.local/share/roadmap}

if [ -d "$dir/.git" ]; then
  if [ -n "$(git -C "$dir" status --porcelain)" ]; then
    echo "roadmap: $dir has local edits. Make changes in a working clone and ship them by pull request." >&2
    exit 1
  fi
  git -C "$dir" fetch -q origin "$branch"
  git -C "$dir" checkout -q "$branch"
  git -C "$dir" merge -q --ff-only "origin/$branch"
else
  mkdir -p "$(dirname "$dir")"
  git clone -q --branch "$branch" "$repo" "$dir"
fi

for skills in "$HOME/.claude/skills" "$HOME/.codex/skills"; do
  link=$skills/roadmap
  mkdir -p "$skills"
  if [ -e "$link" ] && [ ! -L "$link" ]; then
    echo "roadmap: $link is a real folder, not a link. Move it aside and run this again." >&2
    exit 1
  fi
  ln -sfn "$dir" "$link"
done

echo "roadmap: $(git -C "$dir" log -1 --format='%h %s') on $branch, linked for Claude Code and Codex."
