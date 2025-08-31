#!/bin/bash

# Vérification des arguments
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <URL1> [URL2 ...]"
    exit 1
fi

# Variables
REPORT_FILE="server_status.csv"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
declare -a SERVERS=("$@")  # Tableau des URLs passées en arguments

# Fonction pour vérifier l'état d'un serveur
check_server() {
    local url="$1"
    local status="DOWN"
    local response_time="N/A"
    local http_code="N/A"
    local error_msg=""

    # Exécuter curl avec timeout de 10s et capturer les erreurs
    curl_output=$(curl -s -o /dev/null -w "%{http_code},%{time_total}" --connect-timeout 10 --max-time 15 "$url" 2>&1)
    curl_exit_code=$?

    if [ $curl_exit_code -eq 0 ]; then
        http_code=$(echo "$curl_output" | cut -d',' -f1)
        response_time=$(echo "$curl_output" | cut -d',' -f2)
        # Considérer 200, 301, 302 comme "UP" (redirections courantes)
        if [ "$http_code" -eq 200 ] || [ "$http_code" -eq 301 ] || [ "$http_code" -eq 302 ]; then
            status="UP"
        fi
    else
        error_msg=$(echo "$curl_output" | tr '\n' ' ')  # Capturer l'erreur pour affichage
    fi

    # Débogage : Afficher les détails (commenter en production si souhaité)
    echo "Débogage - URL: $url, HTTP Code: $http_code, Exit Code: $curl_exit_code, Error: $error_msg" >&2

    echo "$url,$status,$response_time,$http_code"
}

# Initialisation du fichier de rapport
echo "Timestamp,URL,Status,ResponseTime,HttpCode" > "$REPORT_FILE"
echo "🔍 Vérification des serveurs..."

# Boucle sur les serveurs
for server in "${SERVERS[@]}"; do
    # Vérification si l'URL est valide (simplifiée)
    if [[ ! "$server" =~ ^https?:// ]]; then
        echo "⚠️ $server n'est pas une URL valide, ignoré."
        continue
    fi

    # Appeler la fonction et ajouter au rapport
    result=$(check_server "$server")
    status=$(echo "$result" | cut -d',' -f2)
    echo "$TIMESTAMP,$result" >> "$REPORT_FILE"
    echo "✅ $server vérifié: $status"
done

echo "📊 Rapport généré dans $REPORT_FILE"