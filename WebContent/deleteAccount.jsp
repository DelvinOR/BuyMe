<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Deactivate Account</title>
</head>
<body>
	<form method="post" action="deleteUserPerson.jsp">
		Are you sure you want to deactivate your account? <br> 
		<input type="submit" value = "Yes" /> <br>
	</form>

	<form method="post" action="success.jsp">
		<input type="submit" value="No" />
	</form>

</body>
</html>