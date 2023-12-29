<?php
include "db_connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $credential = $_POST['credential'];
    $newPassword = $_POST['new_password'];

    if (is_numeric($credential)) {
        // Jika credential adalah NIK (pasien)
        $query = "UPDATE pasien SET kata_sandi = ? WHERE nik = ?";
    } else {
        // Jika credential adalah ID (admin)
        $query = "UPDATE admin SET kata_sandi = ? WHERE id = ?";
    }

    $hashedNewPassword = password_hash($newPassword, PASSWORD_DEFAULT);
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ss", $hashedNewPassword, $credential);
    $stmt->execute();

    if ($stmt->affected_rows > 0) {
        echo json_encode(array('success' => true));
    } else {
        echo json_encode(array('success' => false));
    }
}
?>
