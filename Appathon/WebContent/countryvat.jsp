<%@page import="java.io.PrintWriter"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.web.utils.DBService"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<%
	Connection conn = DBService.getConnection();
%>
</head>
<body>
	<%
		if (request.getMethod().equals("GET")) {
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery("SELECT * FROM country_vat;");
			PrintWriter res = response.getWriter();
			res.write("[");
			boolean first = true;
			while(rs.next()) {
				if (!first) {
					res.append(",");
				}
				first = false;
				res.append("{");
				res.append("\"id\": " + rs.getInt("id") + ",");
				res.append("\"country\": \"" + rs.getString("country") + "\",");
				res.append("\"vat\": " + rs.getDouble("vat"));
				res.append("}");
			}
			res.append("]");
		}
	%>
</body>
</html>