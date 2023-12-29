<?php
include "../db_connect.php";

// Periksa ketersediaan variabel POST
$nip_dokter = $_POST['nip_dokter'];
/// pastikan idpoliklinik tidak ganda
$sql = "SELECT nip_dokter FROM dokter WHERE nip_dokter = ? LIMIT 1";
$stmt = $conn->prepare($sql);
$stmt->bind_param('s', $nip_dokter);
$stmt->execute();
// Get the result
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    http_response_code(403);
    die(json_encode(['message' => 'NIP sudah terdaftar']));
}
$nama_dokter = $_POST['nama_dokter'];
$id_poliklinik = $_POST['id_poliklinik'];
$alamat = $_POST['alamat'];
$no_telepon = $_POST['no_telepon'];
$image_dokter = $_POST['foto'];
$id_admin = $_POST['id_admin'];

// Prepared statement untuk menyimpan data dokter
$stmt = $conn->prepare("INSERT INTO dokter (nip_dokter, id_admin, nama_dokter, id_poliklinik, alamat, no_telepon, foto) 
VALUES (?, ?, ?, ?, ?, ?, ?)");

// Bind parameter ke prepared statement
$stmt->bind_param("sssssss", $nip_dokter, $id_admin, $nama_dokter, $id_poliklinik, $alamat, $no_telepon, $image_dokter);

// Eksekusi prepared statement
if ($stmt->execute()) {
    echo json_encode(['message' => 'Data dokter berhasil ditambahkan']);
} else {
    echo json_encode(['message' => 'Gagal menambahkan data dokter', 'error' => $conn->error]);
}

// Tutup prepared statement dan koneksi
$stmt->close();
$conn->close();
?>
