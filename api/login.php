<?php
include "db_connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $credential = $_POST['credential'];
    $kata_sandi = $_POST['kata_sandi'];

    // Menggunakan prepared statement untuk menghindari SQL injection
    $admin_query = "SELECT * FROM admin WHERE id = ? LIMIT 1";
    $stmt = $conn->prepare($admin_query);
    $stmt->bind_param("s", $credential);
    $stmt->execute();
    $admin_result = $stmt->get_result();
    // var_dump($admin_result);
    if ($admin_result->num_rows > 0) {
        // Login sukses sebagai admin
        $row = $admin_result->fetch_assoc();
        $storedHash = $row['kata_sandi'];
        if (!password_verify($kata_sandi, $storedHash)) {
            
            die(json_encode([
                'success' => false,
                'message' => 'ID/Nik atau kata sandi salah'
            ]));
        }

        $response = array(
            'success' => true,
            'user_type' => 'admin',
            'message' => 'Login berhasil sebagai admin',
            'id' => $row['id'],
            'name' => $row['nama_lengkap'],
            'email' => $row['email'],
        );
    } else {
        // Jika login sebagai admin gagal, coba sebagai pasien
        //ambil data pasien berdasarkan nik
        $pasien_query = "SELECT * FROM pasien WHERE nik = ? LIMIT 1";
        $stmt = $conn->prepare($pasien_query);
        $stmt->bind_param("s", $credential);
        $stmt->execute();
        $pasien_result = $stmt->get_result();
        if ($pasien_result->num_rows == 0) {
            
            die(json_encode([
                'success' => false,
                'message' => 'ID/Nik atau kata sandi salah'
            ]));
        }

        $row = $pasien_result->fetch_assoc();
        $storedHash = $row['kata_sandi'];
        if (!password_verify($kata_sandi, $storedHash)) {
            
            die(json_encode([
                'success' => false,
                'message' => 'ID/Nik atau kata sandi salah'
            ]));
        }


        /// login sukses
        $response = array(
            'success' => true,
            'user_type' => 'pasien',
            'message' => 'Login berhasil sebagai pasien',
            'id' => $row['nik'],
            'name' => $row['nama_lengkap'],
            'email' => $row['email'],
            'nomor_rekam_medis' => 'RM.' . $row['nomor_rekam_medis'],
        );
    }

    echo json_encode($response);
}

$conn->close();
