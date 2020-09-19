<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "com.web.utils.*, com.web.users.User, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link href="./styles/global.css" rel="stylesheet" type="text/css">
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
<title>Appathon - Login</title>
<%
	Connection conn = DBService.getConnection();
%>
</head>
<body>
	<h1>Login</h1>
	<%
		boolean wrongPassword = false; 
		if (request.getParameter("username") != null && request.getParameter("password") != null) {
			Statement stmt = conn.createStatement();
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			try {
				ResultSet rs = stmt.executeQuery(
					"SELECT * FROM users WHERE username = '" + username + "';"
				);

				if (!rs.next()) {
					session.setAttribute("username", username);
					response.sendRedirect("/Appathon/newuser");
				} else {
					// Only one row expected because we searched by the primary key
					String dbPassword = rs.getString("password");
					String fullName = rs.getString("fullName");
					Date birthday = rs.getDate("birthday");
					if (dbPassword.equals(password)) {
						User user = new User(username, fullName, dbPassword, birthday);
						session.setAttribute("user", user);
						response.sendRedirect("/Appathon/myhomepage");
					} else {						
						wrongPassword = true;
					}
				}
				
				
				rs.close();
		      	stmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	
		if (wrongPassword || (request.getParameter("username") == null && request.getParameter("password") == null)) {
	%>
	<form method="POST" action="/Appathon/">
		<div class="form-field">
			<label>Username: </label>
			<input type="text" name="username" value="<%= wrongPassword ? request.getParameter("username") : "" %>" required>
		</div>
		<div class="form-field">
			<label>Password: </label>
			<div>
				<input type="password" name="password" required>
				<%
					if (wrongPassword) {
				%>
				<small>You typed an incorrect password</small>
				<%
					}
				%>
			</div>
		</div>
		<div class="form-action">
			<input type="submit" name="submit" value="Login">
		</div>
	</form>
	<%
		}
	%>
</body>
</html>