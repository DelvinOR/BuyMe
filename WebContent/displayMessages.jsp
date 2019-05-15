<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Question Center</title>
</head>
<body>
<%@page import="java.sql.*" %>

<%
if((session.getAttribute("user")== null)){
%>
	<a href="login.jsp">Log in</a><br>
	<a href="index.html">Homepage</a><br>
<%
}else{
%>
	<a href="logout.jsp">log out</a><br>
	<a href= "dashboard.jsp" > Homepage</a> <br>
<%
}
%>

<%
String id = request.getParameter("qID");

try {
Class.forName("com.mysql.jdbc.Driver");
} catch (ClassNotFoundException e) {
e.printStackTrace();
}

Connection conn = null;
Statement st = null;
Statement st1 = null;
ResultSet rs = null;
ResultSet rs1 = null;
%>


<%
	String search = request.getParameter("questionSearch");
	if (search == null) {
%>
		<h2><font><strong>Questions</strong></font>
<% 	}  else {  %>
		<h2><font><strong>Searching for '<%= search %>' </strong> <a style="font-size:" href="displayMessages.jsp">Clear search</a></font>
<%
	}
	String success = request.getParameter("success"); // if a message was posted, success is the title of new post
	if (success != null) {
%>
	<font style="font-size:15px; color:green; padding-left:25px;">Successfully posted new question <%= success %>!</font>
<% 	} %>	
</h2>	
<% if (session.getAttribute("user") != null)  {%>
	<form method="post" action="createMessage.jsp" style="display: inline;">
		<input type="submit" value="Post New Question">
	</form>
<% 	} %>
<form method="post" action="displayMessages.jsp" style="display: inline; padding-left:130px;">
	Find a Question or Answer: 
	<input type="text" name="questionSearch">
	<input type="submit" value="Search">
</form><br><br>
<table cellpadding="5" cellspacing="5" border="1" width="665">
<tr>

</tr>
<tr>
<td><b>QuestionID</b></td>
<td><b>Subject</b></td>
<td><b>From</b></td>
<td><b>Status</b></td>
<td><b>Link to Question</b></td>
</tr>
<%
try{ 
	conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db", "cs336", "cs336masterkey");
	st=conn.createStatement();
	st1=conn.createStatement();
	
	String query = "SELECT * FROM forum";
	if (search != null) {
		query += " WHERE subject LIKE '%" + search + "%' OR question LIKE '%" + search + "%' OR answer LIKE '%" + search +"%'";
	}
	
	rs = st.executeQuery(query);
	
	int qID;
	int actID;
	String user, subject, status;

	while(rs.next()){
		qID = rs.getInt(1);
		actID = rs.getInt(2);
		subject = rs.getString("subject");
		status = rs.getString("status");
		rs1 = st1.executeQuery("SELECT userName FROM Account WHERE actID = '"+actID+"'");
		user = (rs1.next()) ? rs1.getString(1) : " ";
%>
<tr>

<td><%=qID %></td>
<td><%=subject %></td>
<% if (user.equals(" ")) { %>
	<td> deleted </td>
<% } else { %>
	<td><a href="profile.jsp?user=<%= user %>"><%= user %></a></td>
<% } %>
<td><%= status %></td>
<td><a href=<%= "\"displayQuestion.jsp?Id=" + qID + "\"" %> >View</a>

</tr>

<% 
}
rs.close();
st.close();
if (rs1 != null) {
	rs1.close();
	st1.close();
} else {
%>	<td colspan="5">No results found.</td>
<% 
}
conn.close();
} catch (Exception e) {
e.printStackTrace();
}
%>
</table>
</body>
</html>
