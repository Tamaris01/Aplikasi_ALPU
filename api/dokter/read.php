<?php

include '../db_connect.php';
$sql = "SELECT a.*, b.nama_lengkap, c.nama_poliklinik FROM dokter a";
$sql .=" LEFT JOIN admin b ON a.id_admin = b.id";
$sql .=" LEFT JOIN poliklinik c ON a.id_poliklinik = c.id_poliklinik";
$sql .=" ORDER BY status DESC";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $dokterList = array();
    while ($row = $result->fetch_assoc()) {
        $row['foto'] = "" . $row['foto'];
        $dokterList[] = $row;
    }
    echo json_encode($dokterList);
} else {
    echo json_encode(array('message' => 'No doctors found.'));
}

$conn->close();
?>
