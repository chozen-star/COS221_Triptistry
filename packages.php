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
        $id = (int)$_GET['id'];

        $stmt = $pdo->prepare(
            'SELECT tp.*, ag.Name AS AgencyName, ag.Rating AS AgencyRating
             FROM travelpackage tp
             LEFT JOIN agency ag ON ag.AgencyID = tp.AgencyID
             WHERE tp.PackageID = ?'
        );
        $stmt->execute([$id]);
        $package = $stmt->fetch();

        if (!$package) {
            respond(404, ['error' => 'Package not found']);
        }

        $stmt = $pdo->prepare(
            'SELECT d.* FROM destination d
             JOIN package_dest pd ON pd.DestinationID = d.DestinationID
             WHERE pd.PackageID = ?'
        );
        $stmt->execute([$id]);
        $package['destinations'] = $stmt->fetchAll();

        $stmt = $pdo->prepare(
            'SELECT f.*, a.Name AS AirlineName FROM flight f
             JOIN includes inc ON inc.FlightID = f.FlightID
             LEFT JOIN airline a ON a.AirlineID = f.AirlineID
             WHERE inc.PackageID = ?'
        );
        $stmt->execute([$id]);
        $package['flights'] = $stmt->fetchAll();

        $stmt = $pdo->prepare(
            'SELECT ta.* FROM touristattraction ta
             JOIN package_attr pa ON pa.AttractionID = ta.AttractionID
             WHERE pa.PackageID = ?'
        );
        $stmt->execute([$id]);
        $package['attractions'] = $stmt->fetchAll();

        $stmt = $pdo->prepare(
            'SELECT r.*, GROUP_CONCAT(DISTINCT pc.Cuisine) AS CuisineTypes,
                    GROUP_CONCAT(DISTINCT rl.Location) AS Locations
             FROM restaurant r
             JOIN package_rest pr ON pr.RestaurantID = r.RestaurantID
             LEFT JOIN pack_cuisine pc ON pc.RestaurantID = r.RestaurantID
             LEFT JOIN rest_location rl ON rl.RestaurantID = r.RestaurantID
             WHERE pr.PackageID = ?
             GROUP BY r.RestaurantID'
        );
        $stmt->execute([$id]);
        $package['restaurants'] = $stmt->fetchAll();

        $stmt = $pdo->prepare(
            'SELECT a.*, d.Name AS DestinationName,
                    CASE WHEN h.AccommodationID IS NOT NULL THEN \'Hotel\'
                         WHEN r2.AccommodationID IS NOT NULL THEN \'Resort\'
                         WHEN ap2.AccommodationID IS NOT NULL THEN \'Apartment\'
                    END AS AccommodationType
             FROM accommodation a
             JOIN package_accom pa ON pa.AccommodationID = a.AccommodationID
             LEFT JOIN destination d ON d.DestinationID = a.DestinationID
             LEFT JOIN hotel h ON h.AccommodationID = a.AccommodationID
             LEFT JOIN resort r2 ON r2.AccommodationID = a.AccommodationID
             LEFT JOIN apartment ap2 ON ap2.AccommodationID = a.AccommodationID
             WHERE pa.PackageID = ?'
        );
        $stmt->execute([$id]);
        $package['accommodations'] = $stmt->fetchAll();

        respond(200, $package);
    }

    $sql = 'SELECT tp.*, ag.Name AS AgencyName, ag.Rating AS AgencyRating
            FROM travelpackage tp
            LEFT JOIN agency ag ON ag.AgencyID = tp.AgencyID';
    $conditions = [];
    $params = [];

    if (!empty($_GET['agency_id'])) {
        if (!is_numeric($_GET['agency_id'])) {
            respond(400, ['error' => 'Invalid agency_id']);
        }
        $conditions[] = 'tp.AgencyID = ?';
        $params[] = (int)$_GET['agency_id'];
    }
    if (!empty($_GET['type'])) {
        $conditions[] = 'tp.Type = ?';
        $params[] = $_GET['type'];
    }
    if (!empty($_GET['min_price'])) {
        if (!is_numeric($_GET['min_price'])) {
            respond(400, ['error' => 'Invalid min_price']);
        }
        $conditions[] = 'tp.Price >= ?';
        $params[] = (float)$_GET['min_price'];
    }
    if (!empty($_GET['max_price'])) {
        if (!is_numeric($_GET['max_price'])) {
            respond(400, ['error' => 'Invalid max_price']);
        }
        $conditions[] = 'tp.Price <= ?';
        $params[] = (float)$_GET['max_price'];
    }
    if (!empty($_GET['destination_id'])) {
        if (!is_numeric($_GET['destination_id'])) {
            respond(400, ['error' => 'Invalid destination_id']);
        }
        $conditions[] = 'tp.PackageID IN (SELECT PackageID FROM package_dest WHERE DestinationID = ?)';
        $params[] = (int)$_GET['destination_id'];
    }
    if (!empty($_GET['min_rating'])) {
        if (!is_numeric($_GET['min_rating'])) {
            respond(400, ['error' => 'Invalid min_rating']);
        }
        $conditions[] = 'ag.Rating >= ?';
        $params[] = (float)$_GET['min_rating'];
    }
    if (!empty($_GET['min_duration'])) {
        if (!is_numeric($_GET['min_duration'])) {
            respond(400, ['error' => 'Invalid min_duration']);
        }
        $conditions[] = 'tp.DurationDays >= ?';
        $params[] = (int)$_GET['min_duration'];
    }
    if (!empty($_GET['max_duration'])) {
        if (!is_numeric($_GET['max_duration'])) {
            respond(400, ['error' => 'Invalid max_duration']);
        }
        $conditions[] = 'tp.DurationDays <= ?';
        $params[] = (int)$_GET['max_duration'];
    }

    if ($conditions) {
        $sql .= ' WHERE ' . implode(' AND ', $conditions);
    }

    $sort = $_GET['sort'] ?? '';
    switch ($sort) {
        case 'price_asc':
            $sql .= ' ORDER BY tp.Price ASC';
            break;
        case 'price_desc':
            $sql .= ' ORDER BY tp.Price DESC';
            break;
        case 'rating':
            $sql .= ' ORDER BY AgencyRating DESC';
            break;
        case 'duration_asc':
            $sql .= ' ORDER BY tp.DurationDays ASC';
            break;
        case 'duration_desc':
            $sql .= ' ORDER BY tp.DurationDays DESC';
            break;
        default:
            $sql .= ' ORDER BY tp.PackageID DESC';
            break;
    }

    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    respond(200, $stmt->fetchAll());
}

$session = requireRole('agency');
$agencyId = $session['user_id'];

if ($method === 'POST') {
    validateCsrf();
    $body = getRequestBody();

    if (empty($body['Type']) || !isset($body['Price'])) {
        respond(400, ['error' => 'Type and Price are required']);
    }

    $pdo->beginTransaction();
    try {
        $includesLodging = isset($body['IncludesLodging']) ? (int)(bool)$body['IncludesLodging'] : 0;
        $includesService = isset($body['IncludesService']) ? (int)(bool)$body['IncludesService'] : 0;
        $includesActivities = isset($body['IncludesActivities']) ? (int)(bool)$body['IncludesActivities'] : 0;

        $durationDays = isset($body['DurationDays']) ? (int)$body['DurationDays'] : 0;
        $imageUrl = isset($body['ImageURL']) ? $body['ImageURL'] : null;

        $stmt = $pdo->prepare(
            'INSERT INTO travelpackage (Name, Type, Price, IncludesLodging, IncludesService, IncludesActivities, DurationDays, Itinerary, ImageURL, AgencyID)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
        );
        $stmt->execute([
            !empty($body['Name']) ? $body['Name'] : ('Package ' . $body['Type']), $body['Type'], (float)$body['Price'],
            $includesLodging, $includesService, $includesActivities,
            $durationDays, $body['Itinerary'] ?? null, $imageUrl,
            $agencyId
        ]);
        $packageId = $pdo->lastInsertId();

        if (!empty($body['destination_ids']) && is_array($body['destination_ids'])) {
            $stmt = $pdo->prepare(
                'INSERT INTO package_dest (DestinationID, PackageID) VALUES (?, ?)'
            );
            foreach ($body['destination_ids'] as $destId) {
                $stmt->execute([(int)$destId, $packageId]);
            }
        }

        if (!empty($body['flight_ids']) && is_array($body['flight_ids'])) {
            $stmt = $pdo->prepare(
                'INSERT INTO includes (PackageID, FlightID) VALUES (?, ?)'
            );
            foreach ($body['flight_ids'] as $flightId) {
                $stmt->execute([$packageId, (int)$flightId]);
            }
        }

        if (!empty($body['attraction_ids']) && is_array($body['attraction_ids'])) {
            $stmt = $pdo->prepare(
                'INSERT INTO package_attr (AttractionID, PackageID) VALUES (?, ?)'
            );
            foreach ($body['attraction_ids'] as $attrId) {
                $stmt->execute([(int)$attrId, $packageId]);
            }
        }

        if (!empty($body['restaurant_ids']) && is_array($body['restaurant_ids'])) {
            $stmt = $pdo->prepare(
                'INSERT INTO package_rest (RestaurantID, PackageID) VALUES (?, ?)'
            );
            foreach ($body['restaurant_ids'] as $restId) {
                $stmt->execute([(int)$restId, $packageId]);
            }
        }

        if (!empty($body['accommodation_ids']) && is_array($body['accommodation_ids'])) {
            $stmt = $pdo->prepare(
                'INSERT INTO package_accom (AccommodationID, PackageID) VALUES (?, ?)'
            );
            foreach ($body['accommodation_ids'] as $accomId) {
                $stmt->execute([(int)$accomId, $packageId]);
            }
        }

        $pdo->commit();
        respond(201, ['message' => 'Package created', 'PackageID' => $packageId]);
    } catch (Exception $e) {
        $pdo->rollBack();
        respond(500, ['error' => 'Failed to create package']);
    }
}

if ($method === 'PUT') {
    validateCsrf();
    if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        respond(400, ['error' => 'Valid PackageID required']);
    }
    $packageId = (int)$_GET['id'];

    $stmt = $pdo->prepare('SELECT AgencyID FROM travelpackage WHERE PackageID = ?');
    $stmt->execute([$packageId]);
    $pkg = $stmt->fetch();

    if (!$pkg) {
        respond(404, ['error' => 'Package not found']);
    }
    if ($pkg['AgencyID'] != $agencyId) {
        respond(403, ['error' => 'Forbidden']);
    }

    $body = getRequestBody();
    $type = !empty($body['Type']) ? $body['Type'] : ($pkg['Type'] ?? 'Bundled');

    $pdo->beginTransaction();
    try {
        $durationDays = isset($body['DurationDays']) ? (int)$body['DurationDays'] : 0;
        $imageUrl = isset($body['ImageURL']) ? $body['ImageURL'] : null;
        $stmt = $pdo->prepare(
            'UPDATE travelpackage SET Name = ?, Type = ?, Price = ?, IncludesLodging = ?, IncludesService = ?, IncludesActivities = ?, DurationDays = ?, Itinerary = ?, ImageURL = ?
             WHERE PackageID = ? AND AgencyID = ?'
        );
        $includesLodging = isset($body['IncludesLodging']) ? (int)(bool)$body['IncludesLodging'] : 0;
        $includesService = isset($body['IncludesService']) ? (int)(bool)$body['IncludesService'] : 0;
        $includesActivities = isset($body['IncludesActivities']) ? (int)(bool)$body['IncludesActivities'] : 0;

        $stmt->execute([
            $body['Name'] ?? $pkg['Name'], $type, (float)($body['Price'] ?? 0),
            $includesLodging, $includesService, $includesActivities,
            $durationDays, $body['Itinerary'] ?? null, $imageUrl,
            $packageId, $agencyId
        ]);

        if (isset($body['destination_ids']) && is_array($body['destination_ids'])) {
            $stmt = $pdo->prepare('DELETE FROM package_dest WHERE PackageID = ?');
            $stmt->execute([$packageId]);
            $stmt = $pdo->prepare('INSERT INTO package_dest (DestinationID, PackageID) VALUES (?, ?)');
            foreach ($body['destination_ids'] as $destId) {
                $stmt->execute([(int)$destId, $packageId]);
            }
        }
        if (isset($body['flight_ids']) && is_array($body['flight_ids'])) {
            $stmt = $pdo->prepare('DELETE FROM includes WHERE PackageID = ?');
            $stmt->execute([$packageId]);
            $stmt = $pdo->prepare('INSERT INTO includes (PackageID, FlightID) VALUES (?, ?)');
            foreach ($body['flight_ids'] as $flightId) {
                $stmt->execute([$packageId, (int)$flightId]);
            }
        }
        if (isset($body['attraction_ids']) && is_array($body['attraction_ids'])) {
            $stmt = $pdo->prepare('DELETE FROM package_attr WHERE PackageID = ?');
            $stmt->execute([$packageId]);
            $stmt = $pdo->prepare('INSERT INTO package_attr (AttractionID, PackageID) VALUES (?, ?)');
            foreach ($body['attraction_ids'] as $attrId) {
                $stmt->execute([(int)$attrId, $packageId]);
            }
        }
        if (isset($body['restaurant_ids']) && is_array($body['restaurant_ids'])) {
            $stmt = $pdo->prepare('DELETE FROM package_rest WHERE PackageID = ?');
            $stmt->execute([$packageId]);
            $stmt = $pdo->prepare('INSERT INTO package_rest (RestaurantID, PackageID) VALUES (?, ?)');
            foreach ($body['restaurant_ids'] as $restId) {
                $stmt->execute([(int)$restId, $packageId]);
            }
        }
        if (isset($body['accommodation_ids']) && is_array($body['accommodation_ids'])) {
            $stmt = $pdo->prepare('DELETE FROM package_accom WHERE PackageID = ?');
            $stmt->execute([$packageId]);
            $stmt = $pdo->prepare('INSERT INTO package_accom (AccommodationID, PackageID) VALUES (?, ?)');
            foreach ($body['accommodation_ids'] as $accomId) {
                $stmt->execute([(int)$accomId, $packageId]);
            }
        }

        $pdo->commit();
        respond(200, ['message' => 'Package updated']);
    } catch (Exception $e) {
        $pdo->rollBack();
        respond(500, ['error' => 'Failed to update package']);
    }
}

if ($method === 'DELETE') {
    validateCsrf();
    if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        respond(400, ['error' => 'Valid PackageID required']);
    }
    $packageId = (int)$_GET['id'];

    $stmt = $pdo->prepare('SELECT AgencyID FROM travelpackage WHERE PackageID = ?');
    $stmt->execute([$packageId]);
    $pkg = $stmt->fetch();

    if (!$pkg) {
        respond(404, ['error' => 'Package not found']);
    }
    if ($pkg['AgencyID'] != $agencyId) {
        respond(403, ['error' => 'Forbidden']);
    }

    $pdo->beginTransaction();
    try {
        $stmt = $pdo->prepare('DELETE FROM packages WHERE PackageID = ?');
        $stmt->execute([$packageId]);
        $stmt = $pdo->prepare('DELETE FROM package_accom WHERE PackageID = ?');
        $stmt->execute([$packageId]);
        $stmt = $pdo->prepare('DELETE FROM package_dest WHERE PackageID = ?');
        $stmt->execute([$packageId]);
        $stmt = $pdo->prepare('DELETE FROM includes WHERE PackageID = ?');
        $stmt->execute([$packageId]);
        $stmt = $pdo->prepare('DELETE FROM package_attr WHERE PackageID = ?');
        $stmt->execute([$packageId]);
        $stmt = $pdo->prepare('DELETE FROM package_rest WHERE PackageID = ?');
        $stmt->execute([$packageId]);
        $stmt = $pdo->prepare('DELETE FROM travelpackage WHERE PackageID = ? AND AgencyID = ?');
        $stmt->execute([$packageId, $agencyId]);
        $pdo->commit();
        respond(200, ['message' => 'Package deleted']);
    } catch (Exception $e) {
        $pdo->rollBack();
        respond(500, ['error' => 'Failed to delete package']);
    }
}

respond(405, ['error' => 'Method not allowed']);
