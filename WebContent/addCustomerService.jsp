<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Adding new employee..</title>
</head>
<body>
<%@ page import = "java.sql.*" %>

<%
	String userID = request.getParameter("username").toLowerCase();
	String tmp = userID;
	tmp = tmp.replaceAll(" ","");
	if(tmp.equals("")){
		response.sendRedirect("createCustomerService.jsp?error=username");
		return;
	}
	String pwd = request.getParameter("password");
	tmp = pwd;
	tmp = tmp.replaceAll(" ","");
	if(tmp.equals("")){
		response.sendRedirect("createCustomerService.jsp?error=password");
		return;
	}
	String email = request.getParameter("email");
	tmp = email;
	tmp = tmp.replaceAll(" ","");
	if(tmp.equals("")){
		response.sendRedirect("createCustomerService.jsp?error=email");
		return;
	}
	String address = request.getParameter("address");
	tmp = address;
	tmp = tmp.replaceAll(" ","");
	if(tmp.equals("")){
		response.sendRedirect("createCustomerService.jsp?error=address");
		return;
	}
	String firstName = request.getParameter("firstName");
	tmp = firstName;
	tmp = tmp.replaceAll(" ","");
	if(tmp.equals("")){
		response.sendRedirect("createCustomerService.jsp?error=first name");
		return;
	}
	String lastName = request.getParameter("lastName");
	tmp = lastName;
	tmp = tmp.replaceAll(" ","");
	if(tmp.equals("")){
		response.sendRedirect("createCustomerService.jsp?error=last name");
		return;
	}
	
	String salaryText = request.getParameter("salary");
	tmp = salaryText;
	tmp = tmp.replaceAll(" ","");
	if(tmp.equals("")){
		response.sendRedirect("createCustomerService.jsp?error=salary");
		return;
	}
	double salary = Double.parseDouble(salaryText);
	if (salary < 0.0) 
		salary = 0.0D;
	
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
	Statement st = conn.createStatement();
	ResultSet rs;
	rs = st.executeQuery("SELECT * FROM Account WHERE userName = '" + userID + "'");
	
	if(rs.next()){
		response.sendRedirect("createCustomerService.jsp?error=duplicate");
	}else{
		PreparedStatement preparedStatement = conn.prepareStatement("INSERT INTO Account(actID, personID, userName, password, address, email) VALUES (?,?,?,?,?,?)");preparedStatement = conn.prepareStatement("INSERT INTO Person (userID, firstName, lastName) VALUES (?,?,?)");
		preparedStatement.setInt(1, 0);
		preparedStatement.setString(2, firstName);
		preparedStatement.setString(3, lastName);
		preparedStatement.executeUpdate();
		
		ResultSet rs2 = st.executeQuery("SELECT MAX(userID) FROM Person"); // new user ID inserted will have max id
		int newID = -1;
		if (rs2.next()) {
			newID = rs2.getInt(1);
		}
		rs2.close();
		
		preparedStatement = conn.prepareStatement("INSERT INTO Account(actID, personID, userName, password, address, email) VALUES (?,?,?,?,?,?)");
		preparedStatement.setInt(1, 0);
		preparedStatement.setInt(2, newID);
		preparedStatement.setString(3, userID);
		preparedStatement.setString(4, pwd);
		preparedStatement.setString(5, address);
		preparedStatement.setString(6, email);
		preparedStatement.executeUpdate();
		
		preparedStatement = conn.prepareStatement("INSERT INTO Employee(userID, salary, type) VALUES (?,?,?)");
		preparedStatement.setInt(1, newID);
		preparedStatement.setDouble(2, salary);
		preparedStatement.setString(3, "c");
		preparedStatement.executeUpdate();
		
		out.println("Successfully created " + userID);
		out.println("<a href='controlPanel.jsp'>Return to Control Panel</a>");
	}
	rs.close();
	st.close();
	conn.close();
%>
</body>
</html>