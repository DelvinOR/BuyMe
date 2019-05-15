<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sample Login Web Page</title>
</head>
<body>
<%
if((session.getAttribute("user")== null)){
%>
You are not logged in<br>
<a href="login.jsp"> Please log in</a>
<%}else{
%>
Welcome <%=session.getAttribute("user")%> <br><!--this displays the username stored in session -->
<a href = "displayItems.jsp">Buy</a> <br>
<a href = "createPost.jsp"> Post</a> <br>
<a href= "logout.jsp" > Log out</a> <br>
<a href="createMessage.jsp"> Post question</a> <br>
<a href = "deleteAccount.jsp"> Deactivate Account</a>
<%
	}
%>
</body>
</html>