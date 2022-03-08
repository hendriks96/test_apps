<?php
include 'config.php';

if(!empty($_POST['full_name']) && !empty($_POST['date_of_birth'])&& !empty($_POST['gender']) && !empty($_POST['current_location']) && !empty($_POST['token_id'])){
	
	$upload_dir 		=  'images/';
	$full_name 			= 	$_POST['full_name'];
	$date_of_birth 		= 	$_POST['date_of_birth'];
	$gender 			= 	$_POST['gender'];
	$current_location 	= 	$_POST['current_location'];
	$image 				=	$_FILES['image'];
	$token_id 			= 	$_POST['token_id'];
	$image_name 		= 	$image["name"];
	$image_tmp_name 	= 	$image["tmp_name"];

	$random_name 		= 	rand(1000,1000000)."-".$image_name;
    $upload_name 		= 	$upload_dir.strtolower($random_name);
    $upload_name 		= 	preg_replace('/\s+/', '-', $upload_name);
    
	if(move_uploaded_file($image_tmp_name , $upload_name)) {
		$image_url 		=	$upload_name;
	}

	$sql 				= 	"insert into users_bio values('','$full_name', '$gender', '$date_of_birth', '$current_location', '$image_url', '$token_id')";
	
	mysqli_query($conn, $sql);
	$id 				= 	mysqli_insert_id($conn);
	
	if ($id != 0){
		$sql 		= 	"select * from users_bio where user_id = $id";
		$result 	= 	$conn -> query($sql);
		$row 		= 	$result->fetch_row();

		$response['user_id']		=	$id;
		$response['token_id']		=	$row[6];
		$json['status'] 			= 	201;
		$json['success']			=	true;
		$json['message'] 			= 	"saved success";
		$json['data']				=	$response;
	}else{
		$json['status']		=	500;
		$json['status'] 	= 	false;
		$json['message'] 	= 	"something wrong";
	}
}else {
	$json['status']		=	403;
	$json['success'] 	= 	false;
	$json['message'] 	= 	"parameter not found";
}
echo json_encode($json);
?>

