<?php
include "../db_connect.php";
$data = json_decode(file_get_contents("php://input"));

if (
    !empty($data->id) &&
    !empty($data->nip_dokter) &&
    !empty($data->id_poliklinik) &&
    !empty($data->jam_mulai) &&
    !empty($data->jam_selesai) &&
    !empty($data->hari) &&
    !empty($data->tanggal)
) {
    $id = $data->id;
    $nip_dokter = $data->nip_dokter;
    $id_poliklinik = $data->id_poliklinik;
    $jam_mulai = $data->jam_mulai;
    $jam_selesai = $data->jam_selesai;
    $hari = $data->hari;
    $tanggal = $data->tanggal;
    $idAdmin = isset($data->id_admin) ? $data->id_admin : '';

    // Prepared statement untuk mencegah SQL injection
    $query = "UPDATE jadwal_dokter 
              SET nip_dokter = ?, id_poliklinik = ?, jam_mulai = ?, jam_selesai = ?, hari = ?, tanggal = ?, id_admin = ? 
              WHERE id = ?";

    $stmt = $conn->prepare($query);
    $stmt->bind_param("sssssssi", $nip_dokter, $id_poliklinik, $jam_mulai, $jam_selesai, $hari, $tanggal, $idAdmin, $id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Data updated successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to update data"]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Incomplete data"]);
}

$conn->close();
?>
