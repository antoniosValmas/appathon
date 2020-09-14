<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "com.web.utils.*, com.web.users.User, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<link href="./styles/global.css" rel="stylesheet" type="text/css">
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<%
	Connection conn = DBService.getConnection();
%>
</head>
<body>
	<h1>Register</h1>
	
	<% 
		boolean userFound = false;
		if (request.getParameter("username") != null) {
			Statement stmt = conn.createStatement();
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			String fullName = request.getParameter("fullName");
			String birthday = request.getParameter("birthday");
			try {
				ResultSet rs = stmt.executeQuery(
					"SELECT * FROM users WHERE username = '" + username + "';"
				);

				if (rs.next()) {
					userFound = true;
				} else {
					stmt.execute(
						String.format(
							"INSERT INTO users VALUES ( '%s', '%s', '%s', '%s' )",
							username, fullName, password, birthday
						)
					);
					Date birthdayDate = new SimpleDateFormat("yyyy-MM-dd").parse(birthday);
					User user = new User(username, password, fullName, birthdayDate);
					response.sendRedirect("/Appathon/myhomepage");					
				}
				
				
				rs.close();
		      	stmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	
		if (userFound || request.getParameter("username") == null) { %>
	<form method="POST" action="/Appathon/newuser">
		<div class="form-field">
			<label>Username: </label>
			<input type="text" name="username" value="<%=
				userFound ?
					request.getParameter("username") :
					session.getAttribute("username") == null ? 
						"" : session.getAttribute("username") 
			%>" required>
		</div>
		<div class="form-field">
			<label>Password: </label>
			<input type="password" name="password" value="<%= userFound ? request.getParameter("password") : "" %>" required>
		</div>
		<div class="form-field">
			<label>Full Name: </label>
			<input type="text" name="fullName" value="<%= userFound ? request.getParameter("fullName") : "" %>" required>
		</div>
		<div class="form-field">
			<label>Birthday: </label>
			<input type="date" name="birthday" value="<%= userFound ? request.getParameter("birthday") : "" %>" required>
		</div>
		<div class="form-action">
			<input type="submit" name="submit" value="Register">
		</div>
	</form>
	<% } %>
</body>
</html>