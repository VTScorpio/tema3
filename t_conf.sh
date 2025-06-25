#!/bin/bash

# Export variabile, nu exista in sistem. Important pentru a copia si genera dupa template fisierul.

export SERVER=localhost
export PORT=8080
export USERNAME=eu
export PASSWORD=secret123

TEMPLATE="config.template"
OUTPUT="config.conf"

>"$OUTPUT"

while IFS= read -r line; do
	while [[ "$line" =~ \{\{([A-Za-z_][A-Za-z0-9]*)\}\} ]]; do
		key="${BASH_REMATCH[1]}"
		key_value="${!key}"
		line="${line//\{\{$key\}\}/$key_value}"
	done
	echo "$line" >> "$OUTPUT"
done < "$TEMPLATE"	

echo "Fisierul $OUTPUT a fost generat cu succes."	
