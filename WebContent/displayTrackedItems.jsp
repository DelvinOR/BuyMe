<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Auction List</title>
</head>
<body>
<%@page import="java.sql.*" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.*" %>

<%
if((session.getAttribute("user")== null)){
%>
	<a href="login.jsp">Log in</a>
	<br><a href= "index.html" > Homepage</a> <br>
<%
}else{
%>
	<a href="logout.jsp">Log out</a>
	<br><a href= "dashboard.jsp" > Homepage</a> <br>
<%
}
%>


<%
try {
Class.forName("com.mysql.jdbc.Driver");
} catch (ClassNotFoundException e) {
e.printStackTrace();
}
String username = (String)request.getParameter("user");
int actID = Integer.valueOf(request.getParameter("userID"));

Connection conn = null;
Statement st = null;
Statement st1 = null;
ResultSet rs = null;
ResultSet rs1 = null;

Statement st2 = null;
ResultSet rs2 = null;

Statement st3 = null;
ResultSet rs3 = null;

%>
<h2>List of your tracked items</h2>
<p>Click the seller's name to view their profile</p>
<p>Click the item's name to view the item</p>
<table cellpadding="5" cellspacing="5" border="1">
<tr>
<td><b>Item Name</b></td>
<td><b>Seller</b></td>
</tr>
<%
try{ 
conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db", "cs336", "cs336masterkey");
st=conn.createStatement();
st1=conn.createStatement();
st2=conn.createStatement();
st3=conn.createStatement();

rs = st.executeQuery("SELECT * FROM itemAlerts WHERE actID ='"+actID+"'");




while(rs.next()){
	int itemID=0;
	int sellerID=0;
	String sellerName="";
	String itemName="";
	itemID = rs.getInt("itemID");
	
	rs1 = st1.executeQuery("SELECT actID FROM Auctions WHERE itemID='"+itemID+"'");
	if(rs1.next()){
		sellerID = rs1.getInt("actID");
	}
	
	rs2 = st2.executeQuery("SELECT userName FROM Account WHERE actID='"+sellerID+"'");
	if(rs2.next()){
		sellerName=rs2.getString("userName");
	}
	
	rs3 = st3.executeQuery("SELECT ItemName FROM Items WHERE itemID='"+itemID+"'");
	if(rs3.next()){
		itemName=rs3.getString("ItemName");
	}
	
	
%>
<tr>

<td><a href=<%= "\"displayAuction.jsp?Id=" + itemID + "&user=" + itemName + "\"" %>><%= itemName %></a></td>
<td><a href=<%= "\"profile.jsp?user=" + sellerName + "\"" %>><%= sellerName %></a></td>

</tr>

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