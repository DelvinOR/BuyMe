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
ResultSet rs = null;

Class.forName("com.mysql.jdbc.Driver");
conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");


int actID = 0;
int itemID = 0;
actID = Integer.valueOf(request.getParameter("actID"));
itemID = Integer.valueOf(request.getParameter("itemID"));

st = conn.createStatement();

rs = st.executeQuery("SELECT * FROM itemAlerts WHERE actID='"+actID+"' AND itemID='"+itemID+"'");

if(rs.next()){
	out.println("error check: clicking track should not direct you here, if column says no then row shouldn't exist in any scenario");
}else{
	PreparedStatement preparedStatement = conn.prepareStatement("INSERT INTO itemAlerts(actID,itemID) VALUES (?,?)");
	preparedStatement.setInt(1, actID);
	preparedStatement.setInt(2, itemID);
	preparedStatement.executeUpdate();
	%>
	<p>You've successfully tracked your item!</p><br>
	<a href="displayItems.jsp">Return to list of items</a>
	<%
}
rs.close();
st.close();
conn.close();

%>

</body>
</html>