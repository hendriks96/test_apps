<?php
	include 'config.php';


	if (!empty($_GET['id'])){
		$baseUrl 	=	'https://3938-36-82-126-29.ngrok.io/folarium-submission/';
		$response 	=	[];
		
		$id 		=	$_GET['id'];
		
		$sql 		= 	"select * from users_bio where user_id = $id";
		$result 	= 	$conn -> query($sql);
		$row 		= 	$result->fetch_row();
		
		$response['user_id']			=	(int)$row[0];
		$response['full_name']			= 	$row[1];
		$response['gender']				=	$row[2];		
		$response['date_of_birth']		=	$row[3];
		$response['current_location']	=	$row[4];
		$response['image_url']			=	$baseUrl . $row[5];
		$response['token_id']			=	$row[6];

		
		$json['status']		=	200;
		$json['success']	=	true;
		$json['message']	=	'success get data';
		$json['data']		=	$response;

	} else {
		$json['status']		=	403;
		$json['suceess']	=	false;
		$json['message']	=	'Please check parameter';
	}
	echo json_encode($json);
?>