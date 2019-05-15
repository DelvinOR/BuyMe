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

int itemID = Integer.parseInt(id);
rs = st.executeQuery("SELECT* FROM Auctions WHERE itemID= '" + itemID+  "'");
rs.next();
int AuctionsID = rs.getInt("AuctionsID");
double InitialBid = rs.getDouble("InitialBid");
double inc = rs.getDouble("BidIncrement");
double realUpperLimit = InitialBid;

double upperLimit = Double.parseDouble(request.getParameter("upperLimit"));
if(upperLimit>InitialBid){

if(upperLimit > InitialBid){
	realUpperLimit += inc;//basically rounding
}
InitialBid += inc;
//once placing an autoBid you place a normal bid first
st1.executeUpdate("UPDATE Auctions SET InitialBid = " + InitialBid + " WHERE itemID= '"+ itemID+"'");
java.sql.Date bidDate = new java.sql.Date(new java.util.Date().getTime());
PreparedStatement preparedStatement;

preparedStatement = conn.prepareStatement("INSERT INTO Bid(bidID, bidDate,type) VALUES (?,?,?)");
preparedStatement.setInt(1,0);
preparedStatement.setDate(2,bidDate);
preparedStatement.setBoolean(3,true);
 
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
preparedStatement.setInt(3,AuctionsID);

preparedStatement.executeUpdate();
/*
-A realUpperLimit is set and a user who wanted to place an autoBid automatically outbids the highest bid considering
-UpperLimit > InitialBid
-still have to find out where would realUpperLimit go and when would we check for autoBids when someone bids higher on 
-an auction.
*/
}

response.sendRedirect("dashboard.jsp");
rs.close();
rs1.close();
st.close();
st1.close();
conn.close();
}catch (Exception e) {
e.printStackTrace();
}
%>
</body>
</html>