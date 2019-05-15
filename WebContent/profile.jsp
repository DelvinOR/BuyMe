<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<% String profileUsername = request.getParameter("user"); %>
<title><%= profileUsername %>'s Profile</title>
</head>
<body>
	<%@ page import = "java.sql.*" %>
	<%
		String viewerUsername = (String)session.getAttribute("user");
		String editMode = request.getParameter("edit");
		if (profileUsername == null) 
			response.sendRedirect("index.html");
	
		String profilePermission = "u"; // u - user, c - customer service, a - admin
		String viewerPermission = "u";
		String firstName = "John/Jane";
		String lastName = "Smith/Doe";
		String address = "No address found.";
		String email = "No email found.";
		int actID = 0;
	
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
		Statement st = conn.createStatement();
		Statement st1 = conn.createStatement();
		ResultSet rs;
		ResultSet rs1;
		rs = st.executeQuery("SELECT * FROM Account INNER JOIN Person ON Account.personID = Person.userID WHERE userName = '" +  profileUsername + "'");
		rs1 = st1.executeQuery("SELECT * FROM Account INNER JOIN Employee ON Account.personID = Employee.userID WHERE userName = '" +  viewerUsername + "'");
		
		if (rs.next()) {
			int personID = rs.getInt("personID");
			actID = rs.getInt("actID");
			address = rs.getString("address");
			email = rs.getString("email"); 
			firstName = rs.getString("firstName");
			if (firstName != null)
				firstName = firstName.substring(0, 1).toUpperCase() + firstName.substring(1);
			lastName = rs.getString("lastName");
			if (lastName != null)
				lastName = lastName.substring(0, 1).toUpperCase() + lastName.substring(1);
			rs = st.executeQuery("SELECT * FROM Employee WHERE userID = '" +  personID + "'");
			if (rs.next())
				profilePermission = rs.getString("type");
		}
		if (rs1.next()) {
			int userID = rs1.getInt("userID");
			viewerPermission = rs1.getString("type");
		}
	%>
	<div style="width:800px;">
		<div style="width:300px; float:left;">
			<% 
				String title = "User";
				if (profilePermission != null)
					if (profilePermission.equals("a")) 
						title = "Admin";
					else if (profilePermission.equals("c"))
						title = "Customer Rep.";
			%>
			<font style="font-size:30px; font-weight:bold;'"> <%= profileUsername %> </font>   <font style="font-size:17px; font-style:italic; border: 2px solid #666666; position:relative; top:-3px; padding:2px;"><%= title %></font>
			<br><font style="font-size:20px;"><%= firstName %> <%= lastName %></font>
			<br><font style="font-size:20px;">Address: <%= address %> </font>
			<br><font style="font-size:20px;">Email: <%= email %> </font>
		</div>
		<div style="width:300px; float:right;">
			<p><a href="dashboard.jsp">Homepage</a></p> 
			<% if (!viewerPermission.equals("u")) { %>
				<br><a href="editAccount.jsp?user=<%= profileUsername %>"> Edit Account Info</a>
			<% } %>
		</div>
		<br>
		<div style="clear:both;"></div>
		<div style="width:750px; height:auto; text-align: center; border: 1px solid #666666; overflow:auto;">
			<div style="width:300px; float:left;">
				<p>Auctions Bid On</p>
				<table width="300" style="border-collapse: collapse; border: 1px solid black;">
				<th style="border-collapse: collapse; border: 1px solid black;">Auction Posting </th><th style="border-collapse: collapse; border: 1px solid black;">Item</th>
				<%
				Class.forName("com.mysql.jdbc.Driver");
				conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
				st = conn.createStatement();
				//we have actID
				rs1 = st1.executeQuery("SELECT DISTINCT auctionID FROM AuctionHistory INNER JOIN Account ON AuctionHistory.actID = Account.actID WHERE Account.actID = '"+ actID + "'");
				//rs1 gives distinct auctionID that actID has participated in
				if (!rs1.next()) {
					%> <tr><td colspan="2">No auctions found.</td></tr> <% 
				} else {
					rs1.beforeFirst();
				}
				int auctionID = 0;
				int bidderID = 0;
				while(rs1.next()){
					auctionID = rs1.getInt("auctionID");
					rs = st.executeQuery("SELECT * FROM Auctions INNER JOIN Items ON Items.ItemID = Auctions.itemID WHERE  AuctionsID= '" + auctionID + "'");
					rs.next();
					int itemID = rs.getInt("ItemID");
					String itemName = rs.getString("ItemName");
					String itemType = rs.getString("ItemType");
					rs = st.executeQuery("SELECT * FROM AuctionHistory INNER JOIN Bid ON AuctionHistory.bidID = Bid.bidID WHERE auctionID = " + auctionID + " ORDER BY bidAmt DESC");
					rs.next();
					bidderID = rs.getInt("actID");
					if(bidderID == actID){//this user has the highest bid in that auctionID
						%>
					<tr><td style="border-collapse: collapse; border: 1px solid black;"><a href="displayAuction.jsp?Id=<%= itemID %>&user=<%= itemName %>"><%= itemName %></a></td>
					<td style="border-collapse: collapse; border: 1px solid black;"><%= itemType %></td></tr>
				<%
					}
				}
				%>
				</table>
				
			</div>
			<div style="width:300px; float:right; padding: 20px;">
				<p>Auctions Posted</p>
				<table width="300" style="border-collapse: collapse; border: 1px solid black;">
					<th style="border-collapse: collapse; border: 1px solid black;">Auction Posting</th><th style="border-collapse: collapse; border: 1px solid black;">Item</th>
				<%
				rs = st.executeQuery("SELECT * FROM Auctions INNER JOIN Items ON Items.ItemID = Auctions.itemID WHERE actID = '" + actID + "'");
				if (!rs.next()) {
					%> <tr><td colspan="2">No auctions found.</td></tr> <% 
				} else {
					rs.beforeFirst();
				}
				while (rs.next()) {
					int itemID = rs.getInt("ItemID");
					String itemName = rs.getString("ItemName");
					String itemType = rs.getString("ItemType");
					%>
					<tr><td style="border-collapse: collapse; border: 1px solid black;"><a href="displayAuction.jsp?Id=<%= itemID %>&user=<%= itemName %>"><%= itemName %></a></td>
					<td style="border-collapse: collapse; border: 1px solid black;"><%= itemType %></td></tr>
				<% }
				rs1.close();
				st1.close();
				rs.close();
				st.close();
				conn.close();
				%>
				</table>
			</div>
		</div>
	</div>
</body>
</html>