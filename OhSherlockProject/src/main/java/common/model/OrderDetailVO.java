package common.model;

public class OrderDetailVO {
	
	private int odnum;
	private String fk_odrcode;
	private int fk_pnum;
	private int oqty;  
	private int oprice;    
	private int opoint;    
	private int refund;    
	private int cancel;
	private String refund_reason;
	private String cancel_reason;
	
	private ProductVO pvo;
	
	public OrderDetailVO() {}

	public OrderDetailVO(int odnum, String fk_odrcode, int fk_pnum, int oqty, int oprice, int opoint, int refund, int cancel,
			String refund_reason, String cancel_reason) {
		this.odnum = odnum;
		this.fk_odrcode = fk_odrcode;
		this.fk_pnum = fk_pnum;
		this.oqty = oqty;
		this.oprice = oprice;
		this.opoint = opoint;
		this.refund = refund;
		this.cancel = cancel;
		this.refund_reason = refund_reason;
		this.cancel_reason = cancel_reason;
	}

	public int getOdnum() {
		return odnum;
	}
	public void setOdnum(int odnum) {
		this.odnum = odnum;
	}
	public String getFk_odrcode() {
		return fk_odrcode;
	}
	public void setFk_odrcode(String fk_odrcode) {
		this.fk_odrcode = fk_odrcode;
	}
	public int getFk_pnum() {
		return fk_pnum;
	}
	public void setFk_pnum(int fk_pnum) {
		this.fk_pnum = fk_pnum;
	}
	public int getOqty() {
		return oqty;
	}
	public void setOqty(int oqty) {
		this.oqty = oqty;
	}
	public int getOprice() {
		return oprice;
	}
	public void setOprice(int oprice) {
		this.oprice = oprice;
	}
	public int getRefund() {
		return refund;
	}
	public void setRefund(int refund) {
		this.refund = refund;
	}
	public int getCancel() {
		return cancel;
	}
	public void setCancel(int cancel) {
		this.cancel = cancel;
	}

	public ProductVO getPvo() {
		return pvo;
	}

	public void setPvo(ProductVO pvo) {
		this.pvo = pvo;
	}

	public int getOpoint() {
		return opoint;
	}

	public void setOpoint(int opoint) {
		this.opoint = opoint;
	}

	public String getRefund_reason() {
		return refund_reason;
	}

	public void setRefund_reason(String refund_reason) {
		this.refund_reason = refund_reason;
	}

	public String getCancel_reason() {
		return cancel_reason;
	}

	public void setCancel_reason(String cancel_reason) {
		this.cancel_reason = cancel_reason;
	}
	
	
}
