<?php

$targetDirectory = "pdf/"; // Specify the directory where you want to save the uploaded file
$targetFile = $targetDirectory . basename($_FILES["pdf"]["name"]);

// If everything is ok, try to upload file
if (move_uploaded_file($_FILES["pdf"]["tmp_name"], $targetFile)) {
    echo 'ok';
} else {
    echo "Sorry, there was an error uploading your file. " . error_get_last();
}
