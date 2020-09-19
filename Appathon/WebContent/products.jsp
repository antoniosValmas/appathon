<%@page import="java.util.TreeMap"%>
<%@page import="com.web.products.Product"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="com.web.utils.*, com.web.users.User, java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Appathon - Products</title>
<link href="./styles/global.css" rel="stylesheet" type="text/css">
<link href="./styles/menu.css" rel="stylesheet" type="text/css">
<link href="./styles/products.css" rel="stylesheet" type="text/css">
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
<%
	Connection conn = DBService.getConnection();
	if (request.getParameter("productId") != null) {
	int productId = Integer.parseInt(request.getParameter("productId"));
		Integer selectedProduct = Integer.parseInt(request.getParameter("productId"));
		TreeMap<Integer, Integer> cart;
		if (session.getAttribute("cart") == null) {
			cart = new TreeMap<>();
		} else {
			cart = (TreeMap<Integer, Integer>) session.getAttribute("cart");
		}

		if (cart.get(productId) == null) {
			cart.put(productId, 1);
		} else {
			cart.put(productId, cart.get(productId) + 1);
		}
		
		session.setAttribute("cart", cart);
	}
%>
</head>
<body>
	<%
		if (session.getAttribute("user") == null) {
			response.sendRedirect("/Appathon/");
		} else {;
			User user = (User) session.getAttribute("user");
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery("SELECT * FROM products");
	%>
	<div class="menu">
		<div class="site-navigation">
			<a href="/Appathon/myhomepage">HomePage</a> <a
				href="/Appathon/products" class="active">Products</a>
		</div>
		<div class="user-navigation">
			<a href="/Appathon/basket">My Cart</a>
			<a href="/Appathon/logout">Logout</a>
		</div>
	</div>
	<h1>Products</h1>
	<div class="products-container">
		<%
			while (rs.next()) {
		%>
		<div class="card">
			<div class="card-image">
				<img src="./assets/<%=rs.getString("image")%>" />
			</div>
			<div class="card-field">
				<div>Product:</div>
				<div><%=rs.getString("name")%></div>
			</div>
			<div class="card-field">
				<div>Price:</div>
				<div class="price">
					<div><%=rs.getDouble("price")%>
						&euro;
					</div>
					<small>with VAT: <%= Math.round(rs.getDouble("price") * 1.23 * 100.0) / 100.0 %>
						&euro;
					</small>
				</div>
			</div>
			<div class="card-action">
				<button onclick="addToCart(<%=rs.getInt("id")%>)">Add to cart</button>
			</div>
		</div>
		<%
			}
		%>
	</div>
	<%
		}
	%>
	<script type="text/javascript">
		function addToCart(id) {
			var oReq = new XMLHttpRequest();
			oReq.open("POST", "/Appathon/products?productId=" + id);
			oReq.send();
		}
	</script>
</body>
</html>