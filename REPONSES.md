# REPONSES.md

Reponses aux questions de la section 6 de l'enonce, plus les deux explications
ecrites demandees en 5.1 bis et 5.7.

---

## 1. Les trois annotations regroupees par `@SpringBootApplication`

| Annotation | Role |
| --- | --- |
| `@EnableAutoConfiguration` | Configure les beans en fonction de ce qui est present sur le classpath. Tomcat et Spring MVC sont presents, donc un serveur web est configure, sans que rien ne le declare. |
| `@ComponentScan` | Balaye le paquet de la classe annotee **et ses sous-paquets**, et enregistre les classes portant `@Component`, `@Service`, `@Repository`, `@Controller`, `@RestController`. |
| `@Configuration` | Fait de la classe une source de definitions de beans, ou des methodes `@Bean` peuvent etre declarees. |

**Si le controleur est dans un paquet frere.** Il n'est pas detecte. `@ComponentScan`
part du paquet de `MycoolappApplication`, ici `com.tp1.mycoolapp`, et ne descend
que vers ses sous-paquets. Un controleur dans `com.tp1.web` n'est pas un
descendant : il n'est jamais enregistre comme bean, aucune route n'est mappee,
et l'appel repond 404. L'application demarre normalement, sans erreur : c'est ce
qui rend la panne deroutante. Deux corrections : deplacer le controleur sous
`com.tp1.mycoolapp`, ou elargir explicitement le balayage avec
`@ComponentScan(basePackages = "com.tp1")`.

## 2. L'auto-configuration

C'est le mecanisme qui deduit la configuration de ce qu'il trouve sur le
classpath, au lieu de l'exiger ecrite. Spring Boot evalue des configurations
candidates sous conditions (`@ConditionalOnClass`, `@ConditionalOnMissingBean`) :
une configuration ne s'applique que si sa dependance est presente et que le
developpeur n'a pas deja fourni son propre bean.

**Exemple concret.** Ajouter `spring-boot-starter-webmvc` suffit a obtenir :

- un serveur Tomcat embarque, demarre sur le port 8080 ;
- le `DispatcherServlet` enregistre et mappe sur `/` ;
- la conversion objet vers JSON par Jackson ;
- la gestion des erreurs par defaut.

Zero ligne de configuration, zero XML. Et le dernier point du mecanisme est le
plus important : `@ConditionalOnMissingBean` signifie que l'auto-configuration
**cede** des que l'on declare soi-meme le bean. Elle ne s'impose pas.

## 3. `./mvnw spring-boot:run` contre `java -jar`

| | `./mvnw spring-boot:run` | `java -jar target/....jar` |
| --- | --- | --- |
| Qui lance | le plugin Maven, dans le cycle de vie du projet | la JVM, directement |
| Ce qui est execute | les classes compilees dans `target/classes` | l'archive packagee |
| Dependances de portee `optional` ou `runtime` de developpement | presentes | exclues du paquet |
| DevTools | **actif** | **inactif** |
| Usage | developpement | execution, y compris en production |

**Pourquoi DevTools n'est actif que dans le premier cas.** DevTools se desactive
lui-meme quand il detecte qu'il tourne depuis une archive packagee : le
rechargement a chaud n'a aucun sens en production, et surveiller le disque y
serait un cout inutile et une surface d'attaque. Le plugin
`spring-boot-maven-plugin` marque par ailleurs la dependance comme exclue du
paquet. Le comportement est donc volontaire des deux cotes.

## 4. Le mot de passe genere par Spring Security

Il est regenere a chaque demarrage parce qu'il est tire aleatoirement en
memoire, et n'est ecrit nulle part : ni fichier, ni base.

Mesure sur deux demarrages consecutifs de cette application, avant ajout des
proprietes :

```
demarrage 1 : Using generated security password: d541de5f-...
demarrage 2 : Using generated security password: 3ada90a4-...
```

Les valeurs sont tronquees ici volontairement. Elles etaient ephemeres et sont
mortes a l'arret du processus, mais recopier un secret en clair dans de la
documentation est l'habitude que ce TP apprend a eviter. Le balayage de secrets
du depot a d'ailleurs refuse le commit qui les contenait en entier : c'est la
porte qui fonctionne. Seul le prefixe est conserve, il suffit a montrer que les
deux valeurs different.

L'utilisateur par defaut est `user`. Apres ajout de
`spring.security.user.name` et `spring.security.user.password`, la ligne
disparait completement du journal.

**Pourquoi c'est un bon defaut.** La question que tout defaut de securite doit
se poser est : que se passe-t-il si le developpeur oublie de le changer ? Ici,
rien de grave. Un identifiant fixe par defaut, lui, finirait en production, et
serait connu de tous puisque documente publiquement. Le choix de Spring Boot est
donc de rendre le defaut **inutilisable durablement** : il force une decision.
L'affichage du mot de passe dans la console rend en plus la protection visible
au premier demarrage, au lieu de silencieuse.

**Pourquoi on le personnalise.** Parce qu'un secret qui change a chaque
redemarrage empeche tout usage reproductible : un script, un test, un collegue,
un outil de surveillance ne peuvent pas s'authentifier.

Dans un vrai systeme, on ne le mettrait pas pour autant dans
`application.properties` : le fichier est suivi par git, et l'historique
conserve un secret meme apres son retrait. Il se lirait dans une variable
d'environnement ou dans un gestionnaire de secrets. Ici, l'enonce demande des
identifiants en clair pour que le comportement soit observable ; le `SECURITY.md`
du depot le documente comme tel.

## 5. L'ordre de priorite des sources de proprietes

Du plus fort au plus faible, vue simplifiee :

1. arguments de ligne de commande (`--server.port=9090`)
2. variables d'environnement (`SERVER_PORT=9090`)
3. `application.properties`
4. valeurs par defaut de Spring Boot

**Reponse a la question posee.** `application.properties` indique
`server.port=8080`, le lancement passe `--server.port=9090` : c'est **9090** qui
est utilise. L'argument de ligne de commande est la source la plus forte, il
ecrase le fichier.

La regle qui rend l'ordre memorisable : plus une source est proche du lancement,
plus elle est prioritaire.

**Verifie sur cette application**, `application.properties` fixant
`server.port=8080` :

| Configuration au lancement | Port reellement utilise |
| --- | --- |
| rien de plus | 8080 |
| `SERVER_PORT=9090` | 9090 |
| `--server.port=8585` | 8585 |
| `SERVER_PORT=9090` **et** `--server.port=8585` | **8585** |

La derniere ligne est celle qui prouve l'ordre entre les deux premieres sources :
l'argument de ligne de commande bat la variable d'environnement.

## 6. `management.info.env.enabled=true`

Cette propriete autorise le point de controle `/actuator/info` a publier les
proprietes du prefixe `info.*`.

**Sans cette ligne**, `/actuator/info` repond `200` avec un objet JSON **vide**,
`{}`. Verifie sur cette application : les trois proprietes `info.app.*` etaient
presentes dans le fichier, et la reponse etait neanmoins `{}`. C'est le point qui surprend : le point de controle existe et repond, mais
ne contient rien. Les proprietes `info.app.name`, `info.app.description` et
`info.app.version` sont bien chargees dans l'environnement, mais le contributeur
qui les expose est desactive par defaut.

**Pourquoi desactive par defaut.** Publier l'environnement expose ce qu'il
contient. Comme `info.*` est un prefixe libre ou n'importe qui peut poser
n'importe quoi, l'activer par defaut reviendrait a publier sans le vouloir ce
qu'un developpeur y aurait range. Le defaut sur : on ne publie pas tant que
personne ne l'a demande.

## 7. Le danger de `/actuator/beans` et `/actuator/env` sans authentification

Ces deux points de controle decrivent le systeme de l'interieur. Ils ne sont pas
une fuite de donnees metier : ils sont une **carte pour l'attaquant**.

`/actuator/beans` donne la liste complete des beans, leurs types et leurs
dependances. On y lit la pile exacte, les bibliotheques et leurs versions. Une
version ancienne et vulnerable devient immediatement identifiable : plus besoin
de chercher la faille, il suffit de la lire.

`/actuator/env` donne l'environnement : variables, proprietes, URL de bases de
donnees, noms d'utilisateur, parfois des jetons. Spring Boot masque les cles dont
le nom evoque un secret, mais ce masquage repose sur des motifs de noms : une
cle nommee autrement n'est pas masquee.

Les deux ensemble transforment une reconnaissance longue en lecture d'un
document. Sur cette application, qui ne fait rien, `/actuator/beans` expose deja
**280 beans** avec leurs types et leurs dependances. Et c'est pour cela que le defaut de Spring Boot n'expose que `/health`.
`management.endpoints.web.exposure.include=*`, utilise dans ce TP, est un
reglage d'apprentissage : en production il se restreint, et ce qui reste expose
s'authentifie.

## 8. `@RestController` contre `@Controller`

`@RestController` equivaut a `@Controller` plus `@ResponseBody` applique a toutes
les methodes de la classe.

- Avec `@Controller`, la chaine retournee par une methode est interpretee comme
  un **nom de vue** a resoudre par un moteur de gabarit. Retourner
  `"Hello World!"` ferait chercher une vue appelee `Hello World!`, qui n'existe
  pas, et l'appel echouerait.
- Avec `@RestController`, la valeur retournee est **le corps de la reponse**,
  ecrit directement par un convertisseur de message. La chaine part telle quelle
  en `text/plain`, un objet partirait en JSON par Jackson.

`@Controller` sert donc une application qui rend des pages ; `@RestController`
sert une API. Dans ce TP, `FunRestController` renvoie du texte brut, donc
`@RestController` est le bon choix.

---

## Question rapide de 5.1 bis : pourquoi ne pas installer Tomcat ?

Parce que Tomcat est **dans** l'archive. `spring-boot-starter-webmvc` apporte
`tomcat-embed-core` comme dependance ordinaire, et le
`spring-boot-maven-plugin` construit une archive executable qui contient a la
fois le code, ses dependances et le serveur.

Le rapport est inverse par rapport au JEE classique. Avant, on installait un
serveur d'applications et on y deployait un `.war` : le serveur hebergeait
l'application. Ici, l'application **contient** son serveur et le demarre
elle-meme dans sa methode `main`. Un `java -jar` suffit.

Ce que cela change en pratique : un seul artefact a livrer, la meme version de
serveur en developpement et en production, et aucune configuration de serveur a
maintenir a cote du code.

## Explication ecrite demandee en 5.7 : l'ordre de priorite et son interet

L'ordre, du plus fort au plus faible : **argument de ligne de commande, variable
d'environnement, `application.properties`, valeur par defaut.**

Demonstration de l'exercice : `application.properties` fixe le port, et
`java -jar ... --server.port=8585` demarre malgre tout sur 8585. Le fichier n'a
pas ete modifie, rien n'a ete recompile.

**L'interet pratique : un seul artefact pour tous les environnements.** La meme
archive, octet pour octet, part en developpement, en pre-production et en
production ; seule la configuration injectee au lancement change. Trois
consequences concretes :

- **Ce qui est teste est ce qui est livre.** Si chaque environnement exigeait sa
  recompilation, l'archive validee en pre-production ne serait pas celle mise en
  production.
- **Les secrets sortent du code.** Mot de passe de base de donnees et cles
  d'API arrivent par l'environnement, donc ne sont jamais committes.
- **Un incident se corrige sans reconstruire.** Changer un port ou un seuil est
  un redemarrage avec un argument different, pas un cycle de compilation et de
  livraison.

C'est aussi la raison du classement : plus une source est proche du moment du
lancement, plus elle est prioritaire, parce que c'est la que vit la connaissance
de l'environnement reel.

---

## Observations de mesure qui s'ecartent de l'enonce

Ces trois points ont ete mesures sur cette application, en Spring Boot 4.0.9 et
Java 25. Ils sont notes parce qu'ils contredisent ce que l'enonce annonce, et
qu'il vaut mieux le savoir avant d'etre interroge dessus.

### 1. Ce que protege la securite par defaut

L'enonce indique, en 5.6, que « `/actuator/health` et `/actuator/info` restent
generalement accessibles ». La mesure donne autre chose :

| Chemin | Sans identifiants | Avec identifiants |
| --- | --- | --- |
| `/actuator/health` | **200** | 200 |
| `/actuator/info` | **401** | 200 |
| `/actuator/metrics`, `/actuator/beans`, `/actuator/env` | 401 | 200 |
| `/`, `/teaminfo`, `/workout` | **401** | 200 |

Deux ecarts a retenir :

- Seul `health` reste ouvert. `info` est protege.
- La protection par defaut couvre **toute l'application**, pas seulement
  Actuator. Les points d'acces metier des exercices 5.1, 5.2 et 5.4 passent en
  401 des que `spring-boot-starter-security` est au classpath. C'est la
  consequence directe du comportement par defaut : Spring Security protege tout
  ce qui n'est pas explicitement ouvert.

### 2. La reponse de `/actuator/health`

L'enonce attend `{"status":"UP"}`. La reponse reelle est :

```json
{"groups":["liveness","readiness"],"status":"UP"}
```

Spring Boot expose desormais les groupes `liveness` et `readiness`, destines aux
sondes d'orchestrateurs. Le `status` attendu est bien la, avec ce supplement.

### 3. Les dependances de test

L'extrait du `pom.xml` de l'enonce montre `spring-boot-starter-test`. Initializr
genere `spring-boot-starter-webmvc-test`, parce que Spring Boot 4 decoupe les
starters de test par technologie. La dependance generee a ete conservee telle
quelle, conformement a la consigne, et `./mvnw test` passe.
