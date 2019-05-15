<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Edit Account</title>
</head>
<body>
<%@ page import = "java.sql.*" %>
<%
	String username = request.getParameter("user");
	String error = request.getParameter("error");
	String viewerUsername = (String)session.getAttribute("user");
	String password = "password";
	String firstName = "John/Jane";
	String lastName = "Smith/Doe";
	String address = "No address found.";
	String email = "No email found.";
	
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
	Statement st = conn.createStatement();
	Statement st1 = conn.createStatement();
	ResultSet rs, rs1;
	rs = st.executeQuery("SELECT * FROM Account INNER JOIN Person ON Account.personID = Person.userID WHERE userName = '" +  username + "'");	
	rs1 = st1.executeQuery("SELECT * FROM Account INNER JOIN Employee ON Account.personID = Employee.userID WHERE userName = '" +  viewerUsername + "'");
	if (rs.next()) {
		int userID = rs.getInt("actID");
		password = rs.getString("password");
		address = rs.getString("address");
		email = rs.getString("email"); 
		firstName = rs.getString("firstName");
		if (firstName != null)
			firstName = firstName.substring(0, 1).toUpperCase() + firstName.substring(1);
		lastName = rs.getString("lastName");
		if (lastName != null)
			lastName = lastName.substring(0, 1).toUpperCase() + lastName.substring(1);
	}
	if (!rs1.next()) {
		response.sendRedirect("index.html");
	}
%>
	<h1>Edit Account Settings</h1>
	<%	if (error != null) {
			if (error.equals("empty")) { %>
				<font style="font-size:15px; color:red;">Input fields cannot be empty!</font>		
	<%		} else if (error.equals("username")) { %>
				<font style="font-size:15px; color:red;">An account with that username already exists.</font>
	<%      } else if (error.equals("email")) { %>
			<font style="font-size:15px; color:red;">That email address is already in use.</font>
	<%  	} 
		}
	%>

	<form method="post" action="saveAccountChanges.jsp?user=<%= username %>">
	<table>
		<tr><td>Username: </td><td><input type="text" name="username" value="<%= username %>"/></td></tr>
		<tr><td>Password:  </td><td><input type="text" name="password" value="<%= password %>"/></td></tr>
		<tr><td>Email: </td><td><input type="text" name="email" value="<%= email %>"/></td></tr>
		<tr><td>First Name: </td><td><input type="text" name="firstName" value="<%= firstName %>"/></td></tr>
		<tr><td>Last Name: </td><td><input type="text" name="lastName" value="<%= lastName %>"/></td></tr>
		<tr><td>Address: </td><td><input type="text" name="address" value="<%= address %>"/></td></tr>
		<tr><td><input type="submit" name="submit" value="Save" /></td></td><td></tr>
		<tr><a href="profile.jsp?user=<%= username %>">Cancel Changes</a></tr>
	</table>
	
	</form></br>
	
	<% 
		if (rs != null) {
			rs.close();
			st.close();
		}
		if (rs1 != null) {
			rs1.close();
			st.close();
		}
		conn.close();
	%>
</body>
</html>