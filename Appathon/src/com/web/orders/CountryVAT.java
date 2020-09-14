package com.web.orders;

public class CountryVAT {
	private int id;
	private String country;
	private double VAT;

	public CountryVAT(int id, String country, double vAT) {
		this.id = id;
		this.country = country;
		VAT = vAT;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public double getVAT() {
		return VAT;
	}

	public void setVAT(double vAT) {
		VAT = vAT;
	}
}
