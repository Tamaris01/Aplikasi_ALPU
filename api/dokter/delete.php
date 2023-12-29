<?php
include "../db_connect.php";

// Get data from request
$data = json_decode(file_get_contents("php://input"));

if (isset($data->nip)) {
    $nip = $data->nip;

    // Prepare statement to check if NIP exists
    $checkQuery = "SELECT COUNT(*) AS count FROM dokter WHERE nip_dokter=?";
    $checkStmt = $conn->prepare($checkQuery);
    $checkStmt->bind_param("s", $nip);
    $checkStmt->execute();
    $result = $checkStmt->get_result();
    $row = $result->fetch_assoc();

    if ($row['count'] > 0) {
        // If NIP exists, proceed to delete
        $deleteStmt = $conn->prepare("DELETE FROM dokter WHERE nip_dokter=?");
        $deleteStmt->bind_param("s", $nip);

        if ($deleteStmt->execute()) {
            if ($deleteStmt->affected_rows > 0) {
                echo json_encode(array("message" => "Dokter deleted successfully"));
            } else {
                echo json_encode(array("message" => "No dokter found with given NIP"));
            }
        } else {
            echo json_encode(array("message" => "Failed to delete dokter"));
        }

        $deleteStmt->close();
    } else {
        echo json_encode(array("message" => "No dokter found with given NIP"));
    }

    $checkStmt->close();
} else {
    echo json_encode(array("message" => "Invalid request. NIP is required."));
}

$conn->close();
?>
