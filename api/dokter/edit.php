<?php
include "../db_connect.php";

// Periksa ketersediaan variabel POST
$nip_dokter = $_POST['nip_dokter'];
$nama_dokter = $_POST['nama_dokter'];
$id_poliklinik = $_POST['id_poliklinik'];
$alamat = $_POST['alamat'];
$no_telepon = $_POST['no_telepon'];
$image_dokter = $_POST['foto'];

// Prepared statement untuk mengubah data dokter
$stmt = $conn->prepare("UPDATE dokter 
    SET  
    nama_dokter = ?, 
    id_poliklinik = ?, 
    alamat = ?, 
    no_telepon = ?, 
    foto = ? 
    WHERE nip_dokter = ?");

// Bind parameter ke prepared statement
$stmt->bind_param("ssssss", $nama_dokter, $id_poliklinik, $alamat, $no_telepon, $image_dokter, $nip_dokter);

// Eksekusi prepared statement
if ($stmt->execute()) {
    echo json_encode(['message' => 'Data dokter berhasil diubah']);
} else {
    echo json_encode(['message' => 'Gagal mengubah data dokter', 'error' => $conn->error]);
}

// Tutup prepared statement dan koneksi
$stmt->close();
$conn->close();
?>
