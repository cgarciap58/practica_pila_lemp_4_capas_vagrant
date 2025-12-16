sudo apt update
sudo apt install php-cli php-mysql mariadb-client -y

# Small PHP test script
cat <<'EOF' > /home/vagrant/testdb.php
<?php
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT); // <-- enable exceptions
$mysqli = new mysqli("192.168.30.6", "dbuser", "dbpass", "web0app"); // HAProxy IP

if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}
echo "Connected successfully!\n";

$result = $mysqli->query("SELECT * FROM users");
if ($result) {
    $rows = $result->fetch_all(MYSQLI_ASSOC);
    if (count($rows) === 0) {
        echo "No rows returned.\n";
    } else {
        foreach ($rows as $row) {
            echo $row['id'] . ": " . $row['name'] . " - " . $row['email'] . "\n";
        }
    }
}
$mysqli->close();
?>
EOF

cat <<'EOF' > /home/vagrant/test2.php
<?php
$mysqli = new mysqli(
    "192.168.30.6",  // HAProxy IP
    "dbuser",
    "dbpass",
    "web0app"
);

if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

$result = $mysqli->query("SELECT @@hostname AS node");
$row = $result->fetch_assoc();

echo "Answered by: " . $row['node'] . PHP_EOL;
EOF