<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/response.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    respond(405, ['error' => 'Method not allowed']);
}

if (empty($_POST['Name']) || empty($_POST['password'])) {
    respond(400, ['error' => 'Name and password are required']);
}

$stmt = $pdo->prepare('SELECT * FROM agency WHERE Name = ?');
$stmt->execute([$_POST['Name']]);
$row = $stmt->fetch();

if (!$row) {
    respond(401, ['error' => 'Invalid name or password']);
}

if (!password_verify($_POST['password'], $row['PasswordHash'])) {
    respond(401, ['error' => 'Invalid name or password']);
}

session_start();
$_SESSION['user_id'] = $row['AgencyID'];
$_SESSION['user_type'] = 'agency';
$_SESSION['name'] = $row['Name'];

respond(200, [
    'message' => 'Login successful',
    'role' => 'agency',
    'name' => $row['Name']
]);
