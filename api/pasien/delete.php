<?php
include "../db_connect.php";
$table_name_pasien = "pasien"; // Ganti dengan nama tabel pasien Anda

if ($_SERVER["REQUEST_METHOD"] == "DELETE") {
    $data = json_decode(file_get_contents("php://input"));

    if (!empty($data->nik)) {
        $nik = $data->nik;

        // Prepared statement untuk melakukan DELETE
        $sql = "DELETE FROM $table_name_pasien WHERE nik = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $nik);

        if ($stmt->execute()) {
            http_response_code(200);
            echo json_encode(["message" => "Data Pasien berhasil dihapus"]);
        } else {
            http_response_code(500);
            echo json_encode(["message" => "Gagal menghapus data Pasien"]);
        }
    } else {
        http_response_code(400);
        echo json_encode(["message" => "Parameter tidak lengkap"]);
    }
} else {
    http_response_code(405);
    echo json_encode(["message" => "Metode tidak diizinkan"]);
}
?>
