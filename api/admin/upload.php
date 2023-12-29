<?php

$targetDirectory = "images/"; // Specify the directory where you want to save the uploaded file
$targetFile = $targetDirectory . basename($_FILES["image"]["name"]);
$uploadOk = 1;
$imageFileType = strtolower(pathinfo($targetFile, PATHINFO_EXTENSION));

// Check if the file is an actual image
if (isset($_POST["submit"])) {
    $check = getimagesize($_FILES["image"]["tmp_name"]);
    if ($check !== false) {
        echo "File is an image - " . $check["mime"] . ".";
        $uploadOk = 1;
    } else {
        echo "File is not an image.";
        $uploadOk = 0;
    }
}

// Check if the file already exists
if (file_exists($targetFile)) {
    die( "The file " . basename($_FILES["image"]["name"]) . " has been uploaded.");
    $uploadOk = 0;
}

// Check file size (optional)
// if ($_FILES["image"]["size"] > 1000000) {
//     echo "Sorry, your file is too large.";
//     $uploadOk = 0;
// }

// Allow certain file formats
// $allowedFormats = ["jpg", "jpeg", "png", "gif"];
// if (!in_array($imageFileType, $allowedFormats)) {
//     echo "Sorry, only JPG, JPEG, PNG, and GIF files are allowed.";
//     $uploadOk = 0;
// }
// // echo $targetFile;
// Check if $uploadOk is set to 0 by an error
if ($uploadOk == 0) {
    echo "";
} else {
    // If everything is ok, try to upload file
    if (move_uploaded_file($_FILES["image"]["tmp_name"], $targetFile)) {
        echo "The file " . basename($_FILES["image"]["name"]) . " has been uploaded.";
    } else {
        echo "Sorry, there was an error uploading your file. ". error_get_last();
    }
}
