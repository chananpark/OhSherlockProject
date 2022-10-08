package common.model;

public class OrderVO {
	
	private String odrcode;  
	private String fk_userid; 
	private String odrdate;        
	private String recipient_name; 
	private String recipient_mobile;
	private String recipient_postcode;
	private String recipient_address;
	private String recipient_detail_address;
	private String recipient_extra_address;
	private int odrtotalprice;
	private int odrtotalpoint; 
	private int delivery_cost;
	private int odrstatus;
	private String delivery_date;
	
	// 주문 취소 여부
	private boolean isCancled;
	// 주문 반품 여부
	private boolean isReturned;
	
	public OrderVO() {}

	// 주문목록 생성자
	public OrderVO(String odrcode, String fk_userid, String odrdate, 
			int odrtotalprice, int odrstatus) {
		this.odrcode = odrcode;
		this.fk_userid = fk_userid;
		this.odrdate = odrdate;
		this.odrtotalprice = odrtotalprice;
		this.odrstatus = odrstatus;
		}
	
	public String getOdrcode() {
		return odrcode;
	}

	public void setOdrcode(String odrcode) {
		this.odrcode = odrcode;
	}

	public String getFk_userid() {
		return fk_userid;
	}

	public void setFk_userid(String fk_userid) {
		this.fk_userid = fk_userid;
	}

	public String getOdrdate() {
		return odrdate;
	}

	public void setOdrdate(String odrdate) {
		this.odrdate = odrdate;
	}

	public String getRecipient_name() {
		return recipient_name;
	}

	public void setRecipient_name(String recipient_name) {
		this.recipient_name = recipient_name;
	}

	public String getRecipient_mobile() {
		return recipient_mobile;
	}

	public void setRecipient_mobile(String recipient_mobile) {
		this.recipient_mobile = recipient_mobile;
	}

	public String getRecipient_postcode() {
		return recipient_postcode;
	}

	public void setRecipient_postcode(String recipient_postcode) {
		this.recipient_postcode = recipient_postcode;
	}

	public String getRecipient_address() {
		return recipient_address;
	}

	public void setRecipient_address(String recipient_address) {
		this.recipient_address = recipient_address;
	}

	public String getRecipient_detail_address() {
		return recipient_detail_address;
	}

	public void setRecipient_detail_address(String recipient_detail_address) {
		this.recipient_detail_address = recipient_detail_address;
	}

	public String getRecipient_extra_address() {
		return recipient_extra_address;
	}

	public void setRecipient_extra_address(String recipient_extra_address) {
		this.recipient_extra_address = recipient_extra_address;
	}

	public int getOdrtotalprice() {
		return odrtotalprice;
	}

	public void setOdrtotalprice(int odrtotalprice) {
		this.odrtotalprice = odrtotalprice;
	}

	public int getOdrtotalpoint() {
		return odrtotalpoint;
	}

	public void setOdrtotalpoint(int odrtotalpoint) {
		this.odrtotalpoint = odrtotalpoint;
	}

	public int getDelivery_cost() {
		return delivery_cost;
	}

	public void setDelivery_cost(int delivery_cost) {
		this.delivery_cost = delivery_cost;
	}

	public int getOdrstatus() {
		return odrstatus;
	}

	public void setOdrstatus(int odrstatus) {
		this.odrstatus = odrstatus;
	}

	public String getDelivery_date() {
		return delivery_date;
	}

	public void setDelivery_date(String delivery_date) {
		this.delivery_date = delivery_date;
	}
	
	public boolean isCancled() {
		return isCancled;
	}

	public void setCancled(boolean isCancled) {
		this.isCancled = isCancled;
	}

	public boolean isReturned() {
		return isReturned;
	}

	public void setReturned(boolean isReturned) {
		this.isReturned = isReturned;
	}
}
