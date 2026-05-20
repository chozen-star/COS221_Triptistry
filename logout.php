<?php
require_once __DIR__ . '/response.php';

session_start();
session_destroy();
respond(200, ['message' => 'Logged out']);
