#!/bin/bash

# Database connection information
host="fdb1027.eohost.com"
user="4205433_stiernon"
pass="passroot123"
database="4205433_stiernon"

# MQTT topic on which to retrieve the JSON file
mqtt_topic="mesures"

# Variable to store JSON content
json_content=""

# Subscribe to MQTT topic and receive messages
mosquitto_sub -h 192.168.159.129 -p 1883 -t "$mqtt_topic" | while read -r line; do
    # Concatenate row to JSON content
    json_content="$json_content$line"

    # Check if message is end of JSON file
    if [ "$line" = "}" ]; then
        # Extract the values of the keys cap1, cap2, cap3
        cap1=$(echo "$json_content" | jq -r '.cap1')
        cap2=$(echo "$json_content" | jq -r '.cap2')
        cap3=$(echo "$json_content" | jq -r '.cap3')

        # Extract the first two digits and the rest of the values
        idcap1="${cap1:0:2}"
        idcap2="${cap2:0:2}"
        idcap3="${cap3:0:2}"
         val1="${cap1:2}"
        val2="${cap2:2}"
        val3="${cap3:2}"

        # Show extracted values
        echo "id capteur1: $idcap1"
        echo "id capteur2: $idcap2"
        echo "id capteur3: $idcap3"
        echo "valeur1: $val1"
        echo "valeur2: $val2"
        echo "valeur3: $val3"

        # Insert the values into the table
        echo "INSERT INTO \`mesures\`(\`ampb_1\`,\`ampb_2\`,\`ampb_3\`) VALUES (b'$val1',b'$val2',b'$val3');" | /opt/lampp/bin/mysql -h "$host" -u "$user" -p"$pass" -D "$database"

        # Unsubscribe from MQTT topic
        mosquitto_sub -h 192.168.159.129 -p 1883 -t "$mqtt_topic" -C 1 > /dev/null

        # Reset JSON content
        json_content=""
    fi
done
