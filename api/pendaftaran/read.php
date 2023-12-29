<?php
include "../db_connect.php";
$nikPasien =  isset($_REQUEST['nik_pasien']) ? $_REQUEST['nik_pasien'] : '';
$query = "SELECT b.nama_dokter, c.nama_lengkap as nama_pasien, d.nama_poliklinik, a.*";
$query .= " FROM pendaftaran a";
$query .= " LEFT JOIN dokter b ON a.nip_dokter = b.nip_dokter";
$query .= " LEFT JOIN pasien c ON a.nik_pasien = c.nik";
$query .= " LEFT JOIN poliklinik d ON a.id_poliklinik = d.id_poliklinik";
$query .= " WHERE nik_pasien = ?";
$query .= " ORDER BY a.id_pendaftaran DESC LIMIT 1000";
$stmt = $conn->prepare($query);
$stmt->bind_param("s", $nikPasien);
$stmt->execute();
$stmt->bind_result($namaDokter, $namaPasien, $namaPoliklinik, $idPendaftaran, $nikPasien, $idPoliklinik, $nipDokter, $tanggalKunjungan, $status, $idAdmin);

$data = array();

while ($stmt->fetch()) {
    $row = [
        'nama_dokter' => $namaDokter,
        'nama_pasien' => $namaPasien,
        'id_pendaftaran' => $idPendaftaran,
        'nik_pasien' => $nikPasien,
        'id_poliklinik' => $idPoliklinik,
        'nama_poliklinik'=> $namaPoliklinik,
        'nip_dokter' => $nipDokter,
        'tanggal_kunjungan' => $tanggalKunjungan,
        'status' => $status,
        'id_admin' => $idAdmin,
    ];
    array_push($data, $row);
}


if (empty($data)) {
    $response = array("status" => "error", "message" => "No data found");
    echo json_encode($response);
} else {
    echo json_encode(['data' => $data, 'status' => 'success', 'message' => 'Berhasil']);
}

$stmt->close();
$conn->close();
