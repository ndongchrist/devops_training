#!/bin/bash
# function saluer() {
#     NOM=$1
#     AGE=$2
#     ARRAY=$3
#     echo "Bonjour, $NOM ! Jai $AGE ans, $ARRAY"
# }

# VAR=("Banane" "Pommes")

# saluer 'Bergelin' 30 ${VAR[@]}


if [[ "$1" =~ ^[0-9]+$ ]]; then  # Vérifie si c'est un nombre
    echo "Argument valide"
fi