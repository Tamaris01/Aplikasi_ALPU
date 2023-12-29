<?php

include '../db_connect.php';
$id = isset($_REQUEST['id']) ? $_REQUEST['id'] : '';
$type = isset($_REQUEST['user_type']) ? $_REQUEST['user_type'] : '';

if ($id == '' || $type == '') {
    http_response_code(403);
    die(json_encode(['message' => 'Bad request']));
}

if ($type == 'pasien') {
    $sql = "SELECT * FROM pasien WHERE nik = ? LIMIT 1";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('s', $id);
    $stmt->execute();
    // Get the result
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $row['foto'] = "" . $row['foto'];
        $row['nomor_rekam_medis'] = 'RM.' . $row['nomor_rekam_medis'];

        $response = array(
            'success' => true,
            'user_type' => 'pasien',
            'message' => 'Login berhasil sebagai admin',
            'id' => $row['nik'],
            'name' => $row['nama_lengkap'],
            'email' => $row['email'],
            'foto' => $row['foto'],
            'alamat' => $row['alamat'],
            'hp' => $row['no_telepon'],
        );
        die(json_encode($response));
    } else {
        echo json_encode(array('message' => 'No Patients found.'));
    }
} else if ($type == 'admin') {
    $admin_query = "SELECT * FROM admin WHERE id = ? LIMIT 1";
    $stmt = $conn->prepare($admin_query);
    $stmt->bind_param("s", $id);
    $stmt->execute();
    $admin_result = $stmt->get_result();
    // var_dump($admin_result);
    if ($admin_result->num_rows > 0) {
        // Login sukses sebagai admin
        $row = $admin_result->fetch_assoc();

        $response = array(
            'success' => true,
            'user_type' => 'admin',
            'message' => 'Login berhasil sebagai admin',
            'id' => $row['id'],
            'name' => $row['nama_lengkap'],
            'email' => $row['email'],
            'foto' => $row['foto'],
            'alamat' => $row['alamat'],
            'hp' => $row['nomor_telepon'],
        );
        die(json_encode($response));
    } else {
        echo json_encode(array('message' => 'Not found.'));
    }
} else {
    http_response_code(403);
    die(json_encode(['message' => 'Bad request']));
}
