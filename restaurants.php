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
        'SELECT r.*, GROUP_CONCAT(DISTINCT rc.CuisineType) AS CuisineTypes,
                GROUP_CONCAT(DISTINCT rl.Location) AS Locations
         FROM restaurant r
         LEFT JOIN restaurant_cuisinetype rc ON rc.RestaurantID = r.RestaurantID
         LEFT JOIN restaurant_location rl ON rl.RestaurantID = r.RestaurantID
         WHERE r.RestaurantID = ?
         GROUP BY r.RestaurantID'
    );
    $stmt->execute([(int)$_GET['id']]);
    $row = $stmt->fetch();
    if (!$row) {
        respond(404, ['error' => 'Restaurant not found']);
    }
    respond(200, $row);
}

$sql = 'SELECT r.*, GROUP_CONCAT(DISTINCT rc.CuisineType) AS CuisineTypes,
                GROUP_CONCAT(DISTINCT rl.Location) AS Locations
         FROM restaurant r
         LEFT JOIN restaurant_cuisinetype rc ON rc.RestaurantID = r.RestaurantID
         LEFT JOIN restaurant_location rl ON rl.RestaurantID = r.RestaurantID';
$conditions = [];
$params = [];

if (!empty($_GET['destination_id'])) {
    if (!is_numeric($_GET['destination_id'])) {
        respond(400, ['error' => 'Invalid destination_id']);
    }
    $conditions[] = 'r.DestinationID = ?';
    $params[] = (int)$_GET['destination_id'];
}

if (!empty($_GET['cuisine'])) {
    $sql .= ' JOIN restaurant_cuisinetype rc2 ON rc2.RestaurantID = r.RestaurantID';
    $conditions[] = 'rc2.CuisineType = ?';
    $params[] = $_GET['cuisine'];
}

if ($conditions) {
    $sql .= ' WHERE ' . implode(' AND ', $conditions);
}
$sql .= ' GROUP BY r.RestaurantID';

$stmt = $pdo->prepare($sql);
$stmt->execute($params);
respond(200, $stmt->fetchAll());
