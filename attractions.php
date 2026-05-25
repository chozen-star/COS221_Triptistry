<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/response.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    respond(405, ['error' => 'Method not allowed']);
}

if (isset($_GET['id'])) {
    if (!is_numeric($_GET['id'])) {
        respond(400, ['error' => 'Invalid ID']);
    }
    $stmt = $pdo->prepare('SELECT * FROM touristattraction WHERE AttractionID = ?');
    $stmt->execute([(int)$_GET['id']]);
    $row = $stmt->fetch();
    if (!$row) {
        respond(404, ['error' => 'Attraction not found']);
    }
    respond(200, $row);
}

if (!empty($_GET['type'])) {
    $stmt = $pdo->prepare('SELECT * FROM touristattraction WHERE Type = ? ORDER BY Name');
    $stmt->execute([$_GET['type']]);
    respond(200, $stmt->fetchAll());
}

$stmt = $pdo->query('SELECT * FROM touristattraction ORDER BY Name');
respond(200, $stmt->fetchAll());
