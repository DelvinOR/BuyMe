<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<% String name = request.getParameter("Name"); %>
<title>Auction Listing - <%=name%></title>

</head>
<body>
<%@page import="java.sql.*"%>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.Date" %>
<%
if(session.getAttribute("user")==null){
	response.sendRedirect("login.jsp");
}else{
	int id = Integer.parseInt(request.getParameter("Id"));
%>
	<a href="logout.jsp">Log out</a><br>
	<a href= "index2.html" > Homepage</a> <br>
	<br><a href= "displayItems.jsp" > Back to auction list</a><br>

	<div width="480">
	<h2>
		<font><strong>Auction #<%= id %> - <%= name %></strong></font>
	</h2>
	<br>
<% 
	String error = request.getParameter("error");
	if (error != null ) {
		if (error.equals("low")) { %>
			<font style="font-size:15px; color:red;">Your bid is too low.</font>	
<% 		}
	}

	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
	Statement st = conn.createStatement();
	Statement st1 = conn.createStatement();
	ResultSet rs, rs1;
	rs = st.executeQuery("SELECT * FROM Auctions WHERE AuctionsID = " + id);
	rs.next();
	double initialPrice = rs.getDouble("InitialBid");
	double bidIncrement = rs.getDouble("BidIncrement");
	String strDate = rs.getString("ClosingDate");
	Date closingDate = new SimpleDateFormat("yyyy-MM-dd").parse(strDate);
	rs = st.executeQuery("SELECT MAX(bidAmt) AS MaxBid FROM Bid INNER JOIN AuctionHistory ON AuctionHistory.bidID = Bid.bidID WHERE auctionID = " + id);
	double defaultBid = initialPrice;
	if (rs.next()) {
		double maxBid = rs.getDouble("MaxBid");
		if (rs.getString("MaxBid") != null) 
			defaultBid = maxBid + bidIncrement;
	}
	rs = st.executeQuery("SELECT * FROM AuctionHistory INNER JOIN Bid ON AuctionHistory.bidID = Bid.bidID WHERE auctionID = " + id);
%>
	<table style="border-collapse: collapse; border: 1px solid black;">
	<tr><th style="border-collapse: collapse; border: 1px solid black;">Bidder</th><th style="border-collapse: collapse; border: 1px solid black;">Amount</th></tr>
	<tr><td style="border-collapse: collapse; border: 1px solid black; text-align:center;">-</td><td style="border-collapse: collapse; border: 1px solid black; text-align:center;"><%= initialPrice %></td><th>
<% 
	while (rs.next()) {
		int actID = rs.getInt("actID");
		rs1 = st1.executeQuery("SELECT * FROM Account WHERE actID = " + actID);
		rs1.next();
		String bidder = rs1.getString("userName");
		double bid = rs.getDouble("bidAmt");
%>
		<tr><td style="border-collapse: collapse; border: 1px solid black; text-align:center;"><%= bidder %></td><td style="border-collapse: collapse; border: 1px solid black; text-align:center;"><%= bid %></td></tr>
<%
	}
%>
	</table>
	
	<form method="post" action=<%="\"createBid.jsp?Id=" + id + "&Name=" + name + "\""%>>
		Bid amount: 
		<input type="text" name="newCurrentBid" value=<%= defaultBid %> /> 
		<input type="submit" name="submit" value="Bid" />
	</form>


		<%
	}
		%>
	</div>
</body>
</html>