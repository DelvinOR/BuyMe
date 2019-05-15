<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create New Employee</title>
</head>
<body>
	<%@ page import = "java.sql.*" %>
		<a href="logout.jsp">Log out</a>
	<br>
	<a href="controlPanel.jsp">Back to Control Panel</a>
	<br>
	<h2>Create a new Customer Service Representative</h2>
	<%
	String error = request.getParameter("error");
	if (error != null) {
		if (error.equals("duplicate")) { %>
			<font style="font-size:15px; color:red;">A user with this username already exists.</font>	
	<% 	} else { %>
			<font style="font-size:15px; color:red;">There was an error in your <%= error %>. Make sure it is not left empty.</font>	
<%	  		} 
	}%>
	<%
		String username = (String)session.getAttribute("user");
		if (username == null) 
			response.sendRedirect("index.html");
	
		String permission = "u"; // u - user, c - customer service, a - admin
	
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
		Statement st = conn.createStatement();
		ResultSet rs;
		rs = st.executeQuery("SELECT * FROM Account WHERE userName = '" +  username + "'");
		
		if (rs.next()) {
			int userID = rs.getInt("personID");
			rs = st.executeQuery("SELECT * FROM Employee WHERE userID = '" +  userID + "'");
			if (rs.next())
				permission = rs.getString("type");
		}
		if (!permission.equals("a")) 
			response.sendRedirect("index.html");
	%>
	<form method="post" action="addCustomerService.jsp">
	<table>
		<tr><td><font style="color:red;">*</font> Username: </td><td><input type="text" name="username" /></td></tr>
		<tr><td><font style="color:red;">*</font> Password:  </td><td><input type="password" name="password" /></td></tr>
		<tr><td><font style="color:red;">*</font> Email: </td><td><input type="text" name="email" /></td></tr>
		<tr><td><font style="color:red;">*</font> First Name: </td><td><input type="text" name="firstName" /></td></tr>
		<tr><td><font style="color:red;">*</font> Last Name: </td><td><input type="text" name="lastName" /></td></tr>
		<tr><td><font style="color:red;">*</font> Address: </td><td><input type="text" name="address" /></td></tr>
		<tr><td><font style="color:red;">*</font> Salary: </td><td><input type="text" name="salary" /></td></tr>
		<tr><td></td><td><input type="submit" name="submit" value="Create User" /></td></tr>
	</table>
	</form></br>
</body>
</html>