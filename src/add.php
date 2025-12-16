<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Añadir Datos</title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css"  crossorigin="anonymous">
</head>

<body>
<div class = "container">
	<div class="jumbotron">
		<h1 class="display-4">Página de gestión de usuarios de César García</h1>
		<p class="lead">Práctica de implementación de aplicaciones web, infrastructura de 4 capas</p>

	</div>


<?php
// including the database connection file
include_once("config.php");

if(isset($_POST['Submit'])) {
	$name = mysqli_real_escape_string($mysqli, $_POST['name']);
	$age = mysqli_real_escape_string($mysqli, $_POST['age']);
	$email = mysqli_real_escape_string($mysqli, $_POST['email']);

	// checking empty fields
	if(empty($name) || empty($age) || empty($email)) {
		if(empty($name)) {
			echo "<div class='alert alert-danger' role='alert'>El nombre de edad está vacío</div>";
		}

		if(empty($age)) {
			echo "<div class='alert alert-danger' role='alert'>El campo de edad está vacío</div>";
		}

		if(empty($email)) {
			echo "<div class='alert alert-danger' role='alert'>El campo del e-mail está vacío</div>";
		}

		// link to the previous page
		echo "<a href='javascript:self.history.back();' class='btn btn-primary'>Volver</a>";
	} else {
		// if all the fields are filled (not empty)

		// insert data to database
		$stmt = mysqli_prepare($mysqli, "INSERT INTO users(name,age,email) VALUES(?,?,?)");
		mysqli_stmt_bind_param($stmt, "sis", $name, $age, $email);
		mysqli_stmt_execute($stmt);
		mysqli_stmt_free_result($stmt);
		mysqli_stmt_close($stmt);

		// display success message
		echo "<div class='alert alert-success' role='alert'>¡Datos añadidos correctamente!</div>";
		echo "<a href='index.php' class='btn btn-primary'>View Result</a>";
	}
}

mysqli_close($mysqli);

?>
</div>
</body>
</html>
