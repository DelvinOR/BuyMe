<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>User Search</title>
</head>
<body>
	<%@ page import = "java.sql.*" %>
	<h1>User search</h1>
	<%
		String query = request.getParameter("usernameSearch");
		String source = request.getParameter("src");
		if (source != null && source.equals("admin")) {
	%>
	<form method = "post" action = "searchUsers.jsp?src=<%= source %>">
		Search users:
		<input type="text" name="usernameSearch" value="<%= query %>">
		<input type= "submit" value = "Search"/>
	</form>
	<a href="controlPanel.jsp">Return to Control Panel</a>
	<% } else {%>
	<a href="dashboard.jsp">Return to Homepage</a>
	<% } %>
	<table style="border: 2px solid #666666;">
		<tr>
			<th>Username</th>
			<th>Profile</th>
		</tr>
		<%
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
			Statement st = conn.createStatement();
			ResultSet rs;
			rs = st.executeQuery("SELECT * FROM Account WHERE userName LIKE '%" + query + "%'");
			
			while (rs.next()) {
				String username = rs.getString("userName");
		%>
		<tr style="border: 2px solid #666666;">
			<td><%= username %></td>
			<td><a href="profile.jsp?user=<%= username %>">View profile</a></td>
		</tr>
	<% }%>
	</table>
	<% 			
		if (rs != null) {
			rs.close();
			st.close();
		}
		conn.close(); 
	%>
</body>
</html>