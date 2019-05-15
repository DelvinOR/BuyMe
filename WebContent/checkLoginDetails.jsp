<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Simple Login Web page</title>
</head>
<body>
<%@ page import = "java.sql.*"  %>

<%
String userID = request.getParameter("username").toLowerCase();
String pwd = request.getParameter("password");
Class.forName("com.mysql.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
Statement st = conn.createStatement();
ResultSet rs;
rs = st.executeQuery("SELECT * FROM Account WHERE userName = '" + userID+ "' AND password = '" + pwd + "'");
if(rs.next()){
	session.setAttribute("user", userID);//username is now stored in session
	out.println("Welcome " + userID);
	out.println("<a href='dashboard.jsp'>Homepage</a>");
	out.println("<a href='logout.jsp'>Log out</a>");
	rs.close();
	st.close();
	conn.close();
	response.sendRedirect("dashboard.jsp");
}else{
	response.sendRedirect("login.jsp?error=login");
}
rs.close();
st.close();
conn.close();
%>

</body>
</html>