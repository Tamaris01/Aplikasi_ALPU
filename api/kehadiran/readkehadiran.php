<?php
include "../db_connect.php";

// Ganti "id_poliklinik" dengan nama kolom yang sesuai pada tabel pendaftaran
$id_poliklinik = $_GET['id_poliklinik'] ?? '';

// Mendapatkan tanggal hari ini dalam format yang sesuai dengan format tanggal pada database (misal: yyyy-mm-dd)
$currentDate = date("Y-m-d");

// Gunakan prepared statement untuk mencegah SQL injection
$query = $conn->prepare("SELECT 
        pasien.foto, 
        pasien.nama_lengkap AS nama_lengkap_pasien, 
        dokter.nama_dokter AS nama_lengkap_dokter,
        pasien.nik,
        pendaftaran.id_pendaftaran
    FROM 
        pendaftaran
    JOIN 
        pasien ON pendaftaran.nik_pasien = pasien.nik
    JOIN 
        dokter ON pendaftaran.nip_dokter = dokter.nip_dokter
    WHERE 
        pendaftaran.id_poliklinik = ? AND 
        pendaftaran.tanggal_kunjungan = ? AND 
        pendaftaran.status = 'belum_dikonfirmasi' 
");

// Periksa kesiapan query
if (!$query) {
    die("Query gagal: " . $conn->error);
}

// Bind parameter ke statement
$query->bind_param("ss", $id_poliklinik, $currentDate);

// Eksekusi query
$query->execute();

// Ambil hasil query
$result = $query->get_result();
$data = $result->fetch_all(MYSQLI_ASSOC);

// Periksa jumlah hasil
if (count($data) > 0) {
    // Mengonversi data menjadi format JSON
    $json_data = json_encode($data);

    // Mengirim data ke klien
    header('Content-Type: application/json');
    echo $json_data;
} else {
    echo "Data pendaftaran hari ini tidak ada";
}

// Tutup koneksi
$conn->close();
?>
