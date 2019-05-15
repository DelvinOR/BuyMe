<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Delete Customer Service</title>
</head>
<body>
	<%@page import="java.sql.*" %>
	<a href="controlPanel.jsp">Back to Control Panel</a>
	<br><br>
	<%
		String username = (String)session.getAttribute("user");
		String deletion = request.getParameter("deleted");
	
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
		Statement st = conn.createStatement();
		ResultSet rs;
		rs = st.executeQuery("SELECT * FROM Account INNER JOIN Employee ON Account.personID = Employee.userID WHERE userName = '" +  username + "'");
		if (!rs.next())
			response.sendRedirect("index.html");
		
		if (deletion != null) { %>
			<font style="font-size:15px; color:green;">Successfully removed <%= username %>!</font>		
	<%  } %>
	<table style="border: 2px solid #666666;">
		<tr><th>Username</th><th>Profile</th><th>Action</th></tr>
		<%
			rs = st.executeQuery("SELECT * FROM Account INNER JOIN Employee ON Account.personID = Employee.userID WHERE type = 'c'");
			while (rs.next()) {
				String empUsername = rs.getString("userName");
		%>
				<tr>
				<td style="padding-left: 10px; padding-right: 10px;"><%= empUsername %></td>
				<td style="padding-left: 10px; padding-right: 10px;"><a href="profile.jsp?user=<%= empUsername %>">View profile</a></td>
				<td style="padding-left: 10px; padding-right: 10px;"><a href="deleteCustomerService.jsp?user=<%= empUsername %>">Delete</a></td>
				</tr>
		<% 
			}
		%>
	</table>
	<%
		rs.close();
		st.close();
		conn.close();
	%>
</body>
</html>