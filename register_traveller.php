<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/response.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    respond(405, ['error' => 'Method not allowed']);
}

$required = ['Name', 'Lname', 'Email', 'password', 'PhoneNumber', 'DOB'];
foreach ($required as $field) {
    if (empty($_POST[$field])) {
        respond(400, ['error' => "Missing required field: $field"]);
    }
}

$name = trim($_POST['Name'] . ' ' . $_POST['Lname']);
$email = $_POST['Email'];
$password = $_POST['password'];
$phone = $_POST['PhoneNumber'];
$dob = $_POST['DOB'];

// Check duplicate email
$stmt = $pdo->prepare('SELECT TravelerID FROM traveler WHERE Email = ?');
$stmt->execute([$email]);
if ($stmt->fetch()) {
    respond(409, ['error' => 'Email already registered']);
}

// Check duplicate phone
$stmt = $pdo->prepare('SELECT TravelerID FROM traveler WHERE PhoneNumber = ?');
$stmt->execute([$phone]);
if ($stmt->fetch()) {
    respond(409, ['error' => 'Phone number already registered']);
}
$hash = password_hash($password, PASSWORD_BCRYPT);

$stmt = $pdo->prepare(
    'INSERT INTO traveler (Name, Email, PhoneNumber, PasswordHash, DateOfBirth, CreatedAt)
     VALUES (?, ?, ?, ?, ?, CURDATE())'
);
$stmt->execute([$name, $email, $phone, $hash, $dob]);

respond(201, ['message' => 'Traveller registered successfully']);
?>