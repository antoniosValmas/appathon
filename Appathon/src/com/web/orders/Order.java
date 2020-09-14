package com.web.orders;

public class Order {
	private int id;
	private int voucherId;
	private int username;
	private int countryVATId;

	public Order(int id, int voucherId, int username, int countryVATId) {
		super();
		this.id = id;
		this.voucherId = voucherId;
		this.username = username;
		this.countryVATId = countryVATId;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getVoucherId() {
		return voucherId;
	}

	public void setVoucherId(int voucherId) {
		this.voucherId = voucherId;
	}

	public int getUsername() {
		return username;
	}

	public void setUsername(int username) {
		this.username = username;
	}

	public int getCountryId() {
		return countryVATId;
	}

	public void setCountryId(int countryVATId) {
		this.countryVATId = countryVATId;
	}

}
