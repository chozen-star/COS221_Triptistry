<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/response.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    respond(405, ['error' => 'Method not allowed']);
}

if (empty($_POST['Name']) || empty($_POST['password'])) {
    respond(400, ['error' => 'Name and password are required']);
}

$name = $_POST['Name'];

$stmt = $pdo->prepare('SELECT COUNT(*) FROM login_attempts WHERE Identifier = ? AND Success = 0 AND AttemptTime > DATE_SUB(NOW(), INTERVAL 15 MINUTE)');
$stmt->execute([$name]);
if ($stmt->fetchColumn() >= 3) {
    respond(429, ['error' => 'Too many attempts. Try again in 15 minutes.']);
}

$stmt = $pdo->prepare('SELECT * FROM agency WHERE Name = ?');
$stmt->execute([$name]);
$row = $stmt->fetch();

if (!$row || !password_verify($_POST['password'], $row['PasswordHash'])) {
    $stmt = $pdo->prepare('INSERT INTO login_attempts (Identifier, Success) VALUES (?, 0)');
    $stmt->execute([$name]);
    respond(401, ['error' => 'Invalid name or password']);
}

$stmt = $pdo->prepare('INSERT INTO login_attempts (Identifier, Success) VALUES (?, 1)');
$stmt->execute([$name]);

session_start();
$_SESSION = [];
session_regenerate_id(true);
$_SESSION['csrf_token'] = bin2hex(random_bytes(32));
$_SESSION['user_id'] = $row['AgencyID'];
$_SESSION['user_type'] = 'agency';
$_SESSION['name'] = $row['Name'];

respond(200, [
    'message' => 'Login successful',
    'role' => 'agency',
    'name' => $row['Name'],
    'csrf_token' => $_SESSION['csrf_token']
]);
?>