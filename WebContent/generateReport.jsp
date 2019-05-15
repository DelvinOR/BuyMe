<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>User Search</title>
</head>
<body>
	<%@ page import = "java.sql.*" %>
	<h1>User search</h1>
	<%
		String query = request.getParameter("filter");
		String source = request.getParameter("src");
	%>
		<a href="controlPanel.jsp">Return to Control Panel</a>
		<table style="border: 2px solid #666666;">
		<tr>
			<% if (query.equals("Total Earnings")) { %>
				<th>Total Earnings</th>
			<% } else if (query.equals("Earnings per item")) { %>
				<th>Item</th>
				<th>Earnings</th>
			<% } else if (query.equals("Earnings per item type")) { %>
				<th>Item type</th>
				<th>Earnings</th>
			<% } else if (query.equals("Earnings per user")) { %>
				<th>User</th>
				<th>Earnings</th>
			<% } else if (query.equals("Earnings per user")) { %>
				<th>Best selling items</th>
			<% } else if (query.equals("Best buyers")) { %>
				<th>Best buyers</th>
			<% } %>
		</tr>
		<%
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
			Statement st = conn.createStatement();
			ResultSet rs;
			Statement st1 = conn.createStatement();
			ResultSet rs1;
			Statement st2 = conn.createStatement();
			ResultSet rs2;
			
			if (query.equals("Total Earnings")) {
				rs = st.executeQuery("SELECT * FROM Account");
				
				double earnings = 0D;
				while (rs.next()) {
					int actID = rs.getInt("actID");
					
					rs1 = st1.executeQuery("SELECT * FROM Auctions WHERE actID = " + actID);
					while (rs1.next()) { 
						int auctionID = rs1.getInt("AuctionsID");
						
						rs2 = st2.executeQuery("SELECT * FROM AuctionHistory INNER JOIN Bid ON AuctionHistory.bidID = Bid.bidID WHERE auctionID = " + auctionID + " ORDER BY bidAmt DESC");
						if (rs2.next()) {
							double amt = rs2.getDouble("bidAmt");
							earnings += amt;
						}
					}
					//rs2.close();
					//st2.close();
				}
				//rs1.close();
				//st1.close();
		%>
		<tr style="border: 2px solid #666666;">
			<td><%= earnings %></td>
		</tr>
	<% 	}
			if (query.equals("Earnings per item")) {
				rs = st.executeQuery("SELECT * FROM Items INNER JOIN Auctions ON Items.ItemID = Auctions.itemID");
				
				while (rs.next()) {
					double earnings = 0;
					int auctionID = rs.getInt("AuctionsID");
					String itemName = rs.getString("ItemName");
					rs1 = st1.executeQuery("SELECT * FROM AuctionHistory INNER JOIN Bid ON AuctionHistory.bidID = Bid.bidID WHERE auctionID = " + auctionID + " ORDER BY bidAmt DESC");
					if (rs1.next()) {
						double amt = rs1.getDouble("bidAmt");
						earnings += amt;
					}
					%>
					<tr style="border: 2px solid #666666;">
						<td><%= itemName %></td>
						<td><%= earnings %></td>
					</tr>
					<% 
				}	
			}
			if (query.equals("Earnings per item type")) {
				rs = st.executeQuery("SELECT DISTINCT(ItemType) FROM Items");
				
				while (rs.next()) {
					String itemType = rs.getString("ItemType");
					rs1 = st1.executeQuery("SELECT * FROM Items INNER JOIN Auctions ON Items.ItemID = Auctions.itemID WHERE Items.ItemType = '" + itemType + "'");
					while (rs1.next()) {
						double earnings = 0;
						int auctionID = rs1.getInt("AuctionsID");
						String itemName = rs1.getString("ItemName");
						rs2 = st2.executeQuery("SELECT * FROM AuctionHistory INNER JOIN Bid ON AuctionHistory.bidID = Bid.bidID WHERE auctionID = " + auctionID + " ORDER BY bidAmt DESC");
						if (rs2.next()) {
							double amt = rs2.getDouble("bidAmt");
							earnings += amt;
						}
						%>
						<tr style="border: 2px solid #666666;">
							<td><%= itemType %></td>
							<td><%= earnings %></td>
						</tr>
						<% 
					}
				}	
			}
			if (query.equals("Earnings per user")) {
				rs = st.executeQuery("SELECT * FROM Account");
				
				while (rs.next()) {
					String username = rs.getString("userName");
					int actID = rs.getInt("actID");
					rs1 = st1.executeQuery("SELECT * FROM Items INNER JOIN Auctions ON Items.ItemID = Auctions.itemID WHERE Auctions.actID = " + actID);
					while (rs1.next()) {
						double earnings = 0;
						int auctionID = rs1.getInt("AuctionsID");
						rs2 = st2.executeQuery("SELECT * FROM AuctionHistory INNER JOIN Bid ON AuctionHistory.bidID = Bid.bidID WHERE auctionID = " + auctionID + " ORDER BY bidAmt DESC");
						if (rs2.next()) {
							double amt = rs2.getDouble("bidAmt");
							earnings += amt;
						}
						%>
						<tr style="border: 2px solid #666666;">
							<td><%= username %></td>
							<td><%= earnings %></td>
						</tr>
						<% 
					}
				}	
			}
			if (query.equals("Best selling items")) {
				rs = st.executeQuery("SELECT DISTINCT(ItemName) FROM Items");
				
				while (rs.next()) {
					String itemName = rs.getString("ItemName");
					rs1 = st1.executeQuery("SELECT * FROM Items INNER JOIN Auctions ON Items.ItemID = Auctions.itemID WHERE Items.ItemName = '" + itemName + "'");
					while (rs1.next()) {
						double earnings = 0;
						int auctionID = rs1.getInt("AuctionsID");
						rs2 = st2.executeQuery("SELECT * FROM AuctionHistory INNER JOIN Bid ON AuctionHistory.bidID = Bid.bidID WHERE auctionID = " + auctionID + " ORDER BY bidAmt DESC");
						while (rs2.next()) {
							double amt = rs2.getDouble("bidAmt");
							earnings += amt;
						}
						if (earnings > 0) {%>
						<tr style="border: 2px solid #666666;">
							<td><%= itemName %></td>
						</tr>
						<% }
					}
				}	
			}
			if (query.equals("Best buyers")) {
				rs = st.executeQuery("SELECT * FROM Account");
				
				while (rs.next()) {
					String username = rs.getString("userName");
					int actID = rs.getInt("actID");
					rs1 = st1.executeQuery("SELECT * FROM Items INNER JOIN Auctions ON Items.ItemID = Auctions.itemID WHERE Auctions.actID = " + actID);
					while (rs1.next()) {
						double earnings = 0;
						int auctionID = rs1.getInt("AuctionsID");
						rs2 = st2.executeQuery("SELECT * FROM AuctionHistory INNER JOIN Bid ON AuctionHistory.bidID = Bid.bidID WHERE auctionID = " + auctionID + " ORDER BY bidAmt DESC");
						while (rs2.next()) {
							int bidderID = rs2.getInt("actID");
							if (actID == bidderID) {
								double amt = rs2.getDouble("bidAmt");
								earnings += amt;
							}
						}
						if (earnings > 0) {%>
						<tr style="border: 2px solid #666666;">
							<td><%= username %></td>
						</tr>
						<% }
					}
				}	
			}
			%>
	</table>
	<% 			
		//if (rs != null) {
		//	rs.close();
		//	st.close();
		//}
		conn.close(); 
	%>
</body>
</html>