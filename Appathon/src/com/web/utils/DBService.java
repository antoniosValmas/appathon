package com.web.utils;

import java.sql.*;

public class DBService {

	private static final String DB_URL = "jdbc:mysql://localhost:3306/appathon";
	private static final String USER = "root";
	private static final String PASSWORD = "";

	private static DBService dbServiceInstance;
	private static Connection conn;

	private DBService() {
		createConnection();
	}

	private void createConnection() {
		try {
			conn = DriverManager.getConnection(DB_URL, USER, PASSWORD);
		} catch (SQLException e) {
			System.out.println("An SQL error occured: " + e.getMessage());
		}
	}

	public static Connection getConnection() {
		dbServiceInstance = dbServiceInstance == null ? new DBService() : dbServiceInstance;
		return conn;
	}
}
