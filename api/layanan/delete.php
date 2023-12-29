<?php
include "../db_connect.php";

// Ambil nilai id_poliklinik dari variabel POST
$id_poli = $_POST["id_poliklinik"];

// Persiapkan statement dengan parameter untuk mencegah SQL injection
$query = $conn->prepare("DELETE FROM poliklinik WHERE id_poliklinik = ?");

// Periksa kesiapan query
if (!$query) {
    http_response_code(500);
    die(json_encode(['pesan' => 'Query error: ' . $conn->error]));
}

// Bind parameter ke statement
$query->bind_param("s", $id_poli);

// Eksekusi query
$query->execute();

// Periksa keberhasilan eksekusi query
if ($query->affected_rows > 0) {
    echo json_encode(['pesan' => 'sukses']);
} else {
    echo json_encode(['pesan' => 'gagal']);
}

// Tutup koneksi dan statement
$query->close();
$conn->close();
?>
