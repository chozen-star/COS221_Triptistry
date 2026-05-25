<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/response.php';
require_once __DIR__ . '/auth.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    if (isset($_GET['id'])) {
        if (!is_numeric($_GET['id'])) {
            respond(400, ['error' => 'Invalid ID']);
        }
        $stmt = $pdo->prepare(
            'SELECT gt.*, ag.Name AS AgencyName
             FROM grouptrip gt
             LEFT JOIN agency ag ON ag.AgencyID = gt.AgencyID
             WHERE gt.GroupTripID = ?'
        );
        $stmt->execute([(int)$_GET['id']]);
        $row = $stmt->fetch();
        if (!$row) {
            respond(404, ['error' => 'Group trip not found']);
        }
        respond(200, $row);
    }

    $sql = 'SELECT gt.*, ag.Name AS AgencyName
            FROM grouptrip gt
            LEFT JOIN agency ag ON ag.AgencyID = gt.AgencyID';
    $params = [];

    if (!empty($_GET['agency_id'])) {
        if (!is_numeric($_GET['agency_id'])) {
            respond(400, ['error' => 'Invalid agency_id']);
        }
        $sql .= ' WHERE gt.AgencyID = ?';
        $params[] = (int)$_GET['agency_id'];
    }

    if (!empty($_GET['enrolled_by'])) {
        if (!is_numeric($_GET['enrolled_by'])) {
            respond(400, ['error' => 'Invalid traveller_id']);
        }
        $sql .= (strpos($sql, 'WHERE') !== false ? ' AND' : ' WHERE') . ' gt.GroupTripID IN (SELECT GroupTripID FROM group_enrolment WHERE TravellerID = ?)';
        $params[] = (int)$_GET['enrolled_by'];
    }

    if (empty($_GET['agency_id'])) {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        if (isset($_SESSION['user_type']) && $_SESSION['user_type'] === 'agency') {
            $sql .= (strpos($sql, 'WHERE') !== false ? ' AND' : ' WHERE') . ' gt.AgencyID = ?';
            $params[] = $_SESSION['user_id'];
        }
    }

    $sql .= ' ORDER BY gt.StartDate';

    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    respond(200, $stmt->fetchAll());
}

if ($method === 'POST') {
    $action = $_GET['action'] ?? '';

    if ($action === 'enrol') {
        $session = requireRole('traveller');
        $travelerId = $session['user_id'];
        $body = getRequestBody();

        if (empty($body['GroupTripID']) || !is_numeric($body['GroupTripID'])) {
            respond(400, ['error' => 'Valid GroupTripID required']);
        }
        $tripId = (int)$body['GroupTripID'];

        $stmt = $pdo->prepare('SELECT CurrentEnrolment, MaxSize FROM grouptrip WHERE GroupTripID = ?');
        $stmt->execute([$tripId]);
        $trip = $stmt->fetch();

        if (!$trip) {
            respond(404, ['error' => 'Group trip not found']);
        }
        if ($trip['CurrentEnrolment'] >= $trip['MaxSize']) {
            respond(400, ['error' => 'Trip is full']);
        }

        $stmt = $pdo->prepare('SELECT * FROM group_enrolment WHERE TravellerID = ? AND GroupTripID = ?');
        $stmt->execute([$travelerId, $tripId]);
        if ($stmt->fetch()) {
            respond(409, ['error' => 'Already enrolled in this trip']);
        }

        $pdo->beginTransaction();
        try {
            $stmt = $pdo->prepare('INSERT INTO group_enrolment (TravellerID, GroupTripID) VALUES (?, ?)');
            $stmt->execute([$travelerId, $tripId]);

            $stmt = $pdo->prepare('UPDATE grouptrip SET CurrentEnrolment = CurrentEnrolment + 1 WHERE GroupTripID = ?');
            $stmt->execute([$tripId]);

            $pdo->commit();
            respond(200, ['message' => 'Enrolled successfully']);
        } catch (Exception $e) {
            $pdo->rollBack();
            respond(500, ['error' => 'Failed to enrol']);
        }
    }

    $session = requireRole('agency');
    $agencyId = $session['user_id'];
    $body = getRequestBody();

    if (empty($body['MaxSize']) || empty($body['Itinerary']) || empty($body['StartDate']) || empty($body['EndDate'])) {
        respond(400, ['error' => 'MaxSize, Itinerary, StartDate, and EndDate are required']);
    }

    $stmt = $pdo->prepare(
        'INSERT INTO grouptrip (Name, MaxSize, CurrentEnrolment, Price, Itinerary, StartDate, EndDate, ImageURL, AgencyID)
         VALUES (?, ?, 0, ?, ?, ?, ?, ?, ?)'
    );
    $stmt->execute([
        !empty($body['Name']) ? $body['Name'] : 'Group Trip',
        (int)$body['MaxSize'],
        !empty($body['Price']) ? (float)$body['Price'] : null,
        $body['Itinerary'],
        $body['StartDate'], $body['EndDate'],
        !empty($body['ImageURL']) ? $body['ImageURL'] : null,
        $agencyId
    ]);

    respond(201, ['message' => 'Group trip created', 'GroupTripID' => $pdo->lastInsertId()]);
}

if ($method === 'PUT') {
    $session = requireRole('agency');
    $agencyId = $session['user_id'];

    if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        respond(400, ['error' => 'Valid GroupTripID required']);
    }
    $tripId = (int)$_GET['id'];

    $stmt = $pdo->prepare('SELECT AgencyID FROM grouptrip WHERE GroupTripID = ?');
    $stmt->execute([$tripId]);
    $trip = $stmt->fetch();

    if (!$trip) {
        respond(404, ['error' => 'Group trip not found']);
    }
    if ($trip['AgencyID'] != $agencyId) {
        respond(403, ['error' => 'Forbidden']);
    }

    $body = getRequestBody();
    $stmt = $pdo->prepare(
        'UPDATE grouptrip SET Name = ?, MaxSize = ?, Price = ?, Itinerary = ?, StartDate = ?, EndDate = ?, ImageURL = ?
         WHERE GroupTripID = ? AND AgencyID = ?'
    );
    $stmt->execute([
        $body['Name'] ?? '', (int)($body['MaxSize'] ?? 0),
        !empty($body['Price']) ? (float)$body['Price'] : null,
        $body['Itinerary'] ?? '',
        $body['StartDate'] ?? '', $body['EndDate'] ?? '',
        $body['ImageURL'] ?? null,
        $tripId, $agencyId
    ]);

    respond(200, ['message' => 'Group trip updated']);
}

if ($method === 'DELETE') {
    $session = requireAuth();
    $userId = $session['user_id'];
    $userType = $session['user_type'];

    if ($userType === 'traveller') {
        if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            respond(400, ['error' => 'Valid GroupTripID required']);
        }
        $tripId = (int)$_GET['id'];

        $pdo->beginTransaction();
        try {
            $stmt = $pdo->prepare('DELETE FROM group_enrolment WHERE TravellerID = ? AND GroupTripID = ?');
            $stmt->execute([$userId, $tripId]);
            $stmt = $pdo->prepare('UPDATE grouptrip SET CurrentEnrolment = GREATEST(CurrentEnrolment - 1, 0) WHERE GroupTripID = ?');
            $stmt->execute([$tripId]);
            $pdo->commit();
            respond(200, ['message' => 'Left group trip']);
        } catch (Exception $e) {
            $pdo->rollBack();
            respond(500, ['error' => 'Failed to leave trip']);
        }
        return;
    }

    $session = requireRole('agency');
    $agencyId = $session['user_id'];

    if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        respond(400, ['error' => 'Valid GroupTripID required']);
    }
    $tripId = (int)$_GET['id'];

    $stmt = $pdo->prepare('SELECT AgencyID FROM grouptrip WHERE GroupTripID = ?');
    $stmt->execute([$tripId]);
    $trip = $stmt->fetch();

    if (!$trip) {
        respond(404, ['error' => 'Group trip not found']);
    }
    if ($trip['AgencyID'] != $agencyId) {
        respond(403, ['error' => 'Forbidden']);
    }

    $pdo->beginTransaction();
    try {
        $stmt = $pdo->prepare('DELETE FROM group_enrolment WHERE GroupTripID = ?');
        $stmt->execute([$tripId]);
        $stmt = $pdo->prepare('DELETE FROM grouptrip WHERE GroupTripID = ? AND AgencyID = ?');
        $stmt->execute([$tripId, $agencyId]);
        $pdo->commit();
        respond(200, ['message' => 'Group trip deleted']);
    } catch (Exception $e) {
        $pdo->rollBack();
        respond(500, ['error' => 'Failed to delete group trip']);
    }
}

respond(405, ['error' => 'Method not allowed']);
