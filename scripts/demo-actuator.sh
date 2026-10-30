#!/usr/bin/env bash
# Montre les points de controle d'Actuator : health puis info.
# Quand : apres l'exercice 5.5, application lancee par scripts/run.sh.
#         A partir de 5.6, les identifiants sont exiges : le script les passe.
# Captures a prendre : 03-health.png puis 04-info.png
set -uo pipefail

BASE=${BASE:-http://localhost:8080}
UTILISATEUR=${UTILISATEUR:-abdou}
MOTDEPASSE=${MOTDEPASSE:-cHk3694}

formater() { # met en forme le JSON si jq est present, sinon affiche brut
	if command -v jq >/dev/null 2>&1; then jq .; else cat; fi
}

montrer() { # $1 = titre, $2 = chemin
	echo "===== $1 ====="
	echo "\$ curl -u $UTILISATEUR:<mot de passe> $BASE$2"
	curl -sS -u "$UTILISATEUR:$MOTDEPASSE" "$BASE$2" | formater
	echo
}

montrer "5.5 : GET /actuator/health" "/actuator/health"
montrer "5.5 : GET /actuator/info" "/actuator/info"
