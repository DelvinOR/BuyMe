<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Post New Question</title>
</head>
<body>
<form method="post" action="addMessage.jsp">
		<table>
			<tr>
				<td>Subject:</td>
				<td><input type="text" name="subject" /></td>
			</tr>
			<tr>
				<td>Question:</td>
				<td><input type="text" name="question" /></td>
			</tr>
			<tr>
				<td><input type="submit" name="post" value="Post" /></td>
				<td><a href="dashboard.jsp">Cancel</a></td>
			</tr>
		</table>
	</form>
	<br>

</body>
</html>