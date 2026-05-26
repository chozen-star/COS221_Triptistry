<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/response.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    respond(405, ['error' => 'Method not allowed']);
}

$baseSelect = 'SELECT a.AccommodationID, a.Location, a.Price, a.DestinationID,
    d.Name AS DestinationName, d.Country AS DestinationCountry,
    CASE WHEN h.AccommodationID IS NOT NULL THEN \'Hotel\'
         WHEN r.AccommodationID IS NOT NULL THEN \'Resort\'
         WHEN ap.AccommodationID IS NOT NULL THEN \'Apartment\'
         ELSE NULL
    END AS AccommodationType
    FROM accommodation a
    LEFT JOIN destination d ON d.DestinationID = a.DestinationID
    LEFT JOIN hotel h ON h.AccommodationID = a.AccommodationID
    LEFT JOIN resort r ON r.AccommodationID = a.AccommodationID
    LEFT JOIN apartment ap ON ap.AccommodationID = a.AccommodationID';

if (isset($_GET['id'])) {
    if (!is_numeric($_GET['id'])) {
        respond(400, ['error' => 'Invalid ID']);
    }
    $id = (int)$_GET['id'];

    $stmt = $pdo->prepare($baseSelect . ' WHERE a.AccommodationID = ?');
    $stmt->execute([$id]);
    $row = $stmt->fetch();

    if (!$row) {
        respond(404, ['error' => 'Accommodation not found']);
    }

    $type = $row['AccommodationType'];
    if ($type === 'Hotel') {
        $stmt = $pdo->prepare('SELECT BedType, Stars FROM hotel WHERE AccommodationID = ?');
        $stmt->execute([$id]);
        $row['details'] = $stmt->fetch() ?: [];
    } elseif ($type === 'Resort') {
        $stmt = $pdo->prepare('SELECT ResortType FROM resort WHERE AccommodationID = ?');
        $stmt->execute([$id]);
        $row['details'] = $stmt->fetch() ?: [];
    } elseif ($type === 'Apartment') {
        $stmt = $pdo->prepare('SELECT Bedrooms FROM apartment WHERE AccommodationID = ?');
        $stmt->execute([$id]);
        $row['details'] = $stmt->fetch() ?: [];
    } else {
        $row['details'] = [];
    }

    respond(200, $row);
}

$sql = $baseSelect;
$params = [];

if (!empty($_GET['destination_id'])) {
    if (!is_numeric($_GET['destination_id'])) {
        respond(400, ['error' => 'Invalid destination_id']);
    }
    $sql .= ' WHERE a.DestinationID = ?';
    $params[] = (int)$_GET['destination_id'];
}

$stmt = $pdo->prepare($sql);
$stmt->execute($params);
respond(200, $stmt->fetchAll());