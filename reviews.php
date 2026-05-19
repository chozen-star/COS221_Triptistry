<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/response.php';
require_once __DIR__ . '/auth.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $session = requireRole('traveller');
    $travelerId = $session['user_id'];
    $body = getRequestBody();

    if (empty($body['StarRating']) || empty($body['Feedback'])) {
        respond(400, ['error' => 'StarRating and Feedback are required']);
    }

    $rating = (int)$body['StarRating'];
    if ($rating < 1 || $rating > 5) {
        respond(400, ['error' => 'Rating must be 1-5']);
    }

    $targets = array_filter([
        'RestaurantID' => $body['RestaurantID'] ?? null,
        'DestinationID' => $body['DestinationID'] ?? null,
        'AccommodationID' => $body['AccommodationID'] ?? null,
    ], function ($v) {
        return $v !== null && $v !== '';
    });

    if (count($targets) === 0) {
        respond(400, ['error' => 'Must provide exactly one target: RestaurantID, DestinationID, or AccommodationID']);
    }
    if (count($targets) > 1) {
        respond(400, ['error' => 'Provide exactly one target ID, not multiple']);
    }

    $restaurantId = $targets['RestaurantID'] ?? null;
    $destinationId = $targets['DestinationID'] ?? null;
    $accommodationId = $targets['AccommodationID'] ?? null;

    $stmt = $pdo->prepare(
        'INSERT INTO review (StarRating, DateSubmitted, Feedback, TravelerID, RestaurantID, DestinationID, AccommodationID)
         VALUES (?, CURDATE(), ?, ?, ?, ?, ?)'
    );
    $stmt->execute([
        $rating, $body['Feedback'], $travelerId,
        $restaurantId, $destinationId, $accommodationId
    ]);

    respond(201, ['message' => 'Review submitted']);
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $targetId = null;
    $sql = 'SELECT rv.*, t.Name AS TravellerName
            FROM review rv
            LEFT JOIN traveler t ON t.TravelerID = rv.TravelerID
            WHERE ';

    if (!empty($_GET['restaurant_id'])) {
        $sql .= 'rv.RestaurantID = ?';
        $targetId = $_GET['restaurant_id'];
    } elseif (!empty($_GET['destination_id'])) {
        $sql .= 'rv.DestinationID = ?';
        $targetId = $_GET['destination_id'];
    } elseif (!empty($_GET['accommodation_id'])) {
        $sql .= 'rv.AccommodationID = ?';
        $targetId = $_GET['accommodation_id'];
    } else {
        respond(400, ['error' => 'Provide one of: restaurant_id, destination_id, accommodation_id']);
    }

    if (!is_numeric($targetId)) {
        respond(400, ['error' => 'Invalid ID parameter']);
    }

    $stmt = $pdo->prepare($sql);
    $stmt->execute([(int)$targetId]);
    $rows = $stmt->fetchAll();

    if (!$rows) {
        respond(404, ['error' => 'No reviews found']);
    }
    respond(200, $rows);
}

respond(405, ['error' => 'Method not allowed']);
