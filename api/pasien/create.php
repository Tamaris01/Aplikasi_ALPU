<?php
include "../db_connect.php";

$nik = $_POST['nik'];
/// pastikan idpoliklinik tidak ganda
$sql = "SELECT nik FROM pasien WHERE nik = ? LIMIT 1";
$stmt = $conn->prepare($sql);
$stmt->bind_param('s', $nik);
$stmt->execute();
// Get the result
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    http_response_code(403);
    die(json_encode(['message' => 'NIK sudah terpakai']));
}

$idAdmin = $_POST['id_admin'];
$namaLengkap = $_POST['nama_lengkap'];
$foto = $_POST['foto'];
$kataSandi = $_POST['kata_sandi'];
$email = $_POST['email'];
$noTelepon = $_POST['no_telepon'];
$alamat = $_POST['alamat'];

// Mendapatkan nomor rekam medis terbaru dari database
$sql = "SELECT COALESCE(MAX(nomor_rekam_medis), 0) + 1 AS nrm FROM pasien";
$result = $conn->query($sql);

if ($result) {
    $row = $result->fetch_assoc();
    $nomorRekamMedis = $row['nrm'];
} else {
    // Jika terdapat masalah dengan query, Anda dapat memberikan nilai default
    $nomorRekamMedis = 1;
}

// Fungsi untuk memeriksa kekuatan kata sandi
function isPasswordStrong($password) {
    $hasUppercase = preg_match('/[A-Z]/', $password);
    $hasLowercase = preg_match('/[a-z]/', $password);
    $hasDigit = preg_match('/\d/', $password);
    $hasSpecialCharacter = preg_match('/[!@#$%^&*(),.?":{}|<>]/', $password);

    return $hasUppercase && $hasLowercase && $hasDigit && $hasSpecialCharacter && strlen($password) >= 8;
}

if (!isPasswordStrong($kataSandi)) {
    http_response_code(403);
    echo json_encode(['message' => 'Kata Sandi Lemah']);
} else {
    // Hash kata sandi jika kuat sebelum menyimpannya
    $hashedPassword = password_hash($kataSandi, PASSWORD_DEFAULT);

    // Lakukan penyimpanan ke database dengan kata sandi yang telah di-hash
    $stmt = $conn->prepare("INSERT INTO pasien (
            nik,
            id_admin,
            nomor_rekam_medis,
            nama_lengkap,
            foto,
            kata_sandi,
            email,
            no_telepon,
            alamat
          ) 
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");

    $stmt->bind_param("ssissssss", $nik, $idAdmin, $nomorRekamMedis, $namaLengkap, $foto, $hashedPassword, $email, $noTelepon, $alamat);

    if ($stmt->execute()) {
        echo json_encode(['message' => 'Data pasien berhasil ditambahkan']);
    } else {
        http_response_code(403);
        echo json_encode(['message' => 'Gagal menambahkan data pasien', 'error' => $conn->error]);
    }

    $stmt->close();
}

$conn->close();
?>
