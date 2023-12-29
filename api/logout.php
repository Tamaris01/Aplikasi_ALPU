<?php

// Contoh sederhana menghapus session
session_start();
session_destroy();

// Respon ke aplikasi klien (Flutter) dengan status 200 jika logout berhasil
http_response_code(200);

// Pesan notifikasi untuk dikirim ke aplikasi Flutter
$response = array("message" => "Berhasil Keluar");

// Mengirimkan pesan notifikasi sebagai respons JSON
echo json_encode($response);
?>
