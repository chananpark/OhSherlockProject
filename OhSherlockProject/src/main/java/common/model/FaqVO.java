package common.model;

import java.util.Date;

public class FaqVO {
	
	private int faq_num;         
	private String faq_category; 
	private String faq_subject;          
	private String faq_content;        
	
	public FaqVO() {}
	
	public FaqVO(int faq_num, String faq_category, String faq_subject, String faq_content) {
		super();
		this.faq_num = faq_num;
		this.faq_category = faq_category;
		this.faq_subject = faq_subject;
		this.faq_content = faq_content;
	}

	// 게터세터
	public int getFaq_num() {
		return faq_num;
	}

	public void setFaq_num(int faq_num) {
		this.faq_num = faq_num;
	}

	public String getFaq_category() {
		return faq_category;
	}

	public void setFaq_category(String faq_category) {
		this.faq_category = faq_category;
	}

	public String getFaq_subject() {
		return faq_subject;
	}

	public void setFaq_subject(String faq_subject) {
		this.faq_subject = faq_subject;
	}

	public String getFaq_content() {
		return faq_content;
	}

	public void setFaq_content(String faq_content) {
		this.faq_content = faq_content;
	}
	
	
	
}
