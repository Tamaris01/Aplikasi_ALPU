<?php
include "../db_connect.php";


// Periksa ketersediaan variabel POST
if (!isset($_POST['id_admin'])) {
    http_response_code(403);
    die(json_encode(['pesan' => 'Id admin is mandatory']));
}

$id_poli = $_POST['id_poliklinik'];
/// pastikan idpoliklinik tidak ganda
$sql = "SELECT id_poliklinik FROM poliklinik WHERE id_poliklinik = ? LIMIT 1";
$stmt = $conn->prepare($sql);
$stmt->bind_param('s', $id_poli);
$stmt->execute();
// Get the result
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    http_response_code(200);
    die(json_encode(['pesan' => 'ID poliklinik sudah terpakai']));
}

$idAdmin = $_POST['id_admin'];
$nama_poli = $_POST['nama_poliklinik'];
$detail = $_POST['detail'];
$image_rs = $_FILES['foto_rs']['name'];
$imagePath_rs = "images/" . $image_rs;
move_uploaded_file($_FILES['foto_rs']['tmp_name'], $imagePath_rs);

$image_logo = $_FILES['foto_logo']['name'];
$imagePath_logo = "images/" . $image_logo;
move_uploaded_file($_FILES['foto_logo']['tmp_name'], $imagePath_logo);


// Perbaiki struktur kueri SQL
$data = mysqli_query($conn, "INSERT INTO poliklinik (id_poliklinik, nama_poliklinik, detail, foto_rs, foto_logo, id_admin) VALUES ('" . $id_poli . "', '" . $nama_poli . "', '" . $detail . "', '" . $image_rs . "','" . $image_logo . "', '" . $idAdmin . "')");

// Perbaiki respons JSON
if ($data) {
    echo json_encode(['pesan' => 'sukses']);
} else {
    echo json_encode(['pesan' => 'gagal', 'error' => mysqli_error($conn)]);
}

$conn->close();
