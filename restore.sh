#!/bin/bash

[ "$#" -ne 2 ] && { echo "Utilizare: $0 <cale_catre_store.data> <director_destinatie>";  exit 1; }

STORE_FILE="$1"
DEST_DIR="$2"

[ ! -f "$STORE_FILE" ]  && {  echo "Eroare: Fișierul $STORE_FILE nu există.";   exit 1; }

mkdir -p "$DEST_DIR"

while IFS= read -r LINE; do
   
    FILE_NAME=$(echo "$LINE" | awk '{print $1}')
    PERMISSIONS=$(echo "$LINE" | awk '{print $2}')
    CONTENT=$(echo "$LINE" | cut -d' ' -f3-)
    
    TARGET_PATH="$DEST_DIR/$FILE_NAME"
    if [ -e "$TARGET_PATH" ]; then
        TARGET_PATH="$DEST_DIR/_$FILE_NAME"
    fi
    
    echo "$CONTENT" | base64 -d > "$TARGET_PATH"

    chmod "$PERMISSIONS" "$TARGET_PATH"

    echo "Fișier restaurat: $TARGET_PATH (permisiuni: $PERMISSIONS)"

done < "$STORE_FILE"
