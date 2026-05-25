<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/response.php';
require_once __DIR__ . '/auth.php';

$session = requireAuth();
$userId = $session['user_id'];
$userType = $session['user_type'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    validateCsrf();
    if ($userType !== 'traveller') {
        respond(403, ['error' => 'Only travellers can book packages']);
    }
    $body = getRequestBody();

    if (empty($body['PackageID']) || !is_numeric($body['PackageID'])) {
        respond(400, ['error' => 'Valid PackageID is required']);
    }
    $packageId = (int)$body['PackageID'];

    $stmt = $pdo->prepare('SELECT * FROM packages WHERE TravelerID = ? AND PackageID = ?');
    $stmt->execute([$userId, $packageId]);
    if ($stmt->fetch()) {
        respond(409, ['error' => 'Already booked']);
    }

    $pdo->beginTransaction();
    try {
        $stmt = $pdo->prepare('INSERT INTO packages (TravelerID, PackageID) VALUES (?, ?)');
        $stmt->execute([$userId, $packageId]);

        $stmt = $pdo->prepare(
            'INSERT INTO booking (TravellerID, Status, BookingDate) VALUES (?, \'Pending\', NOW())'
        );
        $stmt->execute([$userId]);

        $pdo->commit();
        respond(201, ['message' => 'Booking created']);
    } catch (Exception $e) {
        $pdo->rollBack();
        respond(500, ['error' => 'Failed to create booking']);
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if ($userType === 'agency') {
        $filterAgencyId = !empty($_GET['agency_id']) ? (int)$_GET['agency_id'] : $userId;
        $stmt = $pdo->prepare(
            'SELECT tp.*, ag.Name AS AgencyName, t.Name AS TravellerName, t.Email AS TravellerEmail
             FROM packages pk
             JOIN travelpackage tp ON tp.PackageID = pk.PackageID
             JOIN agency ag ON ag.AgencyID = tp.AgencyID
             JOIN traveler t ON t.TravelerID = pk.TravelerID
             WHERE tp.AgencyID = ?
             ORDER BY pk.ID DESC'
        );
        $stmt->execute([$filterAgencyId]);
        respond(200, $stmt->fetchAll());
    } else {
        $stmt = $pdo->prepare(
            'SELECT tp.*, ag.Name AS AgencyName
             FROM packages pk
             JOIN travelpackage tp ON tp.PackageID = pk.PackageID
             JOIN agency ag ON ag.AgencyID = tp.AgencyID
             WHERE pk.TravelerID = ?
             ORDER BY pk.ID DESC'
        );
        $stmt->execute([$userId]);
        respond(200, $stmt->fetchAll());
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    validateCsrf();
    if ($userType !== 'traveller') {
        respond(403, ['error' => 'Only travellers can cancel bookings']);
    }
    if (!isset($_GET['package_id']) || !is_numeric($_GET['package_id'])) {
        respond(400, ['error' => 'Valid package_id is required']);
    }
    $packageId = (int)$_GET['package_id'];

    $pdo->beginTransaction();
    try {
        $stmt = $pdo->prepare('DELETE FROM packages WHERE TravelerID = ? AND PackageID = ?');
        $stmt->execute([$userId, $packageId]);

        $stmt = $pdo->prepare('SELECT COUNT(*) FROM packages WHERE TravelerID = ?');
        $stmt->execute([$userId]);
        if ($stmt->fetchColumn() == 0) {
            $stmt = $pdo->prepare('DELETE FROM booking WHERE TravellerID = ?');
            $stmt->execute([$userId]);
        }

        $pdo->commit();
        respond(200, ['message' => 'Booking cancelled']);
    } catch (Exception $e) {
        $pdo->rollBack();
        respond(500, ['error' => 'Failed to cancel booking']);
    }
}

respond(405, ['error' => 'Method not allowed']);
