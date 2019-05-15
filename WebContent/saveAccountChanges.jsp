<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Saving account changes..</title>
</head>
<body>
	<%@ page import = "java.sql.*" %>
	<% 
		String user = request.getParameter("user"); // preserve username
	
		String username = request.getParameter("username");
		String temp = username;
		temp = temp.replaceAll("\\s","");
		if (temp.equals(""))
			username = "";
	
		String password = request.getParameter("password");
		temp = password;
		temp = temp.replaceAll("\\s","");
		if (temp.equals(""))
			password = "";
		
		String email = request.getParameter("email");
		temp = email;
		temp = temp.replaceAll("\\s","");
		if (temp.equals(""))
			email = "";
		
		String firstName = request.getParameter("firstName");
		temp = firstName;
		temp = temp.replaceAll("\\s","");
		if (temp.equals(""))
			firstName = "";
		
		String lastName = request.getParameter("lastName");
		temp = lastName;
		temp = temp.replaceAll("\\s","");
		if (temp.equals(""))
			lastName = "";
		
		String address = request.getParameter("address");
		temp = address;
		temp = temp.replaceAll("\\s","");
		if (temp.equals(""))
			address = "";
		
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://cs336db.cl0xdj4x6xaa.us-east-2.rds.amazonaws.com:3306/cs336db","cs336", "cs336masterkey");
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery("SELECT * FROM Account WHERE userName = '" +  user + "'");	
		rs.next(); // shouldn't have to worry about not finding the user in the DB
		int personID = rs.getInt("personID");
		
		rs = st.executeQuery("SELECT * FROM Account WHERE userName = '" + username + "'");
		if (!user.equals(username) && rs.next()) {
			String dbUsername = rs.getString("userName");
			if (!user.equals(dbUsername)) {
				response.sendRedirect("editAccount.jsp?user=" + user + "&error=username");
				return;
			}
		}
		
		rs = st.executeQuery("SELECT * FROM Account WHERE email = '" + email + "'");
		if (rs.next()) {
			String dbEmail = rs.getString("email");
			
			rs = st.executeQuery("SELECT * FROM Account WHERE userName = '" + user + "'");
			rs.next();
			String currentEmail = rs.getString("email");
			
			if (!currentEmail.equals(dbEmail)) {
				response.sendRedirect("editAccount.jsp?user=" + user + "&error=email");
				return;
			}
		}
		
		if (username.equals("") || password.equals("") || email.equals("") ||
			firstName.equals("") || lastName.equals("") || address.equals("")) { 
			response.sendRedirect("editAccount.jsp?user=" + user + "&error=empty");
			return;
 		}
		
		String updatePerson = "UPDATE Person SET firstName = ?, lastName = ? WHERE userID = ?";
		PreparedStatement personStatement = conn.prepareStatement(updatePerson);
		personStatement.setString(1, firstName);
		personStatement.setString(2, lastName);
		personStatement.setInt(3, personID);
		personStatement.executeUpdate();
		
		String updateAccount = "UPDATE Account SET userName = ?, password = ?, address = ?, email = ? WHERE personID = ?";
		PreparedStatement accountStatement = conn.prepareStatement(updateAccount);
		accountStatement.setString(1, username);
		accountStatement.setString(2, password);
		accountStatement.setString(3, address);
		accountStatement.setString(4, email);
		accountStatement.setInt(5, personID);
		accountStatement.executeUpdate();	
		
		st.close();
		rs.close();
		personStatement.close();
		accountStatement.close();
		conn.close();
		
		response.sendRedirect("profile.jsp?user=" + username);
 	%>
</body>
</html>