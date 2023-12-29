<?php
include "../db_connect.php";

// Prepare statement
$query = $conn->prepare("SELECT * FROM poliklinik WHERE status = ?");
$status = 1;
$query->bind_param("i", $status);

// Execute statement
$query->execute();

// Get result
$result = $query->get_result();

// Check for successful retrieval of data
if ($result) {
    $data = $result->fetch_all(MYSQLI_ASSOC);
    echo json_encode($data);
} else {
    die("Query gagal: " . $conn->error);
}

// Close statement and connection
$query->close();
$conn->close();
?>
