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
    $stmt = $pdo->prepare(
        'SELECT d.*, COUNT(r.RestaurantID) AS RestaurantCount
         FROM destination d
         LEFT JOIN restaurant r ON r.DestinationID = d.DestinationID
         WHERE d.DestinationID = ?
         GROUP BY d.DestinationID'
    );
    $stmt->execute([(int)$_GET['id']]);
    $row = $stmt->fetch();
    if (!$row) {
        respond(404, ['error' => 'Destination not found']);
    }
    respond(200, $row);
}

if (isset($_GET['country'])) {
    $stmt = $pdo->prepare(
        'SELECT d.*, COUNT(r.RestaurantID) AS RestaurantCount
         FROM destination d
         LEFT JOIN restaurant r ON r.DestinationID = d.DestinationID
         WHERE d.Country = ?
         GROUP BY d.DestinationID
         ORDER BY d.Name'
    );
    $stmt->execute([$_GET['country']]);
    $rows = $stmt->fetchAll();
    respond(200, $rows);
}

$stmt = $pdo->query(
    'SELECT d.*, COUNT(r.RestaurantID) AS RestaurantCount
     FROM destination d
     LEFT JOIN restaurant r ON r.DestinationID = d.DestinationID
     GROUP BY d.DestinationID
     ORDER BY d.Name'
);
respond(200, $stmt->fetchAll());
