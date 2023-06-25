#!/bin/bash

# Database connection information
host="fdb1027.eohost.com"
user="4205433_stiernon"
password="passroot123"
database="4205433_stiernon"
table_mesures="mesures"
table_coord="Coord"

# Function to execute an SQL query and store the results in variables
function execute_sql_query {
    query="$1"
    result=$(/opt/lampp/bin/mysql -h "$host" -u "$user" -p"$password" -D "$database" -se "$query")
    echo "$result"
}

while true; do

# Retrieve the content of columns ampb_1, ampb_2, and ampb_3 from the table mesures
query="SELECT BIN(ampb_1), BIN(ampb_2), BIN(ampb_3) FROM mesures"
result=$(execute_sql_query "$query")

# Iterate through the results
while read -r ampb_1 ampb_2 ampb_3; do
    # Query to retrieve the columns x and y from the table Coord where the values correspond
    query="SELECT x, y FROM Coord WHERE bin1 = b'$ampb_1' AND bin2 = b'$ampb_2' AND bin3 = b'$ampb_3'"
    coord_result=$(execute_sql_query "$query")

    # Iterate through the results of the Coord table
    while read -r x y; do
        echo "Valeurs récupérées depuis la base de données:"
        echo "ampb_1: $(printf "%08d" "$ampb_1")"
        echo "ampb_2: $(printf "%08d" "$ampb_2")"
        echo "ampb_3: $(printf "%08d" "$ampb_3")"
        echo "x: $x"
        echo "y: $y"

        # Update the columns x and y of the mesures table with the corresponding values from the Coord table
        update_query="UPDATE mesures SET x = '$x', y = '$y' WHERE ampb_1 = b'$ampb_1' AND ampb_2 = b'$ampb_2' AND ampb_3 = b'$ampb_3'"
        execute_sql_query "$update_query"
    done <<< "$coord_result"
done <<< "$result"

sleep 1
done
