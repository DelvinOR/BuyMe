<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%@page import="java.sql.*" %>

<%
if((session.getAttribute("user")== null)){
%>
	<a href="login.jsp">log in</a><br>
	<a href= "index.html" > Homepage</a> <br>
<%
}else{
%>
	<a href="logout.jsp">log out</a><br>
	<a href= "dashboard.jsp" > Homepage</a> <br>
<%
}
	String username = (String)session.getAttribute("user");
	if (username == null)
		username = " ";
%>

<%

try {

Class.forName("com.mysql.jdbc.Driver");
} catch (ClassNotFoundException e) {
e.printStackTrace();
}

Connection conn = null;
Statement st = null;
ResultSet rs = null;
Statement st1 = null;
ResultSet rs1 = null;
%>



<%
try{
	int qID;
	if(request.getParameter("Id")==null){
		qID = (Integer)session.getAttribute("Id");
	}else{
		qID = Integer.valueOf(request.getParameter("Id"));
	}
	
String answer = request.getParameter("answerInput");

String temp;
if (answer != null) {
	temp = answer;
	temp=temp.replaceAll(" ", "");
	if (temp.equals("")){
		answer = "";
	}
}	
int actID=0;
String user=" ";
String subject="";
String question="";
String status="";
String answerer=" ";

conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
st = conn.createStatement();

rs = st.executeQuery("SELECT * FROM forum WHERE qID = '" + qID + "'");
if(rs.next()){
	subject = rs.getString(3);
	question = rs.getString(4);
	status = rs.getString(5);
	actID = rs.getInt(2);
	if(rs.getString(6)!=null){
		answer=rs.getString(6);
	}
	if(rs.getString(7)!=null){
		answerer=rs.getString(7);
	}
}

rs = st.executeQuery("SELECT * FROM Account WHERE actID = '"+actID+"'");
if(rs.next()){
	user = rs.getString(3);
}

String permission = "u"; // u - user, c - customer service, a - admin

st1 = conn.createStatement();
rs1 = st1.executeQuery("SELECT * FROM Account WHERE userName = '" +  username + "'");

if (rs1.next()) {
	int userID = rs1.getInt("personID");
	rs1 = st1.executeQuery("SELECT * FROM Employee WHERE userID = '" +  userID + "'");
	if (rs1.next()){
		permission = rs1.getString("type");
	}
}




if(status.equals("unanswered")){
	if(session.getAttribute("user")==null || permission.equals("u")){
		
		%>
		<a href="displayMessages.jsp">Go back to forum</a>
		<h3>Subject: <%=subject %></h3>
		<% if (user.equals(" ")) { %>
			<p>From deleted user</p>
		<% } else { %>
			<p>From <a href="profile.jsp?user=<%= user %>"><%= user %></a></p>
		<% } %>
		<p>Status: <%=status %></p>
	    	<h1>Question: <%=question %> qID: <%=qID %></h1>
	    	<h2>Answer: Question hasn't been answered yet</h2>
	    <%
	}else{
		if(answer==null || answer.equals("")){
			
			session.setAttribute("Id",qID);
		%>
			<a href="displayMessages.jsp">Go back to forum</a>
			<h3>Subject: <%=subject %></h3>
			<p>From <%=user %></p>
			<p>Status: <%=status %></p>
		    	<h1>Question: <%=question %> qID: <%=qID %></h1>
		    	<form method = "post" action = "displayQuestion.jsp?Id<%=qID%>">
		
				<br>Answer:<br>
				<textarea name="answerInput" rows="5" cols="30" wrap="soft"> </textarea>
				<input type= "submit" value = "Answer"/>
		
			</form>
		
		
		
		<%
		}else{
			status="answered";
			PreparedStatement preparedStatement = conn.prepareStatement("UPDATE forum SET status=?,answer=?,answerer=? WHERE qID= '"+qID+"'");
			preparedStatement.setString(1,status);
			preparedStatement.setString(2,answer);
			preparedStatement.setString(3,username);
			preparedStatement.executeUpdate();
			preparedStatement.close();
			
		%>
			<a href="displayMessages.jsp">Go back to forum</a>
			<h3>Subject: <%=subject %></h3>
			<% if (user.equals(" ")) { %>
				<p>From deleted user</p>
			<% } else { %>
				<p>From <a href="profile.jsp?user=<%= user %>"><%= user %></a></p>
			<% } %>
			<p>Status: <%=status %></p>
		    	<h1>Question: <%=question %> qID: <%=qID %></h1>
		    	<h2>
		    	<% if (username.equals(" ")) { %>
					<p>From: Customer Rep.</p>
				<% } else { %>
					<p>From <a href="profile.jsp?user=<%= username %>"><%= username %></a></p>
				<% } %>
				</h2>
			<p><b>Answer: </b> <%=answer %></p>
		    
		<%
		}
	}
}else{
	
	%>
	<a href="displayMessages.jsp">Go back to forum</a>
	<h3>Subject: <%=subject %></h3>
	<% if (user.equals(" ")) { %>
		<p>From deleted user</p>
	<% } else { %>
		<p>From <a href="profile.jsp?user=<%= user %>"><%= user %></a></p>
	<% } %>
	<p>Status: <%=status %></p>
    	<h1>Question: <%=question %> qID: <%=qID %></h1>
    	<h2>
    	<% if (answerer.equals(" ")) { %>
			<p>From: Customer Rep.</p>
		<% } else { %>
			<p>From <a href="profile.jsp?user=<%= answerer %>"><%= answerer %></a></p>
		<% } %>
		</h2>
	<p><b>Answer: </b> <%=answer %></p>
    
<%

}

rs.close();
rs1.close();
st.close();
st1.close();
conn.close();
} catch (Exception e) {
e.printStackTrace();
}
%>

</body>
</html>
