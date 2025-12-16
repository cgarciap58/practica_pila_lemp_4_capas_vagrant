<?php
// including the database connection file
include_once("config.php");

// fetching data in descending order (lastest entry first)
$result = mysqli_query($mysqli, "SELECT * FROM users ORDER BY id DESC");
?>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Página de César</title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css"  crossorigin="anonymous">	
</head>

<body>
<div class = "container">
	<div class="jumbotron">
      <h1 class="display-4">Página de gestión de usuarios de César García</h1>
	  <p class="lead">Práctica de implementación de aplicaciones web, infrastructura de 4 capas</p>

    </div>	
	<a href="add.html" class="btn btn-primary">Añadir más datos</a><br/><br/>
	<table width='80%' border=0 class="table">

	<tr bgcolor='#ad9797ff'>
		<td>Nombre</td>
		<td>Edad</td>
		<td>Email</td>
		<td>Actualización</td>
	</tr>

	<?php
	while($res = mysqli_fetch_array($result)) {
		echo "<tr>\n";
		echo "<td>".$res['name']."</td>\n";
		echo "<td>".$res['age']."</td>\n";
		echo "<td>".$res['email']."</td>\n";
		echo "<td><a href=\"edit.php?id=$res[id]\">Edit</a> | <a href=\"delete.php?id=$res[id]\" onClick=\"return confirm('Are you sure you want to delete?')\">Delete</a></td>\n";
		echo "</tr>\n";
	}

	mysqli_close($mysqli);
	?>
	</table>
</div>
</body>
</html>
