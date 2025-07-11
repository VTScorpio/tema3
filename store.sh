#!/bin/bash

[ "$#" -ne 2 ] && { echo "Utilizare: $0 <director> <cale_store.data>"; exit 1; }   
    
DIR="$1"
S_FILE="$2"

> "$S_FILE"

if [ ! -d "$DIR" ]; then
    echo "Eroare: Directorul $DIR nu există."
    exit 1
fi


find "$DIR" -type f -name "*.sh" | while read -r SCRIPT; do
    SCRIPT_NAME=$(basename "$SCRIPT")
    PERMISSIONS=$(stat -c "%a" "$SCRIPT")
    ENCODED_CONTENT=$(base64 "$SCRIPT" | tr -d '\n')  
    echo "$SCRIPT_NAME $PERMISSIONS $ENCODED_CONTENT" >> "$S_FILE"
done

echo "Fișierul $S_FILE a fost generat cu succes."
