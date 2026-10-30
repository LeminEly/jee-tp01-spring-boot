#!/usr/bin/env bash
# Montre que Spring Security protege /actuator/beans : 401 sans identifiants,
# 200 avec. La sortie du 200 est tronquee, la liste des beans est tres longue.
# Quand : apres l'exercice 5.6, application lancee par scripts/run.sh.
# Captures a prendre : 05-beans-401.png puis 06-beans-200.png
set -uo pipefail

BASE=${BASE:-http://localhost:8080}

# Les identifiants sont lus dans application.properties plutot que recopies
# ici : une seule source de verite, et rien a resynchroniser. Surchargeables
# par l'environnement.
PROPS=$(dirname "$0")/../src/main/resources/application.properties
lire() { sed -n "s/^$1=//p" "$PROPS" | tail -1; }
UTILISATEUR=${UTILISATEUR:-$(lire 'spring.security.user.name')}
MOTDEPASSE=${MOTDEPASSE:-$(lire 'spring.security.user.password')}
LIGNES=${LIGNES:-12}
LARGEUR=${LARGEUR:-100}

# Le corps de /actuator/beans tient sur UNE seule ligne de plus de 100 ko :
# tronquer en nombre de lignes ne suffit pas, il faut aussi la largeur, sinon
# la capture d'ecran est illisible.
tronquer() { head -n "$LIGNES" | cut -c "1-$LARGEUR"; }

echo "===== 5.6 : GET /actuator/beans SANS identifiants ====="
echo "\$ curl -i $BASE/actuator/beans"
curl -sS -i "$BASE/actuator/beans" | tronquer
echo
echo

echo "===== 5.6 : GET /actuator/beans AVEC identifiants ====="
echo "\$ curl -i -u $UTILISATEUR:<mot de passe> $BASE/actuator/beans"
curl -sS -i -u "$UTILISATEUR:$MOTDEPASSE" "$BASE/actuator/beans" | tronquer
echo
echo "[sortie tronquee a $LIGNES lignes et $LARGEUR colonnes]"
