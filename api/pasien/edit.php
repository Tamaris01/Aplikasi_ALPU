<?php
include "../db_connect.php";

$nik = $_POST['nik'];
$idAdmin = $_POST['id_admin'];
// $nomorRekamMedis = $_POST['nomor_rekam_medis'];
$namaLengkap = $_POST['nama_lengkap'];
$foto = $_POST['foto'];
$email = $_POST['email'];
$noTelepon = $_POST['no_telepon'];
$alamat = $_POST['alamat'];

$stmt = $conn->prepare("UPDATE pasien 
                        SET id_admin = ?, nama_lengkap = ?, 
                            foto = ?, email = ?, no_telepon = ?, alamat = ?
                        WHERE nik = ?");
// Bind parameter ke statement SQL
$stmt->bind_param("sssssss", $idAdmin, $namaLengkap, $foto, $email, $noTelepon, $alamat, $nik);

if ($stmt->execute()) {
    echo json_encode(['message' => 'Data pasien berhasil diperbarui']);
} else {
    http_response_code(403);
    echo json_encode(['message' => 'Gagal memperbarui data pasien', 'error' => $conn->error]);
}

$stmt->close();
$conn->close();
?>
