<?php
require_once __DIR__ . '/response.php';

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

if (isset($_SESSION['user_id'])) {
    respond(200, [
        'user_id' => $_SESSION['user_id'],
        'user_type' => $_SESSION['user_type'],
        'name' => $_SESSION['name'] ?? null
    ]);
} else {
    respond(401, ['error' => 'Not logged in']);
}
