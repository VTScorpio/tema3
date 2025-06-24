#!/bin/bash

if ! command -v curl >/dev/null 2>&1; then
  echo " Pachetul curl nu este instalat. Instalam, va rog  sa introduceti credentialele ... "
  sudo apt update && sudo apt install -y curl

  if ! command -v curl >/dev/null 2>&1; then
    echo " Eroare: pachetul curl nu este instalat. Oprim executare script ... "
    exit 1
  fi
fi

[ "$#" -ne 2 ] && { echo "Utilizare: $0 <URl> <numar_de_verificari>"; exit 1;  }

URL="$1"
N_CHECK="$2"
VAL_ONE=1

while [ "$VAL_ONE" -le "$N_CHECK" ]; do
	STATUS_CODE=$(curl -s -o  /dev/null -w "%{http_code}" "$URL")

	if [ "$STATUS_CODE" -ge  200 ] && [ "$STATUS_CODE" -lt 400 ]; then
		echo " Site-ul $URL este disponibil (status: $STATUS_CODE). "
		exit 0
	else
		echo " [ $VAL_ONE/$N_CHECK ] Site-ul $URL  nu este disponibil (status: $STATUS_CODE). "
	fi 

	VAL_ONE=$(( VAL_ONE + 1 ))
	sleep 1

done

echo " Site-ul $URL nu a fost disponibil dupa $N_CHECK incercari. "
exit 2
