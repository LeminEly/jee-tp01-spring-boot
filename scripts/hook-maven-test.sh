#!/usr/bin/env bash
# Crochet de pre-commit : compile et execute les tests avant d'autoriser le commit.
# Lance par pre-commit. Pour l'executer seul : scripts/hook-maven-test.sh
set -euo pipefail
cd "$(dirname "$0")/.."

# Java 25 est impose par la stack et n'est pas le JDK par defaut du poste.
# On lit la version dans .sdkmanrc pour n'avoir qu'un seul endroit a corriger.
if [ -f .sdkmanrc ]; then
  version=$(sed -n 's/^java=//p' .sdkmanrc)
  candidat="${SDKMAN_DIR:-$HOME/.sdkman}/candidates/java/$version"
  if [ -x "$candidat/bin/javac" ]; then
    export JAVA_HOME="$candidat"
    export PATH="$JAVA_HOME/bin:$PATH"
  fi
fi

# Echouer fort et tot plutot que compiler avec le mauvais JDK : un JRE lance,
# il ne compile pas.
if ! command -v javac >/dev/null 2>&1; then
  echo "javac introuvable. Installer le JDK de .sdkmanrc : sdk env install" >&2
  exit 1
fi
attendue=$(sed -n 's/^java=\([0-9]*\).*/\1/p' .sdkmanrc)
obtenue=$(javac -version 2>&1 | awk '{print $2}' | cut -d. -f1)
if [ -n "$attendue" ] && [ "$obtenue" != "$attendue" ]; then
  echo "javac $obtenue au lieu de $attendue. Lancer : sdk env" >&2
  exit 1
fi

exec ./mvnw -q -B test
