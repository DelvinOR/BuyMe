<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.*" %>

<%
if((session.getAttribute("user")== null)){
%>
	<a href="login.jsp"> Please log in</a>
<%

}else{
	
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
	Statement st = conn.createStatement();
	int actID=0;
	String user = (String) session.getAttribute("user");
	
	ResultSet rs0 = st.executeQuery("SELECT actID FROM Account WHERE userName = '" + user+ "'");
	if(rs0.next()){
		actID = rs0.getInt(1);
	}
	rs0.close();
	int qID;
	String subject = request.getParameter("subject");
	String question = request.getParameter("question");
	String status = "unanswered";
	
	ResultSet rs = st.executeQuery("SELECT MAX(qID) FROM forum");
	qID = -1;
	if(rs.next()){
		qID = rs.getInt(1);
	}
	rs.close();
	st.close();
	
	PreparedStatement preparedStatement;
	
	preparedStatement = conn.prepareStatement("INSERT INTO forum (qID,actID, subject, question, status) VALUES (?,?,?,?,?)");
	preparedStatement.setInt(1, 0);
	preparedStatement.setInt(2, actID);
	preparedStatement.setString(3, subject);
	preparedStatement.setString(4, question);
	preparedStatement.setString(5, status);
	preparedStatement.executeUpdate();
	
	response.sendRedirect("displayMessages.jsp?success=" + subject);
	
	preparedStatement.close();
	conn.close();
}
%>

</body>
</html>
