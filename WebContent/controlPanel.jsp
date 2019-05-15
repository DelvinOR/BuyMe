<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Control Panel</title>
</head>
<body>
	<%@ page import = "java.sql.*" %>
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
		if (permission.equals("u")) 
			response.sendRedirect("index.html");
	%>
	<a href="logout.jsp">Log out</a>
	<br>
	<a href="dashboard.jsp"> Homepage</a>
	<br>
	<h2>Welcome to the Control Panel</h2>
	<% 
		rs = st.executeQuery("SELECT COUNT(status) AS statusCount FROM forum WHERE status = 'unanswered'");
		if (rs.next()) {
			int questionCount = rs.getInt("statusCount");
			if (questionCount > 0) { %>
				<h3>There are unanswered questions! Click <a href="displayMessages.jsp">here</a> to answer them.</h3><br>
			<%}
		}
	%>
	<form method = "post" action = "searchUsers.jsp?src=admin">
		Search users:
		<input type="text" name="usernameSearch">
		<input type= "submit" value = "Search"/>
	</form>
	<br>
	<% if (permission.equals("a")) {%>
		<form method = "post" action = "createCustomerService.jsp">
			Add Customer Service Representative:
			<input type= "submit" value = "Add Employee"/>
		</form>
		<form method = "post" action = "generateReport.jsp">
			Generate Report:
			<br><input type = "radio" name="filter" value="Total Earnings" checked/> Total Earnings 
			<br><input type = "radio" name="filter" value="Earnings per item"/> Earnings per item
			<br><input type = "radio" name="filter" value="Earnings per item type"/> Earnings per item type 
			<br><input type = "radio" name="filter" value="Earnings per user"/> Earnings per user
			<br><input type = "radio" name="filter" value="Best selling items"/> Best selling items
			<br><input type = "radio" name="filter" value="Best buyers"/> Best buyers
			<br><input type= "submit" value = "Generate Report"/>
		</form>
	<% } %>
</body>
</html>