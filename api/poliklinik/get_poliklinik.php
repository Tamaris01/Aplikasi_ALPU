<?php
include "../db_connect.php";

$query = "SELECT * FROM poliklinik WHERE status = 1";
$result = $conn->query($query);

if ($result->num_rows > 0) {
    $poliklinik_array = array();

    while ($row = $result->fetch_assoc()) {
        $poliklinik_item = array(
            "id_poliklinik" => $row["id_poliklinik"],
            "nama_poliklinik" => $row["nama_poliklinik"],
        );

        array_push($poliklinik_array, $poliklinik_item);
    }

    echo json_encode($poliklinik_array);
} else {
    echo json_encode(["status" => "error", "message" => "No poliklinik found"]);
}

$conn->close();
?>
