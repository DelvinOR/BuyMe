<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<%
	String name = request.getParameter("user");
%>
<title>Auction Listing - <%=name%></title>
</head>
<body>
	<%@page import="java.sql.*" %>
	<%@ page import = "java.text.*" %>
	<%@ page import = "java.util.*" %>

	<%
		if ((session.getAttribute("user") == null)) {
	%>
	<a href="login.jsp">Log in</a>
	<br>
	<a href="index.html"> Homepage</a>
	<br>
	<%
		} else {
	%>
	<a href="logout.jsp">Log out</a>
	<br>
	<a href="dashboard.jsp"> Homepage</a>
	<br>
	<%
		}
	%>
	<br>
	<a href="displayItems.jsp"> Back to auction list</a>
	<br>

	<%
		String id = request.getParameter("Id");
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}

		Connection conn = null;
		Statement st = null;
		Statement st1 = null;
		Statement st2 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;
	%>

	<div width="480">
		<%
			try {
				conn = DriverManager
						.getConnection(
								"jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db",
								"cs336", "cs336masterkey");
				st = conn.createStatement();
				st1 = conn.createStatement();
				st2 = conn.createStatement();

				int auctionID = Integer.parseInt(request.getParameter("Id"));
				String itemName;
				String itemType;
				String description;

				rs = st.executeQuery("SELECT * FROM Auctions INNER JOIN Items ON Auctions.itemID = Items.ItemID WHERE Auctions.AuctionsID = "
						+ auctionID);
				rs.next();
				int itemID = rs.getInt("itemID");
				itemName = rs.getString("ItemName");
				itemType = rs.getString("ItemType");
				description = rs.getString("Description");
				java.sql.Date ClosingDate = rs.getDate("ClosingDate");
				java.sql.Time ClosingTime = rs.getTime("ClosingTime");
				
				
				rs1 = st1.executeQuery("SELECT * FROM Auctions WHERE itemID = '"
								+ itemID + "'");
				rs1.next();
				double price = rs1.getDouble("MinPrice");
				
				rs2 = st2.executeQuery("SELECT * FROM Auctions INNER JOIN Account ON Account.actID = Auctions.actID WHERE itemID = '"
						+ itemID + "'");

				String seller = (rs2.next()) ? rs2.getString("userName") : " ";
				
				java.sql.Date TodaysDate = new java.sql.Date(new java.util.Date().getTime());
				java.util.Date date = new java.util.Date();
				DateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");
			    String formattedDate= dateFormat.format(date);
			    try{
			    	date = dateFormat.parse(formattedDate);
			    }catch(ParseException e1){
			    	e1.printStackTrace();
			    }
				java.sql.Time CurrentTime = new java.sql.Time(date.getTime());
				long diffDate = ClosingDate.getTime()-TodaysDate.getTime();
				long diffTime = ClosingTime.getTime() - CurrentTime.getTime();
				long remaining = diffDate+diffTime;
		%>
		<h2>
			<font><strong>Auction #<%=id%> - <%=name%></strong></font>
		</h2>
		<p>
			Category: <%=itemType%>
			<br>Seller: 
			<%
				if (seller.equals(" ")) {
			%>
				deleted
			<% } else { %>
				<a href="profile.jsp?user=<%= seller %>"><%= seller %></a>
			<% } %>
			</p>
			
		<table cellpadding="5" cellspacing="5" border="1">
			<tr>
				<td>Current Bid:</td>
				<td>
					<%
						String currentBid = rs1.getString("InitialBid");
							if (currentBid != null) {
								out.print(currentBid);
							}
					%>
				</td>
				<td>
				<%
				if(remaining>0){
				%>
				<a
					href=<%="\"setNewBid.jsp?Id=" + id + "&Name=" + name + "\""%>>
						Bid</a>
				<%
				}else{
					out.print("EXPIRED");
				}
				%>
				</td>
				<td>
				<%if(remaining>0){
				
				%>
					<a href = <%="\"createAutoBid.jsp?Id=" + id + "&Name=" + name + "\""%>>Automatic Bid</a>
				<%
				}else{
					out.print("EXPIRED");
				}
				%>
				</td>
			</tr>
		</table>
		<p>
			Description:
			<%=description%></p>
	</div>
	<br>
	You might also like
	<br>
	<table cellpadding="5" cellspacing="5" border="1">
	
	<% 
	rs = st.executeQuery("SELECT* FROM Items INNER JOIN Auctions ON Items.ItemID = Auctions.itemID WHERE ItemType = '" + itemType +"' AND ItemName != '" + itemName+"'");
	
	while(rs.next()){
		itemName = rs.getString("ItemName");
		itemType = rs.getString("ItemType");
		description = rs.getString("Description");
		
	%>
	<tr>
			<td><a href=<%= "\"profile.jsp?user=" + seller + "\"" %>><%= seller %></a></td>
			<td><a
				href=<%= "\"displayAuction.jsp?Id=" + auctionID + "&user=" + itemName + "\"" %>><%= itemName %></a></td>
			<td><%= itemType %></td>
			<td><%= description %></td>
		</tr>
	<%	
	}
	%>	
	</table>
	
	<%
			rs.close();
			rs1.close();
			rs2.close();
			st.close();
			st1.close();
			st2.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	%>

</body>
</html>
