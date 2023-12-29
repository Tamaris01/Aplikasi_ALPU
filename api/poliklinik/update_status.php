<?php
include "../db_connect.php";

// Periksa ketersediaan variabel POST
if (!isset($_POST['id_poliklinik'], $_POST['status'])) {
    http_response_code(400);
    echo json_encode(['message' => 'Id poliklinik dan status diperlukan']);
    exit();
}

$id = $_POST['id_poliklinik'];
$status = $_POST['status'];

// Persiapkan statement dengan prepared statement untuk mencegah SQL injection
$query = $conn->prepare("UPDATE poliklinik SET status = ? WHERE id_poliklinik = ?");
$query->bind_param("ss", $status, $id);

// Eksekusi query
$query->execute();

// Periksa keberhasilan eksekusi query
if ($query->affected_rows > 0) {
    echo json_encode(['message' => 'Data poliklinik berhasil diubah']);
} else {
    echo json_encode(['message' => 'Gagal mengubah data poliklinik', 'error' => $conn->error]);
}

// Tutup statement dan koneksi ke database
$query->close();
$conn->close();
?>
