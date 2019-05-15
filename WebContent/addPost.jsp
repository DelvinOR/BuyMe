<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.*" %>

<%
if((session.getAttribute("user")== null)){
%>
	<a href="login.jsp"> Please log in</a>
<%

}else{
	
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
	Statement st = conn.createStatement();
	int actID=0;
	String user = (String) session.getAttribute("user");
	
	ResultSet rs0 = st.executeQuery("SELECT actID FROM Account WHERE userName = '" + user+ "'");
	if(rs0.next()){//you have an account and getInt(1) gets first value in the first column in returned tuple
		actID = rs0.getInt(1);
	}
	rs0.close();
	int itemID;
	//int auctionID;
	String itemName = request.getParameter("ItemName");
	String tmp = itemName;
	tmp = tmp.replaceAll(" ","");
	if(tmp.equals("")){
		%>
		Invalid item name input (Cannot consist of all spaces or nothing at all)<br>
		<a href="createPost.jsp">Return</a>
		<%
		return;
	}
	
	String itemType = request.getParameter("ItemType");
	tmp = itemType;
	tmp = tmp.replaceAll(" ","");
	if(tmp.equals("")){
		%>
		Invalid item type input (Cannot consist of all spaces or nothing at all)<br>
		<a href="createPost.jsp">Return</a>
		<%
		return;
	}
	
	String desc = request.getParameter("Description");
	tmp = desc;
	tmp = tmp.replaceAll(" ","");
	if(tmp.equals("")){
		%>
		Invalid description input (Cannot consist of all spaces or nothing at all)<br>
		<a href="createPost.jsp">Return</a>
		<%
		return;
	}
	
	double price = Double.valueOf(request.getParameter("Price"));
	double bidInc = price*.05;
	
	//trying to format date as datetype in sql
	String closingDate = request.getParameter("ClosingDate");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	java.util.Date parsed = new java.util.Date();
	try{
		parsed = sdf.parse(closingDate);
	}catch(ParseException e1){
		e1.printStackTrace();
	}
	java.sql.Date sqlDate = new java.sql.Date(parsed.getTime());
	
	//trying to format time as a datatype in sql
	String closingTime = request.getParameter("ClosingTime");
	SimpleDateFormat sdf2 = new SimpleDateFormat("HH:mm:ss");
	java.util.Date parsed2 = new java.util.Date();
	try{
		parsed2 = sdf2.parse(closingTime);
	}catch(ParseException e2){
		e2.printStackTrace();
	}
	java.sql.Time sqlTime= new java.sql.Time(parsed2.getTime()); 
	
	ResultSet rs = st.executeQuery("SELECT MAX(ItemID) FROM Items");//will give you the bottom tuple which is the most recent item added
	itemID = -1;
	if(rs.next()){
		itemID = rs.getInt(1);
	}
	rs.close();
	st.close();
	/*
	ResultSet rs2 = st.executeQuery("SELECT MAX(AuctionsID) FROM Auctions");
	auctionID = -1;
	if(rs2.next()){
		auctionID = rs2.getInt(1);
	}
	rs2.close();*/
	
	PreparedStatement preparedStatement;
	
	preparedStatement = conn.prepareStatement("INSERT INTO Items (ItemID,ItemName, ItemType, Description) VALUES (?,?,?,?)");
	preparedStatement.setInt(1, 0);
	preparedStatement.setString(2, itemName);
	preparedStatement.setString(3, itemType);
	preparedStatement.setString(4, desc);
	preparedStatement.executeUpdate();
	
	preparedStatement = conn.prepareStatement("INSERT INTO Auctions (AuctionsID, actID, itemID, MinPrice, InitialBid, BidIncrement,ClosingDate,ClosingTime) VALUES (?,?,?,?,?,?,?,?)");
	preparedStatement.setInt(1,0);
	preparedStatement.setInt(2,actID);
	preparedStatement.setInt(3,(itemID+1));
	preparedStatement.setDouble(4,price);
	preparedStatement.setDouble(5,bidInc);
	preparedStatement.setDouble(6,bidInc);
	preparedStatement.setDate(7,sqlDate);
	preparedStatement.setTime(8,sqlTime);
	preparedStatement.executeUpdate();
	
	response.sendRedirect("dashboard.jsp");
	
	preparedStatement.close();
	conn.close();
}
%>

</body>
</html>
