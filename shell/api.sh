#!/bin/bash
verifier_api() {
    if curl -s "$1" > /dev/null; then
        echo "API OK"
    else
        echo "API KO"
    fi
}
# verifier_api "https://api.example.com"
verifier_api "https://hooyia.net"
