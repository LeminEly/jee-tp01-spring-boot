#!/usr/bin/env bash
# Montre les points d'acces metier : / puis /teaminfo.
# Quand : application lancee par scripts/run.sh dans un autre terminal.
#         A partir de 5.6, Spring Security protege aussi ces deux points
#         d'acces : sans identifiants la reponse est un 401 au corps vide.
# Capture a prendre : 01-endpoints.png
set -uo pipefail

BASE=${BASE:-http://localhost:8080}

# Identifiants lus dans application.properties : une seule source de verite.
PROPS=$(dirname "$0")/../src/main/resources/application.properties
lire() { sed -n "s/^$1=//p" "$PROPS" | tail -1; }
UTILISATEUR=${UTILISATEUR:-$(lire 'spring.security.user.name')}
MOTDEPASSE=${MOTDEPASSE:-$(lire 'spring.security.user.password')}

montrer() { # $1 = titre, $2 = chemin
	echo "===== $1 ====="
	echo "\$ curl -u $UTILISATEUR:<mot de passe> $BASE$2"
	# -f : sans lui, curl rend 0 sur un 401 et la sonde affiche du vide
	# au lieu de signaler le refus. Registre du socle, A.38.
	if ! curl -fsS -u "$UTILISATEUR:$MOTDEPASSE" "$BASE$2"; then
		echo "[echec : $BASE$2 n'a pas rendu 2xx]"
	fi
	echo
	echo
}

montrer "5.1 : GET /" "/"
montrer "5.2 : GET /teaminfo" "/teaminfo"
