package common.model;

import common.model.ProductVO;

public class LikeVO {  // (오라클로 말하면 제품테이블의 자식테이블)

	private int likeno;      //  찜목록 번호        
    private String userid;   //  사용자ID            
    private int pnum;        //  제품번호                
    private int oqty;        //  주문량 
    
    private ProductVO prod;  // 제품정보객체 (오라클로 말하면 부모테이블인 제품테이블)


	public LikeVO() {} // 기본생성자
    
	public LikeVO(int likeno, String userid, int pnum, ProductVO prod) { // 파라미터 있는 생성자
		this.likeno = likeno;
		this.userid = userid;
		this.pnum = pnum;
		this.prod = prod;
	}

	public int getLikeno() {
		return likeno;
	}

	public void setLikeno(int likeno) {
		this.likeno = likeno;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public int getPnum() {
		return pnum;
	}

	public void setPnum(int pnum) {
		this.pnum = pnum;
	}

	public ProductVO getProd() {
		return prod;
	}

	public void setProd(ProductVO prod) {
		this.prod = prod;
	}
	
	public int getOqty() {
		return oqty;
	}

	public void setOqty(int oqty) {
		this.oqty = oqty;
	} 

	@Override
	public String toString() {
		return "LikeVO [likeno=" + likeno + ", userid=" + userid + ", pnum=" + pnum + ", prod=" + prod + "]";
	}

	
	
	
    
    
    
    
    
    
}
