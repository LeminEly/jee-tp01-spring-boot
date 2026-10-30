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

## Versions suivies

| Version | Suivie |
| --- | --- |
| `main` | oui, duree du module |
