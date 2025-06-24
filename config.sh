#!/bin/bash

C_F="config.txt"

[ ! -f "$C_F" ] && { echo "Fisierul $C_F nu exista."; return 1; }

while IFS=: read -r key value; do
	[ -z "$key" ] && continue
	[ -z "${!key}" ] && { export "$key=$value"; echo "Inregistrat variabila: $key=$value ."; }
done < "$C_F"

echo "Toate variabilele sunt inregistrate."
