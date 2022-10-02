package common.model;

public class CategoryVO {

	private int    cnum;   // 카테고리 대분류 번호
	private String code;   // 카테고리 코드
	private String cname;  // 카테고리명
	
	public CategoryVO() { }
	
	public CategoryVO(int cnum, String code, String cname) {
		this.cnum = cnum;
		this.code = code;
		this.cname = cname;
	}

	public int getCnum() {
		return cnum;
	}

	public void setCnum(int cnum) {
		this.cnum = cnum;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getCname() {
		return cname;
	}

	public void setCname(String cname) {
		this.cname = cname;
	}
	
}
