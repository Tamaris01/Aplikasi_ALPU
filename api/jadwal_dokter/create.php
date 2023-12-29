<?php
include "../db_connect.php";
$data = json_decode(file_get_contents("php://input"));

if (!isset($data->id_admin)) {
    http_response_code(403);
    die(json_encode(["status" => "error", "message" => "admin id is mandatory"]));
}

if (
    !empty($data->nip_dokter) &&
    !empty($data->id_poliklinik) &&
    !empty($data->jam_mulai) &&
    !empty($data->jam_selesai) &&
    !empty($data->hari) &&
    !empty($data->tanggal)
) {
    $nip_dokter = $data->nip_dokter;
    $id_poliklinik = $data->id_poliklinik;
    $jam_mulai = $data->jam_mulai;
    $jam_selesai = $data->jam_selesai;
    $hari = $data->hari;
    $tanggal = $data->tanggal;
    $idAdmin = $data->id_admin;

    // Prepared statement untuk mencegah SQL injection
    $query = "INSERT INTO jadwal_dokter (nip_dokter, id_poliklinik, jam_mulai, jam_selesai, hari, tanggal, id_admin) 
              VALUES (?, ?, ?, ?, ?, ?, ?)";

    $stmt = $conn->prepare($query);
    $stmt->bind_param("sssssss", $nip_dokter, $id_poliklinik, $jam_mulai, $jam_selesai, $hari, $tanggal, $idAdmin);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Data added successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to add data"]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Incomplete data"]);
}

$conn->close();
