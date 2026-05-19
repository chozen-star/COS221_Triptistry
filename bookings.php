<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/response.php';
require_once __DIR__ . '/auth.php';

$session = requireRole('traveller');
$travelerId = $session['user_id'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $body = getRequestBody();

    if (empty($body['PackageID']) || !is_numeric($body['PackageID'])) {
        respond(400, ['error' => 'Valid PackageID is required']);
    }
    $packageId = (int)$body['PackageID'];

    $stmt = $pdo->prepare('SELECT * FROM packages WHERE TravelerID = ? AND PackageID = ?');
    $stmt->execute([$travelerId, $packageId]);
    if ($stmt->fetch()) {
        respond(409, ['error' => 'Already booked']);
    }

    $pdo->beginTransaction();
    try {
        $stmt = $pdo->prepare('INSERT INTO packages (TravelerID, PackageID) VALUES (?, ?)');
        $stmt->execute([$travelerId, $packageId]);

        $stmt = $pdo->prepare(
            'INSERT INTO booking (TravellerID, Status, BookingDate) VALUES (?, \'Pending\', NOW())'
        );
        $stmt->execute([$travelerId]);

        $pdo->commit();
        respond(201, ['message' => 'Booking created']);
    } catch (Exception $e) {
        $pdo->rollBack();
        respond(500, ['error' => 'Failed to create booking']);
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $pdo->prepare(
        'SELECT tp.*, ag.Name AS AgencyName
         FROM packages pk
         JOIN travelpackage tp ON tp.PackageID = pk.PackageID
         JOIN agency ag ON ag.AgencyID = tp.AgencyID
         WHERE pk.TravelerID = ?'
    );
    $stmt->execute([$travelerId]);
    respond(200, $stmt->fetchAll());
}

respond(405, ['error' => 'Method not allowed']);
