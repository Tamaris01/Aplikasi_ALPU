<?php

include '../db_connect.php';

$id = isset($_REQUEST['id']) ? $_REQUEST['id'] : '';
$name = isset($_REQUEST['name']) ? $_REQUEST['name'] : '';
$sandi = isset($_REQUEST['sandi']) ? $_REQUEST['sandi'] : '';
$email = isset($_REQUEST['email']) ? $_REQUEST['email'] : '';
$hp = isset($_REQUEST['hp']) ? $_REQUEST['hp'] : '';
$alamat = isset($_REQUEST['alamat']) ? $_REQUEST['alamat'] : '';
$role = isset($_REQUEST['role']) ? $_REQUEST['role'] : '';
$foto = isset($_REQUEST['foto']) ? $_REQUEST['foto'] : '';

if ($id == '' || $role == '' || $name == '') {
    http_response_code(403);
    die();
}

if ($role == 'pasien') {
    // update data pasien
    $sql = "UPDATE pasien SET nama_lengkap=?, email=?, no_telepon=?, alamat=?,foto=?";
    $sql .= " WHERE nik=?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('ssssss', $name, $email, $hp, $alamat, $foto, $id);
    if (!$stmt->execute()) {
        http_response_code(501);
        die($stmt->error);
    }
    if ($sandi == '') {
        http_response_code(200);
        die('Data successfully updated');
    }
    $hashedPassword = password_hash($sandi, PASSWORD_DEFAULT);
    $sql = "UPDATE pasien SET kata_sandi=?";
    $sql .= " WHERE nik=?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('ss', $hashedPassword, $id);
    $stmt->execute();
    http_response_code(200);
    die('Data successfully updated');
} elseif ($role == 'admin') {
    // update data pasien
    $sql = "UPDATE admin SET nama_lengkap=?, email=?, nomor_telepon=?, alamat=?,foto=?";
    $sql .= " WHERE id=?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('ssssss', $name, $email, $hp, $alamat, $foto, $id);
    if (!$stmt->execute()) {
        http_response_code(501);
        die($stmt->error);
    }
    if ($sandi == '') {
        http_response_code(200);
        die('Data successfully updated');
    }
    $hashedPassword = password_hash($sandi, PASSWORD_DEFAULT);
    $sql = "UPDATE admin SET kata_sandi=?";
    $sql .= " WHERE id=?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('ss', $hashedPassword, $id);
    $stmt->execute();
    http_response_code(200);
    die('Data successfully updated');
}

http_response_code(403);
die('bad request');