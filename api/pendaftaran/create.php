<?php
include "../db_connect.php";
$table_name_pendaftaran = "pendaftaran"; // Nama tabel pendaftaran
$table_name_dokter = "dokter"; // Nama tabel dokter
$table_name_poliklinik = "poliklinik"; // Nama tabel poliklinik

// Fungsi untuk mengambil data dokter
if ($_SERVER["REQUEST_METHOD"] == "GET" && isset($_GET["data"]) && $_GET["data"] === "dokter") {
    $sql = "SELECT * FROM $table_name_dokter";
    $result = $conn->query($sql);

    $data = [];

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
        echo json_encode($data);
    } else {
        echo json_encode(["message" => "Tidak ada data dokter tersedia."]);
    }
}

// Fungsi untuk mengambil data poliklinik
if ($_SERVER["REQUEST_METHOD"] == "GET" && isset($_GET["data"]) && $_GET["data"] === "poliklinik") {
    $sql = "SELECT * FROM $table_name_poliklinik";
    $result = $conn->query($sql);

    $data = [];

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
        echo json_encode($data);
    } else {
        echo json_encode(["message" => "Tidak ada data poliklinik tersedia."]);
    }
}

// Fungsi untuk menyimpan data pendaftaran
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_GET["data"]) && $_GET["data"] === "pendaftaran") {

    $nik = $_POST["nik"];
    $idPoliklinik = $_POST["id_poliklinik"];
    $nipDokter = $_POST["nip_dokter"];
    $tanggal = $_POST["tanggal"];

    $sql = "INSERT INTO $table_name_pendaftaran (nik_pasien, id_poliklinik, nip_dokter, tanggal_kunjungan)
    VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssss", $nik, $idPoliklinik, $nipDokter, $tanggal);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Data pendaftaran berhasil didaftarkan!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to add data"]);
    }

    $stmt->close();
}

$conn->close();
?>
