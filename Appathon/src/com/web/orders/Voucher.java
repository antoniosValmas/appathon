package com.web.orders;

public class Voucher {
	private int id;
	private String code;
	private double discount;

	public Voucher(int id, String code, double discount) {
		super();
		this.id = id;
		this.code = code;
		this.discount = discount;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public double getDiscount() {
		return discount;
	}

	public void setDiscount(double discount) {
		this.discount = discount;
	}

}
