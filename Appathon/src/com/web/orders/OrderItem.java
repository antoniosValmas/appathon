package com.web.orders;

public class OrderItem {
	private int id;
	private int productId;
	private int orderId;

	public OrderItem(int id, int productId, int orderId) {
		super();
		this.id = id;
		this.productId = productId;
		this.orderId = orderId;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getProductId() {
		return productId;
	}

	public void setProductId(int productId) {
		this.productId = productId;
	}

	public int getOrderId() {
		return orderId;
	}

	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}

}
