<?php
// Connecting to the database
$servername = "fdb1027.eohost.com";
$username = "4205433_stiernon";
$password = "passroot123";
$dbname = "4205433_stiernon";

$conn = new mysqli($servername, $username, $password, $dbname);

// Check the connection
if ($conn->connect_error) {
    die("Erreur de connexion à la base de données : " . $conn->connect_error);
}

// Array to store the values
$tableauValeurs = array();

// Retrieve all values from the mesures table
$sql = "SELECT x, y FROM mesures";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Iterate through the result rows
    while ($row = $result->fetch_assoc()) {
        $tableauValeurs[] = array(
            'x' => $row['x'],
            'y' => $row['y'],
            'case_x' => floor($row['x'] / 0.5),
            'case_y' => floor($row['y'] / 0.5)
        );
    }
}

// Close the database connection
$conn->close();

// Send appropriate HTTP headers to indicate that the response is in JSON format
header('Content-Type: application/json');

// Return the JSON data
echo json_encode($tableauValeurs);
?>
