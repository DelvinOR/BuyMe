<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>User Dashboard</title>
</head>
<body>
	<%@ page import = "java.sql.*" %>
	<%
		String username = (String)session.getAttribute("user");
		
		int itemAlerts = 0;
		int actID = 0;
		
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
			actID = rs.getInt("actID");
			rs = st.executeQuery("SELECT * FROM Employee WHERE userID = '" +  userID + "'");
			if (rs.next()){
				permission = rs.getString("type");
			}
			rs = st.executeQuery("SELECT COUNT(*) AS count FROM itemAlerts WHERE actID='"+actID+"'");
			if(rs.next()){
				itemAlerts = rs.getInt("count");
			}
		}
	%>

	<h1>Welcome, <%= username %></h1>
	<br />
	<%
	if(itemAlerts!=0){
		%>
		<p>You have <%=itemAlerts %> tracked items you are interested in! <a href=<%= "\"displayTrackedItems.jsp?user=" + username + "&userID=" + actID + "\"" %>>View list of track items</a></p>
		<%
	}
	
	%>
	
	<form method="post" action="logout.jsp">
		<input type="submit" name="signOutSubmit" value="Sign Out" />
	</form>
		<form method="post" action="profile.jsp?user=<%= username%>">
		<input type="submit" name="username" value="My Profile" />
	</form>
	<form method="post" action="createPost.jsp">
		<input type="submit" name="postItem" value="Post Item" />
	</form>
	<form method="post" action="displayItems.jsp">
		<input type="submit" name="postItem" value="Items for Sale" />
	</form>
	<form method="post" action="displayMessages.jsp">
		<input type="submit" name="postItem" value="Forum" />
	</form>
	<% if (!permission.equals("u")) {%>
		<form method="post" action="controlPanel.jsp">
			<input type="submit" name="controlPanel" value="Control Panel" />
		</form>
	<% } %>
</body>
</html>
