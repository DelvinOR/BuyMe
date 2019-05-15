<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
<%@page import="java.sql.*" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.*" %>

<%
	String userName = (String) session.getAttribute("user");
	String id = request.getParameter("Id");
	String name = request.getParameter("Name");
	
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

try{
	conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db", "cs336", "cs336masterkey");
	st=conn.createStatement();
	st1=conn.createStatement();
	int auctionID = Integer.parseInt(id);
	
	//with itemID we can get AuctionsID
	rs = st.executeQuery("SELECT * FROM Auctions WHERE AuctionsID = '" + auctionID +  "'");
	rs.next();
	
	int itemID = rs.getInt("itemID");
	double initialBid = rs.getDouble("InitialBid");
	double bidIncrement = rs.getDouble("BidIncrement");
	double newCurrentBid = Double.parseDouble(request.getParameter("newCurrentBid"));
	
	rs = st.executeQuery("SELECT MAX(bidAmt) AS MaxBid FROM AuctionHistory INNER JOIN Bid ON AuctionHistory.bidID = Bid.bidID WHERE auctionID = '" + auctionID +  "'");
	
	double minBid = initialBid;
	if (rs.next()) {
		double maxBid = rs.getDouble("MaxBid");
		if (rs.getString("MaxBid") != null && maxBid != 0.0D) 
			minBid = maxBid + bidIncrement;
	}
	
	if(newCurrentBid >= minBid){
		//double newCurrentBid = rs.getDouble("InitialBid") + rs.getDouble("BidIncrement");
		//st1.executeUpdate("UPDATE Auctions SET InitialBid = " + InitialBid + " WHERE itemID= '"+ itemID+"'");
		
		java.sql.Date bidDate = new java.sql.Date(new java.util.Date().getTime());
		PreparedStatement preparedStatement;
		
		preparedStatement = conn.prepareStatement("INSERT INTO Bid(bidID, bidDate,type, bidAmt) VALUES (?,?,?,?)");
		preparedStatement.setInt(1,0);
		preparedStatement.setDate(2,bidDate);
		preparedStatement.setBoolean(3,false);
		preparedStatement.setDouble(4, newCurrentBid);
		preparedStatement.executeUpdate();
		
		int bidID = -1;
		rs1 = st1.executeQuery("SELECT MAX(bidID) FROM Bid");
		if(rs1.next()){
			bidID = rs1.getInt(1);
		}
		
		int actID = -1;
		rs = st.executeQuery("SELECT actID FROM Account WHERE userName = '"+userName + "'");
		if(rs.next()){
			actID = rs.getInt(1);
		}
		
		//to insert in AuctionHistory
		preparedStatement = conn.prepareStatement("INSERT INTO AuctionHistory(actID,bidID,auctionID) VALUES(?,?,?)");
		preparedStatement.setInt(1,actID);
		preparedStatement.setInt(2,bidID);
		preparedStatement.setInt(3, auctionID);
		
		preparedStatement.executeUpdate();
		
		preparedStatement.close();
	} else {
		response.sendRedirect("setNewBid.jsp?Id=" + id + "&Name=" + name + "&error=low");
		return;
	}
	rs.close();
	rs1.close();
	st.close();
	st1.close();
	conn.close();
	response.sendRedirect("setNewBid.jsp?Id=" + id + "&Name=" + name);
}catch (Exception e) {
	e.printStackTrace();
}
%>

</body>
</html>