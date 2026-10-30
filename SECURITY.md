# Politique de securite

Ce depot est un travail pratique academique (module JEE, SupNum). Il n'est pas
deploye et ne traite aucune donnee reelle.

## Signaler un probleme

Ouvrir un ticket sur le depot, ou ecrire a contact@aman.mr.

Un signalement utile contient : ce qui est affecte, comment le reproduire, ce
qu'un attaquant obtient, et la version testee.

## Identifiants presents dans ce depot

`src/main/resources/application.properties` contient un nom d'utilisateur et un
mot de passe en clair :

```
spring.security.user.name=abdou
spring.security.user.password=cHk3694
```

**C'est voulu, et c'est exige par l'enonce du TP** (exercice 5.6) : le but est
d'observer le comportement par defaut de Spring Security. Ces identifiants ne
protegent qu'une application locale, jetable, servie sur localhost.

Ce ne serait pas acceptable hors d'un TP. En production, un identifiant se lit
dans l'environnement ou dans un gestionnaire de secrets, jamais dans un fichier
suivi par git : l'historique conserve un secret meme apres son retrait, et il
reste valide tant qu'il n'est pas revoque.

## Exposition de tous les points de controle d'Actuator

`application.properties` contient :

```
management.endpoints.web.exposure.include=*
```

**C'est voulu, et exige par l'enonce du TP** (exercice 5.5), dont le bareme note
l'acces a `health`, `info`, `beans` et `metrics`. Le defaut de Spring Boot
n'expose que `health`.

Ce reglage ne serait pas acceptable en production. `/actuator/beans` publie la
liste des beans avec leurs types, donc la pile et les versions des
bibliotheques : une version vulnerable devient immediatement identifiable.
`/actuator/env` publie l'environnement, et son masquage repose sur des motifs de
noms, donc une cle nommee autrement n'est pas masquee. Sur cette application,
qui ne fait rien, `/actuator/beans` expose deja 280 beans.

Ce qui limite le risque ici : l'application n'est jamais deployee, elle n'ecoute
que sur `localhost`, et la mesure confirme que tout sauf `health` repond `401`
sans identifiants. En production, on enumererait les points de controle utiles
au lieu du joker, on lierait la supervision a un port distinct non expose, et on
exigerait une authentification sur l'ensemble.

L'analyse complete est dans `REPONSES.md`, question 7.

## Versions suivies

| Version | Suivie |
| --- | --- |
| `main` | oui, duree du module |
