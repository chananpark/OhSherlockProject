package common.model;

public class ProductVO {

	private int pnum;             				// 상품코드(PK)
	private String pname;             			// 상품명
	private int fk_cnum;         				// 스펙번호(FK)
	private String pimage;        				// 썸네일이미지
	private String prdmanual_systemfilename;	// 시스템파일명
	private String prdmanual_orginfilename;		// 오리진파일명
	private int pqty;               			// 재고 
	private int price;               			// 상품가격
	private int saleprice;       				// 판매가격
	private int fk_snum;               			// 베스트여부
	private String pcontent;             		// 상품설명
	private String psummary;            		// 상품한줄소개
	private int point;							// 적립금액수
	private String pinputdate; 					// 등록일자
	
	private CategoryVO categvo; // 카테고리VO 
	private SpecVO spvo;        // 스펙VO 
	
	/*
	    제품판매가와 포인트점수 컬럼의 값은 관리자에 의해서 변경(update)될 수 있으므로
	    해당 제품의 판매총액과 포인트부여 총액은 판매당시의 제품판매가와 포인트 점수로 구해와야 한다.  
	*/
	private int totalPrice;         // 판매당시의 제품판매가 * 주문량
	private int totalPoint;         // 판매당시의 포인트점수 * 주문량 
		
	
	public ProductVO() {
	}
	
	// 상품 등록
	
	public ProductVO(int pnum, String pname, int fk_cnum, String pimage, String prdmanual_systemfilename,
					String prdmanual_orginfilename, int pqty, int price, int saleprice, int fk_snum,
					String pcontent, String psummary, int point, String pinputdate) {
		this.pnum = pnum;
		this.pname = pname;
		this.fk_cnum = fk_cnum;
		this.pimage = pimage;
		this.prdmanual_systemfilename = prdmanual_systemfilename;
		this.prdmanual_orginfilename = prdmanual_orginfilename;
		this.pqty = pqty;
		this.price = price;
		this.saleprice = saleprice;
		this.fk_snum = fk_snum;
		this.pcontent = pcontent;
		this.psummary = psummary;
		this.point = point;
		this.pinputdate = pinputdate;
	}

	public int getPnum() {
		return pnum;
	}
	public void setPnum(int pnum) {
		this.pnum = pnum;
	}
	public String getPname() {
		return pname;
	}
	public void setPname(String pname) {
		this.pname = pname;
	}
	public int getFk_cnum() {
		return fk_cnum;
	}
	public void setFk_cnum(int fk_cnum) {
		this.fk_cnum = fk_cnum;
	}
	public String getPimage() {
		return pimage;
	}
	public void setPimage(String pimage) {
		this.pimage = pimage;
	}
	public String getPrdmanual_systemfilename() {
		return prdmanual_systemfilename;
	}
	public void setPrdmanual_systemfilename(String prdmanual_systemfilename) {
		this.prdmanual_systemfilename = prdmanual_systemfilename;
	}
	public String getPrdmanual_orginfilename() {
		return prdmanual_orginfilename;
	}
	public void setPrdmanual_orginfilename(String prdmanual_orginfilename) {
		this.prdmanual_orginfilename = prdmanual_orginfilename;
	}
	public int getPqty() {
		return pqty;
	}
	public void setPqty(int pqty) {
		this.pqty = pqty;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public int getSaleprice() {
		return saleprice;
	}
	public void setSaleprice(int saleprice) {
		this.saleprice = saleprice;
	}
	public int getFk_snum() {
		return fk_snum;
	}
	public void setFk_snum(int fk_snum) {
		this.fk_snum = fk_snum;
	}
	public String getPcontent() {
		return pcontent;
	}
	public void setPcontent(String pcontent) {
		this.pcontent = pcontent;
	}
	public String getPsummary() {
		return psummary;
	}
	public void setPsummary(String psummary) {
		this.psummary = psummary;
	}
	public int getPoint() {
		return point;
	}
	public void setPoint(int point) {
		this.point = point;
	}
	public String getPinputdate() {
		return pinputdate;
	}
	public void setPinputdate(String pinputdate) {
		this.pinputdate = pinputdate;
	}
	
	public CategoryVO getCategvo() {
		return categvo;
	}

	public void setCategvo(CategoryVO categvo) {
		this.categvo = categvo;
	}

	public SpecVO getSpvo() {
		return spvo;
	}

	public void setSpvo(SpecVO spvo) {
		this.spvo = spvo;
	}
	
	///////////////////////////////////////////////
	// *** 제품의 할인률 ***
	public int getDiscountPercent() {
	// 정가   :  판매가 = 100 : x
	
	// 5000 : 3800 = 100 : x
	// x = (3800*100)/5000 
	// x = 76
	// 100 - 76 ==> 24% 할인
	
	// 할인률 = 100 - (판매가 * 100) / 정가
	return 100 - (saleprice * 100)/price;
	}
	
	
	/////////////////////////////////////////////////
	// *** 제품의 총판매가(실제판매가 * 주문량) 구해오기 ***
	public void setTotalPriceTotalPoint(int oqty) {   
	// int oqty 이 주문량이다.
	
	totalPrice = saleprice * oqty; // 판매당시의 제품판매가 * 주문량
	totalPoint = point * oqty;     // 판매당시의 포인트점수 * 주문량 
	}
	
	public int getTotalPrice() {
	return totalPrice;
	}
	
	public int getTotalPoint() {
	return totalPoint;
	}


	
}
