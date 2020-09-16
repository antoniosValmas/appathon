<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Scanner"%>
<%@page import="com.web.users.User"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "com.web.utils.*, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Appathon - Import products</title>
<%
	Connection conn = DBService.getConnection();
%>
</head>
<body>
	<% 
	boolean successfulImport = false;
	if (session.getAttribute("user") == null) {
		response.sendRedirect("/Appathon/");
	} else {
		User user = (User) session.getAttribute("user");
		if (!user.getUsername().equals("admin")) {
			response.sendRedirect("/Appathon/homepage");
		} else {
			try (Scanner sc = new Scanner(new File("D:\\Java Projects\\repository\\Appathon\\WebContent\\products\\products.csv"))) {
				sc.useDelimiter("\n");
				String[] labels = sc.next().split(",");
				while(sc.hasNext()) {
					String[] productCSV = sc.next().split(",");
					int id = Integer.parseInt(productCSV[0]);
					String name = productCSV[1];
					String image = productCSV[2];
					double price = Double.parseDouble(productCSV[3]);
					Statement stmt = conn.createStatement();
					stmt.execute(
						String.format(
							"INSERT INTO products VALUES ( %d, '%s', '%s', %f )",
							id, name, image, price
						)
					);
				}
				
				successfulImport = true;
			} catch (FileNotFoundException e) {
				e.printStackTrace();
				%>
					<h2>Import file was not found</h2>
				<%
			} catch (SQLException e) {
				e.printStackTrace();
			}

			if (successfulImport) {
				%>
					<h2>Products have been imported successfully</h2>
				<%
			}
		}
	}
	%>
</body>
</html>