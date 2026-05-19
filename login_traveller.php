<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/response.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    respond(405, ['error' => 'Method not allowed']);
}

if (empty($_POST['Email']) || empty($_POST['password'])) {
    respond(400, ['error' => 'Email and password are required']);
}

$stmt = $pdo->prepare('SELECT * FROM traveler WHERE Email = ?');
$stmt->execute([$_POST['Email']]);
$row = $stmt->fetch();

if (!$row) {
    respond(401, ['error' => 'Invalid email or password']);
}

if (!password_verify($_POST['password'], $row['PasswordHash'])) {
    respond(401, ['error' => 'Invalid email or password']);
}

session_start();
$_SESSION['user_id'] = $row['TravelerID'];
$_SESSION['user_type'] = 'traveller';
$_SESSION['name'] = $row['Name'];

respond(200, [
    'message' => 'Login successful',
    'role' => 'traveller',
    'name' => $row['Name']
]);
