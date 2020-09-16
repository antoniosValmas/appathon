package com.web.orders;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Iterator;
import java.util.Map.Entry;
import java.util.TreeMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.web.utils.DBService;

@WebServlet(name = "VoucherServlet", urlPatterns = "/voucher")
public class VoucherServlet extends HttpServlet{
	Connection conn = DBService.getConnection();

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession ses = req.getSession();
		try {
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(
				String.format("SELECT * FROM vouchers WHERE code = '%s'", req.getParameter("voucherCode"))
			);
			PrintWriter out = resp.getWriter();
			if (rs.next()) {
				Voucher voucher = new Voucher(rs.getInt("id"), rs.getString("code"), rs.getDouble("discount"));
				ses.setAttribute("voucher", voucher);
				out.append("" + rs.getDouble("discount"));
				out.flush();
			} else {
				ses.removeAttribute("voucher");
				out.append("" + 0);
				out.flush();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		
		
	}
}
