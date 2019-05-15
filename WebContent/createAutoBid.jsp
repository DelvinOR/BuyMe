<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String name = request.getParameter("Name");
%>
<title>Auction Listing - <%=name%></title>
</head>
<body>

<%
if(session.getAttribute("user")==null){
%>
PLease log in:

<a href ="login.jsp">Sign In</a> <br>
Don't have an account?

<a href = "createUser.jsp">Sign up</a>
<%
}else{
	String id = request.getParameter("Id");
%>
	<a href="logout.jsp">Log out</a><br>
	<a href= "index2.html" > Homepage</a> <br>
	<br><a href= "displayItems.jsp" > Back to auction list</a><br>

	<div width="480">
		<h2>
			<font><strong>Auction #<%= id %> - <%= name %></strong></font>
		</h2>
		<br>

		<form method="post" action=<%="\"addAutoBid.jsp?Id=" + id + "&Name=" + name + "\""%>>
		Upper limit: 
		<input type = "text" name = "upperLimit" placeholder = "Example: 10.00"/>
		<input type = "submit" name = "submit" value = "Bid"/>
		</form>
<%
}
%>
</div>

</body>
</html>