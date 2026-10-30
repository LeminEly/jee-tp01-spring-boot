#!/usr/bin/env bash
# Montre les points d'acces metier : / puis /teaminfo.
# Quand : application lancee par scripts/run.sh dans un autre terminal.
# Captures a prendre : 01-hello.png puis 02-teaminfo.png
set -uo pipefail

BASE=${BASE:-http://localhost:8080}

montrer() { # $1 = titre, $2 = chemin
	echo "===== $1 ====="
	echo "\$ curl $BASE$2"
	curl -sS "$BASE$2"
	echo
	echo
}

montrer "5.1 : GET /" "/"
montrer "5.2 : GET /teaminfo" "/teaminfo"
