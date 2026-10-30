#!/usr/bin/env bash
# Crochet commit-msg : impose la convention de message du depot.
# Lance par pre-commit avec le fichier du message en argument.
#
# Forme attendue : type(portee): sujet     la portee est optionnelle
#   type   : feat fix refactor chore docs test sec build ci perf revert
#   portee : numero d'exercice (5.1, 5.1-bis, 5.2 ... ) ou mot-cle (socle)
# Exemple : feat(5.2): custom properties and /teaminfo
# Exemple : ci: run the gates on the working branch
set -euo pipefail

msg_file="$1"
sujet=$(head -n 1 "$msg_file")

# Les messages engendres par git (fusion, retour arriere, correction) passent.
case "$sujet" in
  "Merge "*|"Revert "*|"fixup!"*|"squash!"*) exit 0 ;;
esac

motif='^(feat|fix|refactor|chore|docs|test|sec|build|ci|perf|revert)(\([a-z0-9._-]+\))?: [a-z].{0,60}$'

if ! printf '%s' "$sujet" | grep -qE "$motif"; then
  echo "Message de commit refuse : $sujet" >&2
  echo >&2
  echo "Forme attendue : type(portee): sujet en minuscule, 60 caracteres au plus" >&2
  echo "  la portee entre parentheses est optionnelle" >&2
  echo "  types   : feat fix refactor chore docs test sec build ci perf revert" >&2
  echo "  exemple : feat(5.2): custom properties and /teaminfo" >&2
  echo "  exemple : ci: run the gates on the working branch" >&2
  exit 1
fi
