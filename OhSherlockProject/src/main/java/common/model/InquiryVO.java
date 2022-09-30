package common.model;

public class InquiryVO {
	
	private int inquiry_no;
	private String fk_userid;
	private String inquiry_type;
	private String inquiry_subject;
	private String inquiry_content;
	private String inquiry_date;
	private int inquiry_answered; // 미답변:0; 답변완료:1
	private int inquiry_email; // 이메일발송거부:0; 이메일발송희망:1
	private int inquiry_sms; // 문자발송거부:0; 문자발송희망:1
	
		
	public InquiryVO() {}

	public InquiryVO(int inquiry_no, String fk_userid, String inquiry_type, String inquiry_subject,
			String inquiry_content, String inquiry_date, int inquiry_answered, int inquiry_email, int inquiry_sms) {
		super();
		this.inquiry_no = inquiry_no;
		this.fk_userid = fk_userid;
		this.inquiry_type = inquiry_type;
		this.inquiry_subject = inquiry_subject;
		this.inquiry_content = inquiry_content;
		this.inquiry_date = inquiry_date;
		this.inquiry_answered = inquiry_answered;
		this.inquiry_email = inquiry_email;
		this.inquiry_sms = inquiry_sms;
	}

	public int getInquiry_no() {
		return inquiry_no;
	}

	public void setInquiry_no(int inquiry_no) {
		this.inquiry_no = inquiry_no;
	}

	public String getFk_userid() {
		return fk_userid;
	}

	public void setFk_userid(String fk_userid) {
		this.fk_userid = fk_userid;
	}

	public String getInquiry_type() {
		return inquiry_type;
	}

	public void setInquiry_type(String inquiry_type) {
		this.inquiry_type = inquiry_type;
	}

	public String getInquiry_subject() {
		return inquiry_subject;
	}

	public void setInquiry_subject(String inquiry_subject) {
		this.inquiry_subject = inquiry_subject;
	}

	public String getInquiry_content() {
		return inquiry_content;
	}

	public void setInquiry_content(String inquiry_content) {
		this.inquiry_content = inquiry_content;
	}

	public String getInquiry_date() {
		return inquiry_date;
	}

	public void setInquiry_date(String inquiry_date) {
		this.inquiry_date = inquiry_date;
	}

	public int getInquiry_answered() {
		return inquiry_answered;
	}

	public void setInquiry_answered(int inquiry_answered) {
		this.inquiry_answered = inquiry_answered;
	}

	public int getInquiry_email() {
		return inquiry_email;
	}

	public void setInquiry_email(int inquiry_email) {
		this.inquiry_email = inquiry_email;
	}

	public int getInquiry_sms() {
		return inquiry_sms;
	}

	public void setInquiry_sms(int inquiry_sms) {
		this.inquiry_sms = inquiry_sms;
	}
	
	
	
}
