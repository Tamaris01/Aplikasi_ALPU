<?php
include "../db_connect.php";

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->id)) {
    $id = $data->id;

    // Prepared statement untuk memeriksa keberadaan id sebelum menghapus
    $checkQuery = "SELECT COUNT(*) AS count FROM jadwal_dokter WHERE id = ?";
    $checkStmt = $conn->prepare($checkQuery);
    $checkStmt->bind_param("i", $id);
    $checkStmt->execute();
    $result = $checkStmt->get_result();
    $row = $result->fetch_assoc();

    if ($row['count'] > 0) {
        // Hapus data jika id ada dalam database
        $deleteQuery = "DELETE FROM jadwal_dokter WHERE id = ?";
        $deleteStmt = $conn->prepare($deleteQuery);
        $deleteStmt->bind_param("i", $id);

        if ($deleteStmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Data Jadwal berhasil dihapus"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Data Jadwal tidak berhasil dihapus"]);
        }

        $deleteStmt->close();
    } else {
        echo json_encode(["status" => "error", "message" => "ID tidak ditemukan"]);
    }

    $checkStmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Incomplete data"]);
}

$conn->close();
?>
