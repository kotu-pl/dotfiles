#!/bin/bash
set -eu

BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$BASE/functions"

TEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-links.XXXXXX")"
trap 'rm -rf "$TEMP_DIR"' EXIT
export HOME="$TEMP_DIR/home with spaces"
PUBLIC="$TEMP_DIR/public dotfiles_repo"
PRIVATE="$TEMP_DIR/public dotfiles_repo_private"
mkdir -p "$HOME" "$PUBLIC" "$PRIVATE/local"

# The root path contains both underscores and spaces. Neither is part of
# the destination filename. Private Git identity must win after inclusion.
printf '[user]\n email = personal@example.org\n[include]\n path = ~/.gitconfig-local\n' > "$PUBLIC/ln_gitconfig"
printf '[user]\n email = work@example.org\n' > "$PRIVATE/ln_gitconfig-local"
printf 'public gem config\n' > "$PUBLIC/ln_gemrc"
printf 'local gem config\n' > "$PRIVATE/local/gemrc"
ln -s local/gemrc "$PRIVATE/ln_gemrc"
printf 'existing user config\n' > "$HOME/.gitconfig"

link_configs "$PUBLIC"
test "$(readlink "$HOME/.gitconfig")" = "$PUBLIC/ln_gitconfig"
test "$(git config --file "$HOME/.gitconfig" --includes --get user.email)" = personal@example.org
test -f "$PUBLIC/backup/.gitconfig"

link_configs "$PRIVATE"
test "$(readlink "$HOME/.gitconfig-local")" = "$PRIVATE/ln_gitconfig-local"
test "$(git config --file "$HOME/.gitconfig" --includes --get user.email)" = work@example.org
test "$(readlink "$HOME/.gemrc")" = "$PRIVATE/ln_gemrc"
cmp "$HOME/.gemrc" "$PRIVATE/local/gemrc"

# A second pass leaves the same effective configuration and original backup.
link_configs "$PUBLIC"
link_configs "$PRIVATE"
test "$(git config --file "$HOME/.gitconfig" --includes --get user.email)" = work@example.org
test "$(readlink "$HOME/.gemrc")" = "$PRIVATE/ln_gemrc"
printf 'existing user config\n' | cmp - "$PUBLIC/backup/.gitconfig"

# A checkout without its ignored local gemrc keeps the public fallback.
rm "$PRIVATE/local/gemrc"
link_configs "$PUBLIC"
link_configs "$PRIVATE"
test "$(readlink "$HOME/.gemrc")" = "$PUBLIC/ln_gemrc"

mkdir "$TEMP_DIR/empty_repo"
link_configs "$TEMP_DIR/empty_repo"
printf 'link_configs: all checks passed\n'
