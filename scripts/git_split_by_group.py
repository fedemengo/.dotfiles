#!/usr/bin/env python3

from __future__ import annotations

import json
import os
import shlex
import subprocess
import sys
import tempfile

VERSION = "0.1.2"
REPO_ROOT: str | None = None


def repo_root() -> str:
    global REPO_ROOT
    if REPO_ROOT is None:
        proc = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"],
            check=True,
            text=True,
            capture_output=True,
        )
        REPO_ROOT = proc.stdout.strip()
    return REPO_ROOT


def git(
    *args: str,
    capture: bool = False,
    input_text: str | None = None,
    env: dict[str, str] | None = None,
) -> str:
    proc = subprocess.run(
        ["git", *args],
        check=True,
        text=True,
        capture_output=capture,
        input=input_text,
        env=env,
        cwd=repo_root(),
    )
    if capture:
        return proc.stdout.strip()
    return ""


def git_allow_failure(
    *args: str,
    env: dict[str, str] | None = None,
) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["git", *args],
        check=False,
        text=True,
        capture_output=True,
        env=env,
        cwd=repo_root(),
    )


def parse_range(range_expr: str) -> tuple[str, str]:
    if ".." not in range_expr:
        raise ValueError("range must use the form A..B")
    start, end = range_expr.split("..", 1)
    if not start or not end:
        raise ValueError("range must use the form A..B")
    return start, end


def commits_in_range(range_expr: str) -> list[str]:
    out = git("rev-list", "--reverse", range_expr, capture=True)
    return [line for line in out.splitlines() if line]


def commit_files(commit: str) -> list[str]:
    out = git("diff-tree", "--root", "--no-commit-id", "--name-only", "-r", commit, capture=True)
    return [line for line in out.splitlines() if line]


def commit_message(commit: str) -> str:
    return git("show", "-s", "--format=%B", commit, capture=True)


def collect_all_files(commits: list[str]) -> list[str]:
    files: set[str] = set()
    for commit in commits:
        files.update(commit_files(commit))
    return sorted(files)


def ensure_clean_worktree() -> None:
    status = git("status", "--porcelain", "--untracked-files=no", capture=True)
    if status:
        raise RuntimeError("working tree must be clean before rewriting history")


def ensure_linear_commits(commits: list[str]) -> None:
    for commit in commits:
        parent_count = len(git("rev-list", "--parents", "-n", "1", commit, capture=True).split()) - 1
        if parent_count > 1:
            raise RuntimeError(f"merge commit {commit} is not supported")


def prompt_group_name(existing: dict[str, list[str]]) -> str:
    import questionary

    while True:
        name = questionary.text("Group name").ask()
        if name is None:
            raise RuntimeError("grouping cancelled")
        name = name.strip()
        if not name:
            print("Group name cannot be empty")
            continue
        if name in existing:
            print("Group name must be unique")
            continue
        return name


def tui_grouping(files: list[str]) -> dict[str, list[str]]:
    import questionary

    remaining = list(files)
    groups: dict[str, list[str]] = {}

    while remaining:
        name = prompt_group_name(groups)
        chosen = questionary.checkbox(
            f"Select files for group '{name}'",
            choices=remaining,
        ).ask()
        if chosen is None:
            raise RuntimeError("grouping cancelled")
        if not chosen:
            print("Group must contain at least one file")
            continue

        groups[name] = chosen
        remaining = [file for file in remaining if file not in chosen]

        if remaining:
            create_another = questionary.confirm(
                f"{len(remaining)} files remain unassigned. Create another group?",
                default=True,
            ).ask()
            if create_another is None:
                raise RuntimeError("grouping cancelled")
            if not create_another:
                print("All files must be assigned to exactly one group")

    return groups


def invert(groups: dict[str, list[str]]) -> dict[str, str]:
    mapping: dict[str, str] = {}
    for group, files in groups.items():
        for file in files:
            mapping[file] = group
    return mapping


def build_plans(commits: list[str], file_to_group: dict[str, str]) -> dict[str, dict[str, list[str]]]:
    plans: dict[str, dict[str, list[str]]] = {}
    for commit in commits:
        buckets: dict[str, list[str]] = {}
        for file in commit_files(commit):
            group = file_to_group.get(file)
            if group is None:
                raise RuntimeError(f"file '{file}' has no assigned group")
            buckets.setdefault(group, []).append(file)
        plans[commit] = buckets
    return plans


def rewrite_todo_lines(lines: list[str], target_commits: set[str]) -> list[str]:
    rewritten: list[str] = []
    for line in lines:
        if not line.startswith("pick "):
            rewritten.append(line)
            continue

        parts = line.split(maxsplit=2)
        if len(parts) < 2:
            rewritten.append(line)
            continue

        short_commit = parts[1]
        if any(commit.startswith(short_commit) for commit in target_commits):
            rewritten.append(f"edit {line[5:]}")
            continue

        rewritten.append(line)
    return rewritten


def rewrite_todo_file(commits_path: str, todo_path: str) -> None:
    target_commits = set(json.loads(open(commits_path, encoding="utf-8").read()))
    with open(todo_path, encoding="utf-8") as handle:
        lines = handle.readlines()
    rewritten = rewrite_todo_lines(lines, target_commits)
    with open(todo_path, "w", encoding="utf-8") as handle:
        handle.writelines(rewritten)


def commit_with_message(message: str) -> None:
    git("commit", "-F", "-", input_text=message)


def ensure_no_pending_changes() -> None:
    staged = git_allow_failure("diff", "--cached", "--quiet")
    unstaged = git_allow_failure("diff", "--quiet")
    if staged.returncode != 0 or unstaged.returncode != 0:
        raise RuntimeError("rewrite left uncommitted changes behind")


def apply_commit_without_committing(commit: str) -> None:
    proc = git_allow_failure("cherry-pick", "--no-commit", commit)
    if proc.returncode != 0:
        raise RuntimeError(proc.stderr.strip() or proc.stdout.strip() or f"failed to apply commit {commit}")


def split_applied_changes(buckets: dict[str, list[str]], original_message: str, order: list[str]) -> None:
    git("reset")

    for group in order:
        files = buckets.get(group)
        if not files:
            continue
        git("add", "--", *files)
        commit_with_message(f"{group}: {original_message}")

    ensure_no_pending_changes()


def first_parent_before(commit: str) -> str | None:
    proc = git_allow_failure("rev-parse", "--verify", f"{commit}^")
    if proc.returncode != 0:
        return None
    return proc.stdout.strip()


def current_branch() -> str:
    proc = git_allow_failure("symbolic-ref", "--quiet", "--short", "HEAD")
    if proc.returncode != 0:
        raise RuntimeError("detached HEAD is not supported")
    return proc.stdout.strip()


def ensure_end_is_on_current_branch(end_ref: str) -> None:
    proc = git_allow_failure("merge-base", "--is-ancestor", end_ref, "HEAD")
    if proc.returncode != 0:
        raise RuntimeError("range end must be an ancestor of HEAD on the current branch")


def temp_branch_name() -> str:
    return f"split-by-group-{os.getpid()}"


def create_rewrite_branch(branch_name: str, start_ref: str) -> None:
    git("switch", "--create", branch_name, start_ref)


def sequence_editor_command(commits_path: str) -> str:
    if getattr(sys, "frozen", False):
        command = [sys.executable, "--rewrite-todo", commits_path]
    else:
        command = [sys.executable, os.path.abspath(__file__), "--rewrite-todo", commits_path]
    return " ".join(shlex.quote(part) for part in command)


def non_interactive_env(extra: dict[str, str] | None = None) -> dict[str, str]:
    env = os.environ.copy()
    env["GIT_EDITOR"] = "true"
    if extra:
        env.update(extra)
    return env


def start_rebase(base_ref: str, commits_path: str) -> None:
    env = non_interactive_env({"GIT_SEQUENCE_EDITOR": sequence_editor_command(commits_path)})
    proc = git_allow_failure("rebase", "-i", base_ref, env=env)
    if proc.returncode != 0:
        raise RuntimeError(proc.stderr.strip() or proc.stdout.strip() or "failed to start rebase")


def continue_rebase() -> None:
    proc = git_allow_failure("rebase", "--continue", env=non_interactive_env())
    if proc.returncode != 0:
        raise RuntimeError(proc.stderr.strip() or proc.stdout.strip() or "failed to continue rebase")


def abort_rebase_if_needed() -> None:
    git_allow_failure("rebase", "--abort", env=non_interactive_env())


def split_current_rebase_commit(commit: str, plans: dict[str, dict[str, list[str]]], order: list[str]) -> None:
    git("reset", "HEAD^")
    split_applied_changes(plans[commit], commit_message(commit), order)


def move_branch_to_rewritten_history(original_branch: str, rewrite_branch: str) -> None:
    new_head = git("rev-parse", rewrite_branch, capture=True)
    git("branch", "-f", original_branch, new_head)
    git("switch", original_branch)
    git("branch", "-D", rewrite_branch)


def main(range_expr: str) -> int:
    ensure_clean_worktree()
    _, end_ref = parse_range(range_expr)
    branch = current_branch()
    ensure_end_is_on_current_branch(end_ref)

    commits = commits_in_range(range_expr)
    if not commits:
        raise RuntimeError("range contains no commits")

    ensure_linear_commits(commits)
    files = collect_all_files(commits)
    if not files:
        raise RuntimeError("range contains no changed files")

    print(f"git-split-by-group {VERSION}")
    groups = tui_grouping(files)
    file_to_group = invert(groups)
    order = list(groups.keys())
    plans = build_plans(commits, file_to_group)

    base_ref = first_parent_before(commits[0])
    if base_ref is None:
        raise RuntimeError("rewriting from the root commit is not supported")

    rewrite_branch = temp_branch_name()
    create_rewrite_branch(rewrite_branch, branch)

    try:
        with tempfile.TemporaryDirectory() as tmpdir:
            commits_path = os.path.join(tmpdir, "commits.json")
            with open(commits_path, "w", encoding="utf-8") as handle:
                json.dump(commits, handle)

            start_rebase(base_ref, commits_path)
            for commit in commits:
                split_current_rebase_commit(commit, plans, order)
                continue_rebase()
        move_branch_to_rewritten_history(branch, rewrite_branch)
    except Exception:
        abort_rebase_if_needed()
        git("switch", branch)
        raise

    return 0


if __name__ == "__main__":
    try:
        if len(sys.argv) == 2 and sys.argv[1] == "--version":
            print(VERSION)
            sys.exit(0)
        if len(sys.argv) == 4 and sys.argv[1] == "--rewrite-todo":
            rewrite_todo_file(sys.argv[2], sys.argv[3])
            sys.exit(0)
        if len(sys.argv) != 2:
            print("usage: split_by_group.py A..B", file=sys.stderr)
            sys.exit(1)
        sys.exit(main(sys.argv[1]))
    except Exception as exc:
        print(f"error: {exc}", file=sys.stderr)
        sys.exit(1)
