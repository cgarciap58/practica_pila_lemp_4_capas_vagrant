<?php

define('DB_HOST', '192.168.30.6');
define('DB_NAME', 'web0app');
define('DB_USER', 'dbuser');
define('DB_PASSWORD', 'dbpass');

$mysqli = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);

if (!$mysqli) {
    die('Database connection failed: ' . mysqli_connect_error());
}
?>