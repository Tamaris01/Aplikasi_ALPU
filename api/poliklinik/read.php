<?php

include "../db_connect.php";

// Prepare statement untuk membaca data poliklinik
$query = "SELECT id_poliklinik, nama_poliklinik FROM poliklinik WHERE status = 1";
$stmt = $conn->prepare($query);

// Eksekusi statement
$stmt->execute();

// Dapatkan hasil kueri
$result = $stmt->get_result();

// Inisialisasi array untuk menyimpan data poliklinik
$poliklinik_arr = [];

// Periksa apakah data ditemukan
if ($result->num_rows > 0) {
    // Ambil data poliklinik dan tambahkan ke dalam array
    while ($row = $result->fetch_assoc()) {
        $poliklinik_item = [
            "id_poliklinik" => $row['id_poliklinik'],
            "nama_poliklinik" => $row['nama_poliklinik']
        ];
        $poliklinik_arr[] = $poliklinik_item;
    }

    // Kembalikan data dalam format JSON
    echo json_encode($poliklinik_arr);
} else {
    // Jika data tidak ditemukan, kirimkan respons kosong
    echo json_encode(["message" => "Data poliklinik tidak ditemukan."]);
}

// Menutup statement dan koneksi ke database
$stmt->close();
$conn->close();
?>

