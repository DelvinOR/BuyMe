<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>trackItem</title>
</head>
<body>
<%@ page import = "java.sql.*" %>
<%
Connection conn = null;
Statement st = null;


Class.forName("com.mysql.jdbc.Driver");
conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
int actID = 0;
int itemID = 0;
st=conn.createStatement();
actID = Integer.valueOf(request.getParameter("userId"));
itemID = Integer.valueOf(request.getParameter("Id"));
st.executeUpdate("DELETE FROM itemAlerts WHERE actID = '"+actID+"' AND itemID = '"+itemID+"'");
%>
<p>You've successfully deleted the tracker!</p>
<a href="dashboard.jsp">Homepage</a>
<%
st.close();
conn.close();

%>

</body>
</html>