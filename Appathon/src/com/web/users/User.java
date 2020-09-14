package com.web.users;

import java.util.Date;

public class User {
	private String username;
	private String fullName;
	private Date birthday;
	private String password;

	public User(int id, String username, String fullName, String password, Date birthday) {
		this.username = username;
		this.fullName = fullName;
		this.password = password;
		this.birthday = birthday;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Date getBirthday() {
		return birthday;
	}

	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}

}
