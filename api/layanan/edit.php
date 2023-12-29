<?php
include "../db_connect.php";

include "../db_connect.php";

$id_poli = $_POST["id_poliklinik"];
$nama_poli = $_POST["nama_poliklinik"];
$detail = $_POST["detail"];
$idAdmin = $_POST['id_admin'];

$updateImageRS = "";
$updateImageLogo = "";

// Check if a new image for RS is provided
if (!empty($_FILES['foto_rs']['name'])) {
    $image_rs = $_FILES['foto_rs']['name'];
    $imagePath_rs = "images/" . $image_rs;
    move_uploaded_file($_FILES['foto_rs']['tmp_name'], $imagePath_rs);
    $updateImageRS = ", foto_rs=?";
}

// Check if a new image for Logo is provided
if (!empty($_FILES['foto_logo']['name'])) {
    $image_logo = $_FILES['foto_logo']['name'];
    $imagePath_logo = "images/" . $image_logo;
    move_uploaded_file($_FILES['foto_logo']['tmp_name'], $imagePath_logo);
    $updateImageLogo = ", foto_logo=?";
}

// Prepare statement with conditional updates for images
$query = "UPDATE poliklinik SET id_admin=?, id_poliklinik=?, nama_poliklinik=?, detail=? $updateImageRS $updateImageLogo WHERE id_poliklinik = ?";
$stmt = $conn->prepare($query);

if (!$stmt) {
    http_response_code(500);
    die(json_encode(['pesan' => 'Query error: ' . $conn->error]));
}

// Bind parameters to the statement
if (!empty($updateImageRS) && !empty($updateImageLogo)) {
    $stmt->bind_param("sssss", $idAdmin, $id_poli, $nama_poli, $detail, $image_rs, $image_logo, $id_poli);
} elseif (!empty($updateImageRS)) {
    $stmt->bind_param("sssss", $idAdmin, $id_poli, $nama_poli, $detail, $image_rs, $id_poli);
} elseif (!empty($updateImageLogo)) {
    $stmt->bind_param("sssss", $idAdmin, $id_poli, $nama_poli, $detail, $image_logo, $id_poli);
} else {
    $stmt->bind_param("ssss", $idAdmin, $id_poli, $nama_poli, $detail, $id_poli);
}

// Execute the statement
$stmt->execute();

// Check for successful update
if ($stmt->affected_rows > 0) {
    echo json_encode(['pesan' => 'sukses']);
} else {
    echo json_encode(['pesan' => 'gagal', 'error' => $conn->error]);
}

// Close statement and connection
$stmt->close();
$conn->close();
?>
