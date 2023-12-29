<?php
include "../db_connect.php";
$id_pendaftaran = $_POST["id_pendaftaran"];
$status = $_POST["status"];
$id_admin = $_POST["id_admin"];


$allowed_statuses = ["belum_dikonfirmasi", "hadir", "tidak_hadir"];
if (!in_array($status, $allowed_statuses)) {
    echo json_encode(['pesan' => 'gagal', 'error' => 'Nilai status tidak valid']);
    exit;
}

$stmt = $conn->prepare("UPDATE pendaftaran SET status=?, id_admin=? WHERE id_pendaftaran = ?");
$stmt->bind_param("ssi", $status, $id_admin, $id_pendaftaran);

$stmt->execute();
$stmt->close();

echo json_encode(['pesan' => 'sukses']);


$conn->close();
