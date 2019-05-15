<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Deleting Customer Representative..</title>
</head>
<body>
	<%@page import="java.sql.*" %>
	<%
		String username = request.getParameter("user");
	
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
		Statement st = conn.createStatement();
		ResultSet rs;
		rs = st.executeQuery("SELECT * FROM Account WHERE userName = '" + username + "'");
		rs.next();
		int userID = rs.getInt("personID");
		
		st.executeUpdate("DELETE FROM Employee WHERE userID = " + userID);
		st.executeUpdate("DELETE FROM Account WHERE personID = " + userID);
		st.executeUpdate("DELETE FROM Person WHERE userID = " + userID);
		
		rs.close();
		st.close();
		conn.close();
		response.sendRedirect("removeCustomerService.jsp?deleted=" + username);
	%>
</body>
</html>