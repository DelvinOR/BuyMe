<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Web Page</title>
</head>
<body>
	<form method="post" action="addPost.jsp">
		<table>
			<tr>
				<td>Item Name:</td>
				<td><input type="text" name="ItemName" /></td>
			</tr>
			<tr>
				<td>Item Type:</td>
				<td><input type="text" name="ItemType" /></td>
			</tr>
			<tr>
				<td>Description:</td>
				<td><input type="text" name="Description" /></td>
			</tr>
			<tr>
				<td>Price:</td>
				<td><input type="number" name="Price"
					onchange="setTwoNumberDecimal" min="0" step="0.01" value="0.00" /></td>
			</tr>
			<!-- took out date and time because it was not working  -->
			<tr>
				<td>Closing Date:</td>
				<td> <input type = "date" id = "start" name = "ClosingDate" value = "2019-04-14" min = "2019-04-14" max = "2019-12-31"/></td>
				<td>(Please use same format)</td>
			</tr>
			<tr>
				<td>ClosingTime:</td>
				<td><input type = "time" name = "ClosingTime" value = "00:00:00"/></td>
				<td>(Please use same format)</td>
			</tr>
			<tr>
				<td><input type="submit" name="post" value="Post Item" /></td>
				<td><a href="dashboard.jsp">Cancel</a></td>
			</tr>
		</table>
	</form>
	<br>
</body>
</html>