# mycoolapp — TP 01, premier projet Spring Boot 4

Application web Spring Boot minimale, support du TP 01 du module JEE. Elle
expose quelques points d'acces HTTP en texte brut pour demontrer le cycle de vie
d'un projet Spring Boot : generer, lancer, configurer, monitorer, securiser.

Il n'y a volontairement ni logique metier, ni base de donnees, ni interface.

## Prerequis

| Outil | Version | Verification |
| --- | --- | --- |
| JDK | **25** | `javac -version` — un JRE ne suffit pas, il faut `javac` |
| Maven | aucun a installer | fourni par le wrapper `./mvnw` |

## Lancer l'application

Trois facons, les trois attendues par l'enonce.

```sh
# 1. Par le plugin Maven, pour developper
./mvnw spring-boot:run

# 2. Par l'archive, comme en production
./mvnw package
java -jar target/mycoolapp-0.0.1-SNAPSHOT.jar

# 3. Par l'archive, en surchargeant le port en ligne de commande
java -jar target/mycoolapp-0.0.1-SNAPSHOT.jar --server.port=8585
```

Aucun serveur d'applications a installer : Tomcat est embarque dans l'archive.

## Points d'acces

Le tableau se remplit au fil des exercices.

| Methode | Chemin | Reponse | Exercice |
| --- | --- | --- | --- |
| | | | |

## Qualite

Les controles tournent avant chaque commit et sont rejoues en integration.

```sh
pre-commit install && pre-commit install --hook-type commit-msg
pre-commit run --all-files
```

| Porte | Ce qu'elle refuse |
| --- | --- |
| `gitleaks` | un secret de forme reconnaissable, sur tout l'historique |
| `detect-private-key` | une cle privee |
| `check-added-large-files` | un fichier de plus de 512 ko |
| `check-yaml` / `check-xml` / `check-json` | un fichier mal forme |
| `trailing-whitespace` / `end-of-file-fixer` | un fichier mal termine |
| `commit-msg-convention` | un message hors convention `type(portee): sujet` |
| `maven-test` | du code qui ne compile pas ou un test rouge |

Chacune a ete soumise a un cas fautif et verifiee comme refusante.

Message de commit attendu : `type(portee): sujet`, par exemple
`feat(5.2): custom properties and /teaminfo`.

## Reglages IntelliJ pour DevTools

Le rechargement a chaud ne fonctionne que si l'IDE recompile de lui-meme.

1. `Settings > Build, Execution, Deployment > Compiler` : cocher
   **Build project automatically**.
2. `Settings > Advanced Settings` : cocher **Allow auto-make to start even if
   developed application is currently running**.

## Captures d'ecran

Tableau a completer : voir `screenshots/`.
