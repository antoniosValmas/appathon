<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.web.utils.DBService"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Appathon - My cart</title>
<link href="./styles/global.css" rel="stylesheet" type="text/css">
<link href="./styles/menu.css" rel="stylesheet" type="text/css">
<link href="./styles/basket.css" rel="stylesheet" type="text/css">
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
<%
	Connection conn = DBService.getConnection();
%>
</head>
<body>
	<div class="menu">
		<div class="site-navigation">
			<a href="/Appathon/myhomepage">HomePage</a> <a
				href="/Appathon/products">Products</a>
		</div>
		<div class="user-navigation">
			<a href="/Appathon/basket" class="active">My Cart</a>
			<a href="/Appathon/logout">Logout</a>
		</div>
	</div>
	<%
	if (session.getAttribute("user") == null) {
		response.sendRedirect("/Appathon/");
	} else {
		%>
		<h1>My Cart</h1> 
		<%
		if (session.getAttribute("cart") != null) {				
			TreeMap<Integer, Integer> cart = (TreeMap<Integer, Integer>) session.getAttribute("cart");
			Statement stmt = conn.createStatement();
			Iterator<Entry<Integer, Integer>> iter = cart.entrySet().iterator();
			String keys = "" + iter.next().getKey();
			while(iter.hasNext()) {
				keys += ", " + iter.next().getKey();
			}
			ResultSet rs = stmt.executeQuery(
				String.format("SELECT * FROM products WHERE id IN ( %s )", keys)
			);

			%>
			<table class="container">
				<tr class="columns">
					<th>Image</th>
					<th>Name</th>
					<th>Quantity</th>
					<th>Price</th>
				</tr>
				<%
				double sum = 0;
				double vat = 0;
				double finalTotal = 0;
				while(rs.next()) {
					int quantity = cart.get(rs.getInt("id"));
					%>
					<tr class="cart-item">
						<td>
							<img src="./assets/<%= rs.getString("image") %>">
						</td>
						<td> <%= rs.getString("name") %> </td>
						<td> <%= quantity %> </td>
						<td> <%= rs.getDouble("price") * quantity %> &euro;</td>
					</tr>
					<%
					sum += rs.getDouble("price") * quantity;
				}
				vat = sum * 0.23;
				finalTotal = sum + vat;
				%>
				<tr>
					<td colspan="4">
						<div class="total">
							<div>Total: </div>
							<div id="total"><%= Math.round(sum * 100.0) / 100.0 %> &euro;</div>
						</div>
						<div class="vat">
							<div>VAT: </div>
							<div id="vat">+ <%= Math.round(vat * 100.0) / 100.0 %> &euro;</div>
						</div>
						<div class="discount">
							<div>Discount: </div>
							<div id="discount">- 0 &euro;</div>
						</div>
						<div class="final">
							<div>Total with VAT:</div>
							<div id="final"><%= Math.round(finalTotal * 100.0) / 100.0 %> &euro;</div>
						</div>
					</td>
				</tr>
			</table>
			<div class="card">
				<div class="card-field voucher">
					<label>Insert Voucher</label>
					<input name="voucher" type="text" onblur="checkCode(this.value)"/>
				</div>
				<div class="card-field country-vat">
					<label>Select country</label>
					<select id="countryVATList" onchange="selectVAT(this.value)">
						<option>Choose a country</option>
					</select>
				</div>
				<div class="card-action">
					<button onclick="checkout()")>Purchase</button>
				</div>
			</div>
			<%
			
		} else {
			%>
			<h2>No items in the cart</h2>
			<%
		}
	}
	%>
<script type="text/javascript">
	var countryVAT = [];
	var selectedVAT = 0;
	var voucherDiscount = 0;
	function initCountryVatList() {
		countryVAT = JSON.parse(this.responseText.split("\n")[0]);
		const list = document.getElementById("countryVATList");
		countryVAT.forEach((entry, index) => {
			const option = document.createElement("option");
			option.text = entry.country + " (" + entry.vat * 100 + "%)";
			option.value = index;
			if (index == selectedVAT) {
				option.selected = 'selected'
			}
			list.appendChild(option);
		})
		
	}
	// fetch country vat
	var req = new XMLHttpRequest();
	req.open("GET", "/Appathon/country-vat");
	req.addEventListener("load", initCountryVatList);
	req.send();
	
	function updatedHTML() {
		const total = Number.parseFloat(document.getElementById("total").innerHTML);
		document.getElementById("vat").innerHTML = "+ " + (total * countryVAT[selectedVAT].vat).toFixed(2) + " &euro;";
		document.getElementById("discount").innerHTML = "- " + (total * (1 + countryVAT[selectedVAT].vat) * voucherDiscount).toFixed(2) + " &euro;";
		document.getElementById("final").innerHTML = (total * (1 + countryVAT[selectedVAT].vat) * (1 - voucherDiscount)).toFixed(2) + " &euro;";
		if (voucherDiscount !== 0) {
			document.getElementById("final").classList = "discount-final";
		} else {
			document.getElementById("final").classList = "";
		}
	}
	
	function applyDiscount()  {
		voucherDiscount = Number.parseFloat(this.responseText) || 0;
		updatedHTML();
	}

	function checkCode(code) {
		var req = new XMLHttpRequest();
		req.open("POST", "/Appathon/voucher?voucherCode=" + code);
		req.addEventListener("load", applyDiscount);
		req.send();	
	}
	
	function selectVAT(index) {
		selectedVAT = index;
		updatedHTML();
	}
	
	function checkout() {
		var req = new XMLHttpRequest();
		req.open("POST", "/Appathon/order?countryVATId=" + countryVAT[selectedVAT].id + "&countryVAT=" + countryVAT[selectedVAT].vat);
		req.addEventListener("load", redirectToThankYou);
		req.send();	
	}
	
	function redirectToThankYou() {
		window.location.href = "/Appathon/thankyou.html";
	}
</script>
</body>
</html>