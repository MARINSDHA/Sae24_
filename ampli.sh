#!/bin/bash

# Variables de connexion à la base de données
db_user="4205433_stiernon"
db_password="passroot123"
db_name="4205433_stiernon"
db_host="fdb1027.eohost.com"

# Fonction pour exécuter les commandes MySQL
execute_mysql() {
  query="$1"
  echo "$query" | /opt/lampp/bin/mysql -h "$db_host" -u "$db_user" -p"$db_password" "$db_name"
}


# Récupérer les distances de la table Coord-Mic
distances_query="SELECT \`Num_case\`, \`Dmic1\`, \`Dmic2\`, \`Dmic3\` FROM \`Coord\`;"
distances_result=$(execute_mysql "$distances_query")


# Traitement des valeurs amplifiées pour chaque ligne
IFS=$'\n' read -r -d '' -a distances_lines <<< "$distances_result"

for line in "${distances_lines[@]}"
do
  distances=($line)
  numCase=${distances[0]}
  dMic1=${distances[1]}
  dMic2=${distances[2]}
  dMic3=${distances[3]}


  # Vérifier si la distance est nulle pour éviter une division par zéro
  if (( $(echo "$dMic2 == 0" | bc -l) )); then
    ampMic2=5
  else
    k=1
    ampMic2=$(bc -l <<< "scale=4; $k / ($dMic2 * $dMic2)")
  fi

  if (( $(echo "$dMic3 == 0" | bc -l) )); then
    ampMic3=5
  else
    k=1
    ampMic3=$(bc -l <<< "scale=4; $k / ($dMic3 * $dMic3)")
  fi

  if (( $(echo "$dMic1 == 0" | bc -l) )); then
    ampMic1=5
  else
    k=1
    ampMic1=$(bc -l <<< "scale=4; $k / ($dMic1 * $dMic1)")
  fi

  # Insérer les valeurs amplifiées dans la table Ampli-mic
  execute_mysql "UPDATE \`Coord\` SET \`ampli1\` = $ampMic1, \`ampli2\` = $ampMic2, \`ampli3\` = $ampMic3 WHERE \`Num_case\` = $numCase;"


done <<< "$distances_result"
