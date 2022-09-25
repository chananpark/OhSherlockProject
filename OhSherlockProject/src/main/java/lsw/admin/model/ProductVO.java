package lsw.admin.model;

public class ProductVO {

	private String p_code;             // 상품코드
	private String p_category;         // 카테고리
	private String p_name;             // 상품명      
	private int p_price;               // 상품가격
	private String p_discount_rate;       // 할인율
	private int p_stock;               // 재고 
	private int p_soldout;             // 품절여부
	private int p_best;                // 베스트여부
	private String p_info;             // 상품한줄소개
	private String p_desc;             // 상품설명
	private String p_thumbnail;        // 썸네일이미지
	private String p_image;            // 첨부이미지
	private String p_registerday;	   // 상품등록일자 
	
	
	public ProductVO() {
	}

	// 상품 등록
	public ProductVO(String p_code, String p_category, String p_name, int p_price, String p_discount_rate, int p_stock,
					 String p_info, String p_desc, String p_thumbnail, String p_image) {
		this.p_code = p_code;
		this.p_category = p_category;
		this.p_name = p_name;
		this.p_price = p_price;
		this.p_discount_rate = p_discount_rate;
		this.p_stock = p_stock;
		this.p_info = p_info;
		this.p_desc = p_desc;
		this.p_thumbnail = p_thumbnail;
		this.p_image = p_image;
	}
	
	


	public String getP_code() {
		return p_code;
	}
	public void setP_code(String p_code) {
		this.p_code = p_code;
	}
	public String getP_category() {
		return p_category;
	}
	public void setP_category(String p_category) {
		this.p_category = p_category;
	}
	public String getP_name() {
		return p_name;
	}
	public void setP_name(String p_name) {
		this.p_name = p_name;
	}
	public int getP_price() {
		return p_price;
	}
	public void setP_price(int p_price) {
		this.p_price = p_price;
	}
	public String getP_discount_rate() {
		return p_discount_rate;
	}
	public void setP_discount_rate(String p_discount_rate) {
		this.p_discount_rate = p_discount_rate;
	}
	public int getP_stock() {
		return p_stock;
	}
	public void setP_stock(int p_stock) {
		this.p_stock = p_stock;
	}
	public int getP_soldout() {
		return p_soldout;
	}
	public void setP_soldout(int p_soldout) {
		this.p_soldout = p_soldout;
	}
	public int getP_best() {
		return p_best;
	}
	public void setP_best(int p_best) {
		this.p_best = p_best;
	}
	public String getP_info() {
		return p_info;
	}
	public void setP_info(String p_info) {
		this.p_info = p_info;
	}
	public String getP_desc() {
		return p_desc;
	}
	public void setP_desc(String p_desc) {
		this.p_desc = p_desc;
	}
	public String getP_thumbnail() {
		return p_thumbnail;
	}
	public void setP_thumbnail(String p_thumbnail) {
		this.p_thumbnail = p_thumbnail;
	}
	public String getP_image() {
		return p_image;
	}
	public void setP_image(String p_image) {
		this.p_image = p_image;
	}
	public String getP_registerday() {
		return p_registerday;
	}
	public void setP_registerday(String p_registerday) {
		this.p_registerday = p_registerday;
	}
	
	
	
	
	
}
