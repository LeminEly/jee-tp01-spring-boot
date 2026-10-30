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

Depuis l'exercice 5.6, tout exige une authentification HTTP Basic
(`abdou` / `cHk3694`), sauf `/actuator/health`.

| Methode | Chemin | Reponse | Exercice |
| --- | --- | --- | --- |
| GET | `/` | `Hello World!` | 5.1 |
| GET | `/teaminfo` | `Coach: Mickey Mouse, Team name: The Mouse Club` | 5.2 |
| GET | `/workout` | `Run a hard 5k!` | 5.4 |
| GET | `/actuator/health` | `{"groups":[...],"status":"UP"}` | 5.5 |
| GET | `/actuator/info` | les proprietes `info.app.*` en JSON | 5.5 |
| GET | `/actuator/beans` | la liste des beans Spring | 5.5 |
| GET | `/actuator/metrics` | la liste des metriques | 5.5 |
| GET | `/actuator/metrics/jvm.memory.used` | le detail d'une metrique | 5.5 |

L'exercice 5.3 a servi sur `http://localhost:7070/mycoolapp/...`. Cette
configuration a ete retiree ensuite, comme l'enonce l'autorise, et reste
consultable dans l'historique Git.

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

Les captures vivent dans `screenshots/`. Chacune se prend en lancant le script
indique, dans un terminal, pendant que l'application tourne.

| Fichier | Contenu | Script a lancer |
| --- | --- | --- |
| `01-hello.png` | `GET /` renvoie `Hello World!` | `scripts/demo-endpoints.sh` |
| `02-teaminfo.png` | `GET /teaminfo` renvoie coach et equipe | `scripts/demo-endpoints.sh` |
| `03-health.png` | `GET /actuator/health` renvoie `UP` | `scripts/demo-actuator.sh` |
| `04-info.png` | `GET /actuator/info` renvoie les `info.app.*` | `scripts/demo-actuator.sh` |
| `05-beans-401.png` | `/actuator/beans` sans identifiants renvoie 401 | `scripts/demo-security.sh` |
| `06-beans-200.png` | `/actuator/beans` avec identifiants renvoie 200 | `scripts/demo-security.sh` |
| `07-port-8585.png` | la console montrant le demarrage sur 8585 | `scripts/run-8585.sh` |

Ordre conseille : lancer `scripts/run.sh` dans un terminal, prendre les captures
01 a 06 dans un second, puis arreter l'application et lancer
`scripts/run-8585.sh` pour la capture 07.

## Reponses aux questions

Voir `REPONSES.md` : les huit questions de la section 6 de l'enonce, plus
l'explication de l'ordre de priorite des proprietes et la question rapide de
5.1 bis. Le document se termine par trois observations mesurees qui s'ecartent
de ce que l'enonce annonce.
