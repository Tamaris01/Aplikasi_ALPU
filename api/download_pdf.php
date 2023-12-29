<?php
 // Replace with the actual path to your file
$file_name = isset($_REQUEST['file_name']) ? $_REQUEST['file_name'] : '';
if($file_name==''){
    die('Invalid request');
}   // Replace with the desired name for the downloaded file
$file_path = "pdf/".$file_name;

// Check if the file exists
if (file_exists($file_path)) {
    $absolute_path = realpath($file_path);
    // Set the appropriate headers for a download
    header('Content-Description: File Transfer');
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename="' . $file_name . '"');
    header('Expires: 0');
    header('Cache-Control: must-revalidate');
    header('Pragma: public');
    header('Content-Length: ' . filesize($absolute_path));

    // Read the file and output it to the browser
    readfile($absolute_path);
    exit;
} else {
    // File not found
    die('File not found');
}
?>