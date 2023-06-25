#!/bin/bash

# Database connection variables
db_user="4205433_stiernon"
db_password="passroot123"
db_name="4205433_stiernon"
db_host="fdb1027.eohost.com"

# Function to execute MySQL commands
execute_mysql() {
  query="$1"
  echo "$query" | /opt/lampp/bin/mysql -h "$db_host" -u "$db_user" -p"$db_password" "$db_name"
}



numRows=16
numCols=16
caseWidth=0.5
caseHeight=0.5
mic1X=0.25
mic1Y=0.25
mic2X=0.25
mic2Y=7.75
mic3X=7.75
mic3Y=7.75


calculateDistance() {
  local x1=$1
  local y1=$2
  local x2=$3
  local y2=$4
  local distance=$(bc -l <<< "sqrt(($x2 - $x1)^2 + ($y2 - $y1)^2)")
  echo "$distance"
}

# Populating the Coord-Mic Table
for ((row=0; row<numRows; row++))
do
  for ((col=0; col<numCols; col++))
  do
    numCase=$((row * numCols + col + 1))
    x=$(bc -l <<< "($caseWidth * $col) + ($caseWidth / 2)")
    y=$(bc -l <<< "($caseHeight * $row) + ($caseHeight / 2)")
    dMic1=$(calculateDistance "$mic1X" "$mic1Y" "$x" "$y")
    dMic2=$(calculateDistance "$mic2X" "$mic2Y" "$x" "$y")
    dMic3=$(calculateDistance "$mic3X" "$mic3Y" "$x" "$y")

    execute_mysql "INSERT INTO \`Coord\` (\`Num_case\`, \`x\`, \`y\`, \`Dmic1\`, \`Dmic2\`, \`Dmic3\`) VALUES ($numCase, $x, $y, $dMic1, $dMic2, $dMic3);"
  done
done
