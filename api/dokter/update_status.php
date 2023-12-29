<?php
include "../db_connect.php";

// Periksa ketersediaan variabel POST
$nip_dokter = $_POST['nip_dokter'];
$status = $_POST['status'];

// Persiapan statement dengan parameter
$stmt = $conn->prepare("UPDATE dokter SET status = ? WHERE nip_dokter = ?");
$stmt->bind_param("ss", $status, $nip_dokter);
$stmt->execute();

// Periksa apakah query berhasil dijalankan
if ($stmt->affected_rows > 0) {
    echo json_encode(['message' => 'Status Data dokter berhasil diubah']);
} else {
    echo json_encode(['message' => 'Gagal mengubah status data dokter', 'error' => $conn->error]);
}

$stmt->close();
$conn->close();
