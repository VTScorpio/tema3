#!/bin/bash
# A se declara pana la executie script 
# export BACKUP_FILE_PATH="/cale/file.txt"
# export BACKUP_DIR="backup"
# Executie script
# ./backup_file.sh


[ -z "$BACKUP_FILE_PATH" ] && { echo "Eroare: variabila de mediu BACKUP_FILE_PATH nu este setată."; exit 1; }

[ ! -f "$BACKUP_FILE_PATH" ] && { echo "Eroare: fișierul $BACKUP_FILE_PATH nu există."; exit 1; }

BACKUP_DIR="${BACKUP_DIR:-backup}"

mkdir -p "$BACKUP_DIR"

FILENAME=$(basename "$BACKUP_FILE_PATH")

ORIGINAL_HASH=$(md5sum "$BACKUP_FILE_PATH" | awk '{print $1}')

MATCHED_BACKUP=""
for f in "$BACKUP_DIR"/"$FILENAME"_*.bak; do
  [ -e "$f" ] || continue  
  CURRENT_HASH=$(md5sum "$f" | awk '{print $1}')
  if [ "$CURRENT_HASH" = "$ORIGINAL_HASH" ]; then
    MATCHED_BACKUP="$f"
    break
  fi
done

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="${FILENAME}_${TIMESTAMP}.bak"

if [ -n "$MATCHED_BACKUP" ]; then
  echo "Fișierul există deja cu același conținut. Îl redenumim cu timestamp..."
  mv "$MATCHED_BACKUP" "$BACKUP_DIR/$BACKUP_NAME"
else
  echo "Facem backup nou în $BACKUP_DIR/$BACKUP_NAME"
  cp "$BACKUP_FILE_PATH" "$BACKUP_DIR/$BACKUP_NAME"
fi
