package common.model;

public class ReviewVO {  // (오라클로 말하면 제품테이블의 자식테이블)

	private int rnum;            //  리뷰 번호      
	private int odnum;           //  주문번호      
	private int pnum;            //  제품번호      
	private String userid;       //  사용자ID  
	private int score;           //  별점
	private String rsubject;     //  리뷰제목  
	private String rcontent;     //  리뷰내용  
	private String rimage;       //  첨부파일  
	private String odrcode;      //  주문상세번호
	private String writeDate;    //  리뷰 작성일자
	
	private ProductVO prod;      // 상품정보객체    (오라클로 말하면 부모테이블인 상품테이블)
	private OrderDetailVO oddt;  // 주문상세정보객체 (오라클로 말하면 부모테이블인 주문상세테이블)

	public ReviewVO() {}  // 기본생성자
 
	public ReviewVO(int rnum, int odnum, int pnum, String userid, int score, String rsubject, String rcontent,
			String rimage, String odrcode, String writeDate, ProductVO prod, OrderDetailVO oddt) {  // 파라미터 있는 생성자
		this.rnum = rnum;
		this.odnum = odnum;
		this.pnum = pnum;
		this.userid = userid;
		this.score = score;
		this.rsubject = rsubject;
		this.rcontent = rcontent;
		this.rimage = rimage;
		this.odrcode = odrcode;
		this.writeDate = writeDate;
		this.prod = prod;
		this.oddt = oddt;
	}

	
	public int getRnum() {
		return rnum;
	}

	public void setRnum(int rnum) {
		this.rnum = rnum;
	}

	public int getOdnum() {
		return odnum;
	}

	public void setOdnum(int odnum) {
		this.odnum = odnum;
	}

	public int getPnum() {
		return pnum;
	}

	public void setPnum(int pnum) {
		this.pnum = pnum;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public int getScore() {
		return score;
	}

	public void setScore(int score) {
		this.score = score;
	}

	public String getRsubject() {
		return rsubject;
	}

	public void setRsubject(String rsubject) {
		this.rsubject = rsubject;
	}

	public String getRcontent() {
		return rcontent;
	}

	public void setRcontent(String rcontent) {
		this.rcontent = rcontent;
	}

	public String getRimage() {
		return rimage;
	}

	public void setRimage(String rimage) {
		this.rimage = rimage;
	}

	public String getOdrcode() {
		return odrcode;
	}

	public void setOdrcode(String odrcode) {
		this.odrcode = odrcode;
	}

	public String getWriteDate() {
		return writeDate;
	}

	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}

	public ProductVO getProd() {
		return prod;
	}

	public void setProd(ProductVO prod) {
		this.prod = prod;
	}

	public OrderDetailVO getOddt() {
		return oddt;
	}

	public void setOddt(OrderDetailVO oddt) {
		this.oddt = oddt;
	}

	
	
	
	@Override
	public String toString() {
		return "ReviewVO [rnum=" + rnum + ", odnum=" + odnum + ", pnum=" + pnum + ", userid=" + userid + ", score="
				+ score + ", rsubject=" + rsubject + ", rcontent=" + rcontent + ", rimage=" + rimage + ", odrcode="
				+ odrcode + ", writeDate=" + writeDate + ", prod=" + prod + ", oddt=" + oddt + "]";
	}

	
	





	
	
    
}
