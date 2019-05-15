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
String id = request.getParameter("ItemID");

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

Statement st2 = null;
ResultSet rs2 = null;

Statement st3 = null;
ResultSet rs3 = null;

%>
<form method = "post" action = "displayItems.jsp?">

<br>Search: 
<input type = "search" name = "searchInput" placeholder = "Example: Dinosaur, car, ugly"/>
<input type = "radio" name="filter" value="Item Names" checked/> Name 
<input type = "radio" name="filter" value="Item Types"/> Type
<input type = "radio" name="filter" value="Item Descriptions"/> Description 
<input type= "submit" value = "Search Items"/>

</form>
<%
String filterSetting = request.getParameter("filter");
String order = request.getParameter("order");
if (order == null) {
	order = "asc";
} else {
	order = (order.equals("asc") ? "desc" : "asc");
}

String search = (String)session.getAttribute("search");
if(search==null){
	search=request.getParameter("searchInput");
}
if(request.getParameter("searchInput")!=null){
	search=request.getParameter("searchInput");
}
session.setAttribute("search", search);
if (search != null) {
	String temp = search;
	temp.replaceAll("\\s+", "");
	if (temp.equals(""))
		search = "";
}	
%>

<% if (search == null || search.equals("") || filterSetting == null) {%>
	<h2><font><strong>Items for Sale</strong></font></h2>
<% } else { %>
	<h2><font><strong>Searching <%= filterSetting %> for "<%= search %>"</strong></font> <font size="-1"><a href="displayItems.jsp">Clear search</a></font></h2> 
<% } %>
<h4>&#x2B0D; Order by: <a href="displayItems.jsp?order=<%= order %>&ordering=Seller&search">Seller</a> | <a href="displayItems.jsp?order=<%= order %>&ordering=ItemName&search">ItemName</a> | <a href="displayItems.jsp?order=<%= order %>&ordering=ItemType&search">ItemType</a> | <a href="displayItems.jsp?order=<%= order %>&ordering=Time&search">Time Left</a></h4>
<table cellpadding="5" cellspacing="5" border="1">
<tr>

</tr>
<tr>
<td><b>Seller</b></td>
<td><b>ItemName</b></td>
<td><b>ItemType</b></td>
<td><b>Description</b></td>
<td><b>Current Bid</b></td>
<td><b>Highest Bidder</b></td>
<td><b>Time Remaining</b></td>
<%
if(session.getAttribute("user")!=null){
	%>
	<td><b>Interested?</b></td>
	<%
}

%>
</tr>
<%
try{ 
conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db", "cs336", "cs336masterkey");
st=conn.createStatement();
st1=conn.createStatement();


String ordering = request.getParameter("ordering");
String itemQuery = "SELECT * FROM Items INNER JOIN Auctions ON Items.ItemID = Auctions.itemID INNER JOIN Account ON Auctions.actID = Account.actID";
if (search != null && filterSetting != null) {
	if (filterSetting.equals("Item Names"))
		itemQuery += " WHERE ItemName LIKE '%" + search + "%'";
	else if (filterSetting.equals("Item Types"))
		itemQuery += " WHERE ItemType LIKE '%" + search + "%'";
	else if (filterSetting.equals("Item Descriptions"))
		itemQuery += " WHERE Description LIKE '%" + search + "%'";
}

if (ordering != null) {
	if (ordering.equals("Seller")) {
		itemQuery += " ORDER BY userName";
	} else 	if (ordering.equals("ItemType")) {
		itemQuery += " ORDER BY ItemType";
	} else 	if (ordering.equals("ItemName")) {
		itemQuery += " ORDER BY ItemName";
	}
	
	if (ordering.equals("Time")) {
		if (order.equals("asc"))
			itemQuery += " ORDER BY ClosingDate ASC, ClosingTime ASC";
		else
			itemQuery += " ORDER BY ClosingDate DESC, ClosingTime DESC";
	} else {
		if (order.equals("asc"))
			itemQuery += " ASC";
		else
			itemQuery += " DESC";	
	}
}

rs = st.executeQuery(itemQuery);

int itemID;
String seller;
String itemName;
String itemType;
String description;
double minBid = 0;
double maxBid = 0;
int auctionID = 0;
String highestBidder = "No bidders.";

String username = (String)session.getAttribute("user");
String interest = "no";
int actID=0;
st2 = conn.createStatement();
rs2 = st2.executeQuery("SELECT actID FROM Account WHERE username='"+username+"'");
if(rs2.next()){
	actID = rs2.getInt(1);
}

while(rs.next()){
	itemID = rs.getInt(1);
	seller = rs.getString("username");
	itemName = rs.getString("ItemName");
	itemType = rs.getString("ItemType");
	description = rs.getString("Description");
	minBid = rs.getDouble("MinPrice");
	auctionID = rs.getInt("AuctionsID");
	java.sql.Date ClosingDate = rs.getDate("ClosingDate");
	java.sql.Time ClosingTime = rs.getTime("ClosingTime");
	
	rs2 = st2.executeQuery("SELECT * FROM AuctionHistory INNER JOIN Bid ON AuctionHistory.bidID = Bid.bidID WHERE auctionID = " + auctionID + " ORDER BY bidAmt DESC");
	String bid = "No bids.";
	int bidderID = 0;
	if (rs2.next()) {
		maxBid = rs2.getDouble("bidAmt");
		bid = Double.toString(maxBid);
		bidderID = rs2.getInt("actID");
	} else {
		highestBidder = "No bidders.";
	}
	
	//rs2 = st2.executeQuery("SELECT * FROM AuctionHistory INNER JOIN Bid ON AuctionHistory.bidID = Bid.bidID WHERE auctionID = " + auctionID + " AND bidAmt = " + maxBid);
	//rs2.next();
	if (!bid.equals("No bids.")) {
		//int bidderID = rs2.getString("")
		rs2 = st2.executeQuery("SELECT * FROM Account WHERE actID = " + bidderID);
		rs2.next();
		highestBidder = rs2.getString("userName");
	} 
	java.sql.Date TodaysDate = new java.sql.Date(new java.util.Date().getTime());//Today's date
	java.util.Date date = new java.util.Date();
	DateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");
    String formattedDate= dateFormat.format(date);
    try{
    	date = dateFormat.parse(formattedDate);
    }catch(ParseException e1){
    	e1.printStackTrace();
    }
	java.sql.Time CurrentTime = new java.sql.Time(date.getTime()); //Seems to be current time but have not tested it
	long diffDate = ClosingDate.getTime()-TodaysDate.getTime();
	long diffTime = ClosingTime.getTime() - CurrentTime.getTime();
	long remaining = diffDate+diffTime;
	long hoursRemaining = remaining /(1000*60*60);
	long minutesRemaining = remaining/(1000*60)%60;
	long secondsRemaining = remaining/(1000) %60;
	
%>
<tr>

<td><a href=<%= "\"profile.jsp?user=" + seller + "\"" %>><%= seller %></a></td>
<td><a href=<%= "\"displayAuction.jsp?Id=" + auctionID + "&user=" + itemName + "\"" %>><%= itemName %></a></td>
<td><%= itemType %></td>
<td><%= description %></td>
<td><%=bid %></td>
<td><%= highestBidder %></td>
<td><% if(remaining>0){
	out.print(hoursRemaining + ":" + minutesRemaining + ":" + secondsRemaining);
}else{
	out.print("EXPIRED");
}

%></td>
	
<%
if(session.getAttribute("user")!=null){
%>
<td>
<% 
	st3 = conn.createStatement();
	rs3 = st3.executeQuery("SELECT * FROM itemAlerts WHERE actID='"+actID+"' AND itemID='"+itemID+"'");
	if(rs3.next()){
	%>
		yes
	<%
	}else{
	%>
		no
	<%
		session.setAttribute("actID",actID);
		session.setAttribute("itemID",itemID);
	%>
		<a href=<%= "\"trackItem.jsp?itemID=" + itemID + "&actID=" + actID + "\"" %>> Track?</a>
	<%
	}
%>
</td>
<%
}
%>	
	
</tr>
	
<% 
}
if (rs != null) { 
	rs.close();
	st.close();
} else {
	%>
	<td colspan="5">No results found.</td>
	<% 
}
rs.close();
rs1.close();
rs2.close();
st1.close();
st2.close();
st3.close();
conn.close();
} catch (Exception e) {
e.printStackTrace();
}
%>
</table>
</body>
</html>
