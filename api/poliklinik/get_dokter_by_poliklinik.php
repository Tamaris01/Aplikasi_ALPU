<?php
include "../db_connect.php";

// Ambil id_poliklinik dari input POST
$idPoliklinik = json_decode(file_get_contents("php://input"), true)['id_poliklinik'];

// Query untuk mendapatkan data dokter berdasarkan id_poliklinik
$sql = "SELECT d.nip_dokter, d.nama_dokter FROM dokter d
        INNER JOIN poliklinik p ON d.id_poliklinik = p.id_poliklinik
        WHERE p.id_poliklinik = ? AND d.status = 1";

// Gunakan prepared statement
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $idPoliklinik);
$stmt->execute();
$result = $stmt->get_result();

if (!$result) {
    $response = array("status" => "error", "message" => "Query error: " . $conn->error);
    echo json_encode($response);
    die();
}

$dokterData = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $dokterData[] = [
            'nip_dokter' => $row['nip_dokter'],
            'nama_dokter' => $row['nama_dokter'],
        ];
    }
} else {
    $response = array("status" => "info", "message" => "No doctors found for the specified polyclinic.");
    echo json_encode($response);
    die();
}

$stmt->close();
$conn->close();

echo json_encode($dokterData);
?>
