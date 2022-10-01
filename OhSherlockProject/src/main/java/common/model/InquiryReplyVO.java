package common.model;

public class InquiryReplyVO {

	private int inquiry_reply_no;
	private int fk_inquiry_no;
	private String inquiry_reply_content;
	private String inquiry_reply_date;
	
	public int getInquiry_reply_no() {
		return inquiry_reply_no;
	}
	public void setInquiry_reply_no(int inquiry_reply_no) {
		this.inquiry_reply_no = inquiry_reply_no;
	}
	public int getFk_inquiry_no() {
		return fk_inquiry_no;
	}
	public void setFk_inquiry_no(int fk_inquiry_no) {
		this.fk_inquiry_no = fk_inquiry_no;
	}
	public String getInquiry_reply_content() {
		return inquiry_reply_content;
	}
	public void setInquiry_reply_content(String inquiry_reply_content) {
		this.inquiry_reply_content = inquiry_reply_content;
	}
	public String getInquiry_reply_date() {
		return inquiry_reply_date;
	}
	public void setInquiry_reply_date(String inquiry_reply_date) {
		this.inquiry_reply_date = inquiry_reply_date;
	}
	
}
