<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Simple Web App</title>
</head>
<body>
<%@ page import = "java.sql.*"  %>

<%
String userName = (String) session.getAttribute("user");

Class.forName("com.mysql.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
Statement st = conn.createStatement();
ResultSet rs;
rs = st.executeQuery("SELECT personID FROM Account WHERE userName = '" + userName + "'");
int personID = -1;
if(rs.next()){//it returned the personID
	personID = rs.getInt(1);
}
rs.close();
st.executeUpdate("DELETE FROM Account WHERE userName = '" + userName + "'");
st.executeUpdate("DELETE FROM Person WHERE userID = " + personID);
st.close();
conn.close();

session.invalidate();
response.sendRedirect("index.html");

%>
</body>
</html>