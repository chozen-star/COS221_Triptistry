<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/response.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    respond(405, ['error' => 'Method not allowed']);
}

if (empty($_POST['Email']) || empty($_POST['password'])) {
    respond(400, ['error' => 'Email and password are required']);
}

$email = $_POST['Email'];

$stmt = $pdo->prepare('SELECT COUNT(*) FROM login_attempts WHERE Identifier = ? AND Success = 0 AND AttemptTime > DATE_SUB(NOW(), INTERVAL 15 MINUTE)');
$stmt->execute([$email]);
if ($stmt->fetchColumn() >= 3) {
    respond(429, ['error' => 'Too many attempts. Try again in 15 minutes.']);
}

$stmt = $pdo->prepare('SELECT * FROM traveler WHERE Email = ?');
$stmt->execute([$email]);
$row = $stmt->fetch();

if (!$row || !password_verify($_POST['password'], $row['PasswordHash'])) {
    $stmt = $pdo->prepare('INSERT INTO login_attempts (Identifier, Success) VALUES (?, 0)');
    $stmt->execute([$email]);
    respond(401, ['error' => 'Invalid email or password']);
}

$stmt = $pdo->prepare('INSERT INTO login_attempts (Identifier, Success) VALUES (?, 1)');
$stmt->execute([$email]);

session_start();
$_SESSION = [];
session_regenerate_id(true);
$_SESSION['csrf_token'] = bin2hex(random_bytes(32));
$_SESSION['user_id'] = $row['TravelerID'];
$_SESSION['user_type'] = 'traveller';
$_SESSION['name'] = $row['Name'];

respond(200, [
    'message' => 'Login successful',
    'role' => 'traveller',
    'name' => $row['Name'],
    'csrf_token' => $_SESSION['csrf_token']
]);
?>
