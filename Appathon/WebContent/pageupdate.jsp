<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.web.users.User"%>
<%@ page import = "com.web.utils.*, java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Appathon - Profile Update</title>
<link href="./styles/global.css" rel="stylesheet" type="text/css">
<link href="./styles/menu.css" rel="stylesheet" type="text/css">
<%
	Connection conn = DBService.getConnection();
%>
</head>
<body>
	<% 
		if (session.getAttribute("user") == null) {
			response.sendRedirect("/Appathon/");
		} else {
			User user = (User) session.getAttribute("user");
			String fullName = request.getParameter("fullName");
			String birthday = request.getParameter("birthday");
			if (fullName != null && birthday != null) {
				Statement stmt = conn.createStatement();
				stmt.execute(
						String.format(
								"UPDATE users SET fullName = '%s', birthday = '%s' WHERE username = '%s'",
								fullName, birthday, user.getUsername()
						)
				);
				user.setFullName(fullName);
				user.setBirthday(new SimpleDateFormat("yyyy-MM-dd").parse(birthday));
				session.setAttribute("user", user);
			}
	%>
	<div class="menu">
		<div class="site-navigation">
			<a href="/Appathon/myhomepage">HomePage</a>
			<a href="/Appathon/products">Products</a>
		</div>
		<div class="user-navigation">
			<a href="/Appathon/basket">My Cart</a>
			<a href="/Appathon/logout">Logout</a>
		</div>
	</div>
	<h1>Update your profile</h1>
	<form method="POST" action="/Appathon/pageupdate">
		<div class="form-field">
			<label>Full Name: </label>
			<input type="text" name="fullName" value="<%= user.getFullName() %>" required>
		</div>
		<div class="form-field">
			<label>Birthday: </label>
			<input type="date" name="birthday" value="<%= new SimpleDateFormat("yyyy-MM-dd").format(user.getBirthday()) %>" required>
		</div>
		<div class="form-action">
			<input type="submit" name="submit" value="Update">
		</div>
	</form>
	<%
		}
	%>
</body>
</html>