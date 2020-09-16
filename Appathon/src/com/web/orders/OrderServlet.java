package com.web.orders;

import java.io.FileWriter;
import java.io.IOException;
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

import com.web.users.User;
import com.web.utils.DBService;

@WebServlet(name = "orderservlet", urlPatterns = "/order")
public class OrderServlet extends HttpServlet{
	Connection conn = DBService.getConnection();

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession ses = req.getSession();
		if (ses.getAttribute("user") == null) {
			resp.sendRedirect("/Appathon/");
		} else if (ses.getAttribute("cart") == null) {
			resp.sendRedirect("/Appathon/basket");
		} else {			
			TreeMap<Integer, Integer> cart = (TreeMap<Integer, Integer>) ses.getAttribute("cart");
			User user = (User) ses.getAttribute("user");
			int countryVATId = Integer.parseInt(req.getParameter("countryVATId"));
			double countryVAT = Double.parseDouble(req.getParameter("countryVAT"));
			Voucher voucher = (Voucher) ses.getAttribute("voucher");
			try {
				Statement stmt = conn.createStatement();
				stmt.executeUpdate(
					String.format(
						"INSERT INTO orders (voucher_id, username, country_vat_id) VALUES (%d, '%s', %d)",
						voucher == null ? null : voucher.getId(), user.getUsername(), countryVATId
					), Statement.RETURN_GENERATED_KEYS
				);
				ResultSet rs = stmt.getGeneratedKeys();
				if(!rs.next()) {
					System.out.println("Result set is empty");
				}
				int order_id = rs.getInt(1);
				Iterator<Entry<Integer, Integer>> it = cart.entrySet().iterator();
				while(it.hasNext()) {
					Entry<Integer, Integer> orderItem = it.next();
					orderItem.getKey();
					stmt.execute(
						String.format(
							"INSERT INTO order_items (product_id, order_id, quantity) VALUES (%d, %d, %d)",
							orderItem.getKey(), order_id, orderItem.getValue()
						)
					);
				}
				
				try (FileWriter out = new FileWriter("D:\\Java Projects\\repository\\Appathon\\WebContent\\orders\\order_" + order_id + ".txt")) {
					out.write(
						String.format(
							"User %s submitted an order with %d %% vat\n",
							user.getUsername(), (int) (countryVAT * 100)
						)
					);
					
					if (voucher != null) {
						out.write(
							String.format(
								"They used the voucher %s for a %d %% discount\n",
								voucher.getCode(), (int) (voucher.getDiscount() * 100)
							)
						);
					}
					out.write("Order Items:\n");
					Iterator<Entry<Integer, Integer>> it2 = cart.entrySet().iterator();
					while(it2.hasNext()) {
						Entry<Integer, Integer> orderItem = it2.next();
						out.write(orderItem.getValue() + "x of product with id " + orderItem.getKey() + "\n");
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
				
				rs.close();
				stmt.close();
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
	}
}
