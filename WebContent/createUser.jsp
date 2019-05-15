<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Account Creation</title>
</head>
<body>
	<h2>Create your account</h2>
	<%
		String error = request.getParameter("error");
		if (error != null) {
			if (error.equals("duplicate")) { %>
				<font style="font-size:15px; color:red;">A user with this username already exists.</font>	
		<% 	} else { %>
				<font style="font-size:15px; color:red;">There was an error in your <%= error %>. Make sure it is not left empty.</font>	
	<%	  		} 
		}%>
	<form method="post" action="addUser.jsp">
		<table>
			<tr><td><font style="color:red;">*</font> Username: </td><td><input type="text" name="username" /></td></tr>
			<tr><td><font style="color:red;">*</font> Password:  </td><td><input type="password" name="password" /></td></tr>
			<tr><td><font style="color:red;">*</font> Email: </td><td><input type="text" name="email" /></td></tr>
			<tr><td><font style="color:red;">*</font> First Name: </td><td><input type="text" name="firstName" /></td></tr>
			<tr><td><font style="color:red;">*</font> Last Name: </td><td><input type="text" name="lastName" /></td></tr>
			<tr><td><font style="color:red;">*</font> Address: </td><td><input type="text" name="address" /></td></tr>
			<tr><td></td><td><input type="submit" name="submit" value="Create User" /></td></tr>
		</table>
	</form></br>
	Already have an account? <a href="login.jsp">Log in now!</a> </br>
	<a href='index.html'>Homepage</a>

</body>
</html>