#!/usr/bin/env bash
# Construit l'archive puis la lance sur le port 8585 par surcharge en ligne de
# commande, alors que application.properties indique un autre port.
# Quand : exercice 5.7. Laisser tourner, Ctrl+C pour arreter.
# Capture a prendre : 07-port-8585.png (la console montrant le demarrage)
set -euo pipefail
cd "$(dirname "$0")/.."

if [ -f .sdkmanrc ]; then
	version=$(sed -n 's/^java=//p' .sdkmanrc)
	candidat="${SDKMAN_DIR:-$HOME/.sdkman}/candidates/java/$version"
	[ -x "$candidat/bin/javac" ] && { export JAVA_HOME="$candidat"; export PATH="$JAVA_HOME/bin:$PATH"; }
fi

echo "===== 5.7 : construction de l'archive ====="
echo "\$ ./mvnw package"
./mvnw -B -q package

echo
echo "===== 5.7 : lancement avec surcharge du port ====="
echo "\$ java -jar target/mycoolapp-0.0.1-SNAPSHOT.jar --server.port=8585"
echo "   (application.properties indique $(sed -n 's/^server.port=//p' src/main/resources/application.properties | head -1), l'argument de ligne de commande gagne)"
echo
exec java -jar target/mycoolapp-0.0.1-SNAPSHOT.jar --server.port=8585
