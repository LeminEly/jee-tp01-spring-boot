#!/usr/bin/env bash
# Lance l'application sur le port 8080 par le plugin Maven.
# Quand : avant les scripts demo-*.sh, dans un autre terminal.
# Capture a prendre : aucune. Laisser tourner, puis Ctrl+C pour arreter.
set -euo pipefail
cd "$(dirname "$0")/.."

if [ -f .sdkmanrc ]; then
  version=$(sed -n 's/^java=//p' .sdkmanrc)
  candidat="${SDKMAN_DIR:-$HOME/.sdkman}/candidates/java/$version"
  [ -x "$candidat/bin/javac" ] && { export JAVA_HOME="$candidat"; export PATH="$JAVA_HOME/bin:$PATH"; }
fi

echo "===== Lancement de mycoolapp (plugin Maven) ====="
echo "\$ ./mvnw spring-boot:run"
exec ./mvnw spring-boot:run
