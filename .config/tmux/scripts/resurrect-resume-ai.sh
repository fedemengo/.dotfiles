#!/bin/sh
# tmux-resurrect post-save hook: rewrite every pane running claude or codex so it
# is restored as a resume of THAT pane's exact session, identified per running
# process rather than per directory (several sessions may share a directory).
#
# Enable with:
#   set -g @resurrect-processes 'claude codex'
#   set -g @resurrect-hook-post-save-all '~/.config/tmux/scripts/resurrect-resume-ai.sh'
#
# claude: each live process records ~/.claude/sessions/<pid>.json with its
#   sessionId and its tmux pane (authoritative even when claude is re-parented).
# codex: each live process keeps its rollout .jsonl open; the uuid is in the name.

set -u
uuid_ere='[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'

resurrect_dir=$(tmux show-options -gqv @resurrect-dir)
[ -n "$resurrect_dir" ] || resurrect_dir="$HOME/.local/share/tmux/resurrect"
resurrect_dir=$(printf '%s' "$resurrect_dir" | sed "s#^~#$HOME#")
save_file="$resurrect_dir/last"
[ -f "$save_file" ] || exit 0
resolved=$(readlink "$save_file" 2>/dev/null || printf '%s' "$save_file")
case "$resolved" in /*) target_file=$resolved ;; *) target_file="$resurrect_dir/$resolved" ;; esac

map=$(mktemp "${TMPDIR:-/tmp}/tmmx-resume-map.XXXXXX") || exit 1
panes=$(mktemp "${TMPDIR:-/tmp}/tmmx-panes.XXXXXX") || { rm -f "$map"; exit 1; }
# pane_id \t session \t window_index \t pane_index \t pane_pid
tmux list-panes -a -F '#{pane_id}	#{session_name}	#{window_index}	#{pane_index}	#{pane_pid}' > "$panes"

# claude: one record per live process, located by the pane id it reports.
for json in "$HOME"/.claude/sessions/*.json; do
  [ -f "$json" ] || continue
  pid=$(basename "$json" .json)
  case "$pid" in *[!0-9]*) continue ;; esac
  kill -0 "$pid" 2>/dev/null || continue
  line=$(tr -d '\n' < "$json")
  sid=$(printf '%s' "$line" | grep -oE "\"sessionId\"[[:space:]]*:[[:space:]]*\"$uuid_ere\"" | grep -oE "$uuid_ere" | head -1)
  paneid=$(printf '%s' "$line" | grep -oE "\"tmux\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" | grep -oE '%[0-9]+' | head -1)
  [ -n "$sid" ] && [ -n "$paneid" ] || continue
  awk -F '\t' -v id="$paneid" -v cmd="claude --resume $sid" '$1==id {print $2"\t"$3"\t"$4"\t"cmd}' "$panes" >> "$map"
done

# codex: the pane's own process keeps its rollout open.
descend_codex() {
  queue=$1
  while [ -n "$queue" ]; do
    next=
    for pid in $queue; do
      case "$(ps -o command= -p "$pid" 2>/dev/null | awk '{print $1}')" in
        codex|*/codex) printf '%s\n' "$pid"; return 0 ;;
      esac
      next="$next $(pgrep -P "$pid" 2>/dev/null | tr '\n' ' ')"
    done
    queue=$next
  done
}
while IFS='	' read -r paneid s w p pane_pid; do
  cpid=$(descend_codex "$pane_pid")
  [ -n "$cpid" ] || continue
  uuid=$(lsof -p "$cpid" 2>/dev/null | grep -oE "rollout-[0-9T-]*-$uuid_ere\.jsonl" | grep -oE "$uuid_ere" | head -1)
  [ -n "$uuid" ] && printf '%s\t%s\t%s\tcodex resume %s\n' "$s" "$w" "$p" "$uuid" >> "$map"
done < "$panes"

tmp=$(mktemp "${TMPDIR:-/tmp}/tmmx-resurrect.XXXXXX") || { rm -f "$map" "$panes"; exit 1; }
while IFS= read -r ln; do
  case "$ln" in
    pane*)
      s=$(printf '%s\n' "$ln" | awk -F '\t' '{print $2}')
      w=$(printf '%s\n' "$ln" | awk -F '\t' '{print $3}')
      p=$(printf '%s\n' "$ln" | awk -F '\t' '{print $6}')
      new=$(awk -F '\t' -v s="$s" -v w="$w" -v p="$p" '$1==s && $2==w && $3==p {print $4; exit}' "$map")
      if [ -n "$new" ]; then
        printf '%s\n' "$ln" | awk -F '\t' -v c=":$new" 'BEGIN { OFS="\t" } { $11=c; print }' >> "$tmp"
      else
        printf '%s\n' "$ln" >> "$tmp"
      fi
      ;;
    *) printf '%s\n' "$ln" >> "$tmp" ;;
  esac
done < "$target_file"

cat "$tmp" > "$target_file"
rm -f "$tmp" "$map" "$panes"
