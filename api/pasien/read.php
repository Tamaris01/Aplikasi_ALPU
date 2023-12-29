<?php

include '../db_connect.php';

// Prepare statement
$sql = "SELECT * FROM pasien";
$query = $conn->prepare($sql);

// Execute statement
$query->execute();

// Get result
$result = $query->get_result();

// Check for successful retrieval of data
if ($result->num_rows > 0) {
    $pasienList = array();
    while ($row = $result->fetch_assoc()) {
        $row['foto'] = "" . $row['foto'];
        $row['nomor_rekam_medis'] = 'RM.' . $row['nomor_rekam_medis'];
        $pasienList[] = $row;
    }
    echo json_encode($pasienList);
} else {
    echo json_encode(array('message' => 'No Patients found.'));
}

// Close statement and connection
$query->close();
$conn->close();
?>

