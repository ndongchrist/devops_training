# Cours Complet sur le Shell Scripting 

Bienvenue dans ce cours complet sur le shell scripting, orienté vers les pratiques DevOps. Le shell scripting est un outil puissant pour automatiser des tâches, gérer des configurations, déployer des applications et orchestrer des workflows dans des environnements DevOps. Nous nous concentrerons sur Bash, le shell le plus courant sous Linux, car il est largement utilisé dans les pipelines CI/CD (comme Jenkins, GitHub Actions ou GitLab CI), la gestion d'infrastructures (avec des outils comme Ansible ou Terraform), et l'automatisation quotidienne.

Ce cours est structuré de manière progressive : nous commencerons par les bases et progresserons vers des concepts plus avancés. Chaque section inclut des explications détaillées, des exemples de code, et des bonnes pratiques DevOps. À la fin, nous analyserons un script exemple que vous avez fourni, qui illustre l'application réelle de ces concepts pour interagir avec l'API GitHub.

**Prérequis :** 
- Connaissances de base en ligne de commande Linux (comme `ls`, `cd`, `echo`).
- Un environnement Linux ou macOS avec Bash installé (vérifiez avec `bash --version`).

**Objectifs du cours :**
- Comprendre les fondements du shell scripting.
- Apprendre à structurer des scripts robustes et maintenables.
- Appliquer ces concepts dans un contexte DevOps, comme l'automatisation d'interactions avec des APIs ou la génération de rapports.

Allons-y !

## 1. Introduction au Shell Scripting
Le shell scripting consiste à écrire des scripts (fichiers exécutables) qui exécutent une série de commandes shell. En DevOps, cela permet d'automatiser des tâches répétitives, comme la vérification de dépendances, le déploiement de code, ou la surveillance de systèmes.

- **Pourquoi Bash ?** C'est le shell par défaut sur la plupart des distributions Linux. Il est compatible avec POSIX et étend les fonctionnalités de base.
- **Création d'un script :** Créez un fichier avec l'extension `.sh` (ex. : `mon_script.sh`), rendez-le exécutable avec `chmod +x mon_script.sh`, et exécutez-le avec `./mon_script.sh`.
- **Bonne pratique DevOps :** Utilisez des scripts pour des tâches idempotentes (qui produisent le même résultat à chaque exécution) et intégrez-les dans des pipelines.

## 2. Le Shebang (#!)
Le shebang est la première ligne d'un script qui indique l'interpréteur à utiliser. Sans lui, le système pourrait utiliser un shell par défaut incompatible.

- **Syntaxe :** `#!/chemin/vers/l'interpréteur`
- **Exemple courant :** `#!/bin/bash` pour Bash, ou `#!/bin/sh` pour un shell POSIX plus portable.
- **Pourquoi en DevOps ?** Assure la portabilité des scripts dans des conteneurs Docker ou des VMs cloud.

**Exemple :**
```bash
#!/bin/bash
echo "Bonjour, DevOps !"
```
- Exécutez-le : Il affiche "Bonjour, DevOps !".
- Si vous utilisez `#!/usr/bin/env bash`, cela rend le script plus portable en cherchant `bash` dans le PATH.

**Astuce :** Toujours inclure le shebang pour éviter des erreurs d'exécution.

## 3. Les Variables : Définition et Utilisation
Les variables stockent des données (chaînes, nombres) pour les réutiliser. En Bash, elles sont dynamiquement typées (pas besoin de déclarer le type).

- **Définition :** `NOM_VARIABLE=valeur` (sans espaces autour du `=`).
- **Accès :** `$NOM_VARIABLE` ou `${NOM_VARIABLE}` pour plus de sécurité (ex. : pour concaténer).
- **Types :**
  - Variables locales : Définies dans le script ou une fonction.
  - Variables d'environnement : Exportées avec `export NOM_VARIABLE=valeur` pour les rendre disponibles aux sous-processus (utile en DevOps pour passer des secrets comme des tokens API).
  - Variables spéciales : `$0` (nom du script), `$1` (premier argument), `$#` (nombre d'arguments), `$?` (code de sortie de la dernière commande).
- **Bonne pratique :** Utilisez des noms en majuscules pour les constantes. Échappez les variables avec des guillemets pour éviter les injections : `"$VAR"`.

**Exemple simple :**
```bash
#!/bin/bash
NOM="Alice"
AGE=30
echo "Bonjour, $NOM ! Tu as $AGE ans."
```
- Sortie : "Bonjour, Alice ! Tu as 30 ans."

**Exemple DevOps :** Passer des arguments au script.
```bash
#!/bin/bash
REPO=$1  # Premier argument
echo "Déploiement sur $REPO en cours..."
```
- Exécution : `./script.sh mon-repo` affiche "Déploiement sur mon-repo en cours...".

**Astuce :** Vérifiez si une variable est définie avec `[ -z "$VAR" ]` (z pour zéro longueur).

## 4. Les Fonctions
Les fonctions regroupent du code réutilisable, améliorant la modularité. En DevOps, elles aident à structurer des scripts complexes pour des pipelines.

- **Définition :** `function nom_fonction() { ... }` ou simplement `nom_fonction() { ... }`.
- **Appel :** `nom_fonction arg1 arg2`.
- **Retour :** Utilisez `return valeur` pour un code de sortie, ou `echo` pour renvoyer une valeur (capturez-la avec `resultat=$(nom_fonction)`).
- **Arguments :** Accédez via `$1`, `$2`, etc., dans la fonction.
- **Portée :** Les variables sont globales par défaut ; utilisez `local` pour les rendre locales.

**Exemple :**
```bash
#!/bin/bash
saluer() {
    local NOM=$1
    echo "Bonjour, $NOM !"
}
saluer "Bob"
```
- Sortie : "Bonjour, Bob !"

**Exemple DevOps :** Une fonction pour vérifier une API.
```bash
#!/bin/bash
verifier_api() {
    if curl -s "$1" > /dev/null; then
        echo "API OK"
    else
        echo "API KO"
    fi
}
verifier_api "https://api.example.com"
```

**Bonne pratique :** Nommez les fonctions de manière descriptive et gérez les erreurs à l'intérieur.

## 5. Les Conditions et les Comparaisons
Les structures conditionnelles permettent de prendre des décisions basées sur des tests. En Bash, utilisez `if`, `elif`, `else`, et `fi` pour clore.

- **Syntaxe de base :**
  ```bash
  if [ condition ]; then
      # code
  else
      # code
  fi
  ```
- **Comparaisons :**
  - Chaînes : `=`, `!=`, `-z` (vide), `-n` (non vide). Ex. : `[ "$VAR" = "valeur" ]`.
  - Nombres : `-eq` (égal), `-ne` (différent), `-gt` (supérieur), `-lt` (inférieur), `-ge`, `-le`.
  - Fichiers : `-f` (existe et fichier), `-d` (dossier), `-r` (lisible), `-w` (écrivable), `-x` (exécutable).
  - Opérateurs logiques : `&&` (ET), `||` (OU), `!` (NON).
- **Alternative :** `[[ ]]` pour des tests plus avancés (support des regex avec `=~`).
- **Pourquoi en DevOps ?** Pour valider des inputs, vérifier des états de systèmes, ou gérer des erreurs dans des scripts de déploiement.

**Exemple :**
```bash
#!/bin/bash
AGE=25
if [ $AGE -gt 18 ]; then
    echo "Adulte"
else
    echo "Mineur"
fi
```
- Sortie : "Adulte"

**Exemple avancé :**
```bash
#!/bin/bash
if [[ "$1" =~ ^[0-9]+$ ]]; then  # Vérifie si c'est un nombre
    echo "Argument valide"
fi
```

**Astuce :** Toujours mettre des guillemets autour des variables dans les tests pour éviter les erreurs si elles sont vides.

## 6. Les Boucles
Les boucles répètent du code. En DevOps, elles servent à itérer sur des listes de serveurs, de fichiers, ou de résultats API.

- **For :** Pour itérer sur une liste.
  ```bash
  for VAR in liste; do
      # code
  done
  ```
- **While :** Tant qu'une condition est vraie.
  ```bash
  while [ condition ]; do
      # code
  done
  ```
- **Until :** Jusqu'à ce qu'une condition soit vraie (opposé de while).
- **Contrôles :** `break` (sortir), `continue` (passer à l'itération suivante).

**Exemple For :**
```bash
#!/bin/bash
for i in 1 2 3; do
    echo "Itération $i"
done
```
- Sortie : Itération 1\nItération 2\nItération 3

**Exemple While (DevOps : surveillance) :**
```bash
#!/bin/bash
COMPTEUR=0
while [ $COMPTEUR -lt 5 ]; do
    echo "Vérification en cours... ($COMPTEUR)"
    ((COMPTEUR++))
done
```

**Bonne pratique :** Évitez les boucles infinies en ajoutant des timeouts ou des compteurs.

## 7. L'Écriture dans les Fichiers
Manipuler des fichiers est essentiel en DevOps pour générer des logs, des rapports CSV/JSON, ou des configurations.

- **Redirection :** `>` (écrase), `>>` (ajoute).
- **Exemples :**
  - Écrire : `echo "texte" > fichier.txt`
  - Ajouter : `echo "ligne" >> fichier.txt`
  - Lire : `cat fichier.txt` ou utiliser `while read ligne; do ... done < fichier.txt`
- **Avec des commandes :** Utilisez `tee` pour écrire et afficher : `echo "texte" | tee fichier.txt`
- **Permissions :** Vérifiez avec `-w` avant d'écrire.

**Exemple :**
```bash
#!/bin/bash
FICHIER="rapport.txt"
echo "Début du rapport" > "$FICHIER"
echo "Ligne 1" >> "$FICHIER"
cat "$FICHIER"
```

**Exemple DevOps :** Générer un CSV à partir de données.
```bash
#!/bin/bash
echo "Nom,Age" > data.csv
echo "Alice,30" >> data.csv
```

**Astuce :** Utilisez des guillemets pour gérer les chemins avec espaces. En DevOps, préférez des formats structurés comme JSON pour l'interopérabilité.

## 8. Exécuter des Commandes Linux dans un Script
Un script est une suite de commandes Linux. Vous pouvez les exécuter directement ou les capturer.

- **Exécution simple :** Écrivez la commande comme en ligne de commande (ex. : `ls -l`).
- **Capture de sortie :** `resultat=$(commande)` ou avec des backticks `` `commande` `` (déprécié).
- **Code de sortie :** `$?` pour vérifier si la commande a réussi (0 = succès).
- **En DevOps :** Intégrez des outils comme `curl` pour APIs, `git` pour versionning, `docker` pour conteneurs.
- **Gestion d'erreurs :** Utilisez `||` pour des alternatives : `commande || echo "Échec"`.

**Exemple :**
```bash
#!/bin/bash
DATE=$(date +%Y-%m-%d)
echo "Date actuelle : $DATE"
if ping -c 1 google.com > /dev/null; then
    echo "Internet OK"
fi
```

