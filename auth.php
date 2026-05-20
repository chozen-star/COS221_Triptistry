<?php
require_once __DIR__ . '/response.php';

function requireAuth() {
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }
    if (!isset($_SESSION['user_id']) || !isset($_SESSION['user_type'])) {
        respond(401, ['error' => 'Unauthorized']);
    }
    return $_SESSION;
}

function requireRole($role) {
    $session = requireAuth();
    if ($session['user_type'] !== $role) {
        respond(403, ['error' => 'Forbidden']);
    }
    return $session;
}

function getRequestBody() {
    $contentType = $_SERVER['CONTENT_TYPE'] ?? '';
    if (strpos($contentType, 'application/json') !== false) {
        $body = json_decode(file_get_contents('php://input'), true);
        return is_array($body) ? $body : [];
    }
    return $_POST;
}
