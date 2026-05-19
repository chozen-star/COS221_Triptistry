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
        'SELECT f.*, a.Name AS AirlineName, a.Country AS AirlineCountry
         FROM flight f
         LEFT JOIN airline a ON a.AirlineID = f.AirlineID
         WHERE f.FlightID = ?'
    );
    $stmt->execute([(int)$_GET['id']]);
    $row = $stmt->fetch();
    if (!$row) {
        respond(404, ['error' => 'Flight not found']);
    }
    respond(200, $row);
}

$sql = 'SELECT f.*, a.Name AS AirlineName, a.Country AS AirlineCountry
        FROM flight f
        LEFT JOIN airline a ON a.AirlineID = f.AirlineID';
$conditions = [];
$params = [];

if (!empty($_GET['origin'])) {
    $conditions[] = 'f.Origin = ?';
    $params[] = $_GET['origin'];
}
if (!empty($_GET['destination'])) {
    $conditions[] = 'f.Destination = ?';
    $params[] = $_GET['destination'];
}
if (!empty($_GET['airline_id'])) {
    if (!is_numeric($_GET['airline_id'])) {
        respond(400, ['error' => 'Invalid airline_id']);
    }
    $conditions[] = 'f.AirlineID = ?';
    $params[] = (int)$_GET['airline_id'];
}

if ($conditions) {
    $sql .= ' WHERE ' . implode(' AND ', $conditions);
}
$sql .= ' ORDER BY f.DepartureTime';

$stmt = $pdo->prepare($sql);
$stmt->execute($params);
respond(200, $stmt->fetchAll());
