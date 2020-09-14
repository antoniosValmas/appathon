<%@page import="com.web.users.User"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link href="./styles/global.css" rel="stylesheet" type="text/css">
<link href="./styles/menu.css" rel="stylesheet" type="text/css">
</head>
<body>
	<% 
		if (session.getAttribute("user") == null) {
			response.sendRedirect("/Appathon/");
		} else {
			User user = (User) session.getAttribute("user");
	%>
	<div class="menu">
		<div class="site-navigation">
			<a href="/Appathon/homepage" class="active">HomePage</a>
			<a href="/Appathon/products">Products</a>
		</div>
		<div class="user-navigation">
			<a href="/Appathon/">My Cart</a>
			<a href="/Appathon/logout">Logout</a>
		</div>
	</div>
	<h1>HomePage</h1>
	<div class="user-card card">
		<h3 class="card-title">Welcome <%= user.getUsername() %> </h3>
		<div class="card-field">
			<div>Full Name:</div>
			<div><%= user.getFullName() %></div>
		</div>
		<div class="card-field">
			<div>Birthday:</div>
			<div><%= user.getBirthday() %></div>
		</div>
		<div class="card-action">
			<a href="/Appathon/pageupdate">Edit profile</a>
		</div>
	</div>
	<%
		}
	%>
</body>
</html>