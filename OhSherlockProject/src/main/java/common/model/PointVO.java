package common.model;

public class PointVO {

	private int pointno;             // 포인트내역식별번호
	private String fk_userid;        // 회원아이디
	private String point_date;       // 날짜      
	private int point_amount;        // 금액
	
	
	
	/////////////////////////////////////////////////////////////////////////////	
	
	public PointVO() {
	}
	

	public PointVO(int pointno, String fk_userid, String point_date, int point_amount) {
		this.pointno = pointno;
		this.fk_userid = fk_userid;
		this.point_date = point_date;
		this.point_amount = point_amount;
	}


	public int getPointno() {
		return pointno;
	}


	public void setPointno(int pointno) {
		this.pointno = pointno;
	}


	public String getFk_userid() {
		return fk_userid;
	}


	public void setFk_userid(String fk_userid) {
		this.fk_userid = fk_userid;
	}


	public String getPoint_date() {
		return point_date;
	}


	public void setPoint_date(String point_date) {
		this.point_date = point_date;
	}


	public int getPoint_amount() {
		return point_amount;
	}


	public void setPoint_amount(int point_amount) {
		this.point_amount = point_amount;
	}




	
	
	

	
	
	
}
