<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Simple Login Web page</title>
</head>
<body>
	<h2>Log In</h2>
	<%
		String error = request.getParameter("error");
		if (error != null) {
	%>
			<font style="font-size:15px; color:red;">Incorrect username/password.</font>	
	<% 	} %>	
	<form method="post" action="checkLoginDetails.jsp">
		<table>
		<tr><td>Username: </td><td><input type="text" name="username" /></td></tr>
		<tr><td>Password: </td><td><input type="password" name="password" /> </td></tr>
		<tr><td></td><td><input type="submit" name="submit" value="Sign In" /></td></tr>
		</table>
	</form></br>
	Don't have an account? <a href="createUser.jsp">Create one!</a></br>
	<a href='index.html'>Homepage</a>
</body>
</html>