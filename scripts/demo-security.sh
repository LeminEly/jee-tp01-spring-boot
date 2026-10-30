#!/usr/bin/env bash
# Montre que Spring Security protege /actuator/beans : 401 sans identifiants,
# 200 avec. La sortie du 200 est tronquee, la liste des beans est tres longue.
# Quand : apres l'exercice 5.6, application lancee par scripts/run.sh.
# Captures a prendre : 05-beans-401.png puis 06-beans-200.png
set -uo pipefail

BASE=${BASE:-http://localhost:8080}
UTILISATEUR=${UTILISATEUR:-abdou}
MOTDEPASSE=${MOTDEPASSE:-cHk3694}
LIGNES=${LIGNES:-12}

echo "===== 5.6 : GET /actuator/beans SANS identifiants ====="
echo "\$ curl -i $BASE/actuator/beans"
curl -sS -i "$BASE/actuator/beans" | head -n "$LIGNES"
echo
echo

echo "===== 5.6 : GET /actuator/beans AVEC identifiants ====="
echo "\$ curl -i -u $UTILISATEUR:<mot de passe> $BASE/actuator/beans"
curl -sS -i -u "$UTILISATEUR:$MOTDEPASSE" "$BASE/actuator/beans" | head -n "$LIGNES"
echo
echo "[sortie tronquee aux $LIGNES premieres lignes]"
