<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/response.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    respond(405, ['error' => 'Method not allowed']);
}

$required = ['Name', 'Website', 'Type', 'password'];
foreach ($required as $field) {
    if (empty($_POST[$field])) {
        respond(400, ['error' => "Missing required field: $field"]);
    }
}

$allowedTypes = ['Full Service', 'Boutique', 'OTA'];
if (!in_array($_POST['Type'], $allowedTypes)) {
    respond(400, ['error' => 'Type must be one of: Full Service, Boutique, OTA']);
}

$stmt = $pdo->prepare('SELECT AgencyID FROM agency WHERE Name = ?');
$stmt->execute([$_POST['Name']]);
if ($stmt->fetch()) {
    respond(409, ['error' => 'Agency name already registered']);
}

$hash = password_hash($_POST['password'], PASSWORD_BCRYPT);

$stmt = $pdo->prepare(
    'INSERT INTO agency (Name, Website, Type, Rating, PasswordHash, CreatedAt) VALUES (?, ?, ?, NULL, ?, CURDATE())'
);
$stmt->execute([$_POST['Name'], $_POST['Website'], $_POST['Type'], $hash]);

respond(201, ['message' => 'Agency registered']);
