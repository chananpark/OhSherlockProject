package pca.cs.model;

public class NoticeVO {
	private int noticeNo;         
	private String noticeSubject; 
	private String noticeContent;          
	private int noticeHit;        
	private String noticeDate;           
	private String noticeFile;
	
	public NoticeVO() {}
	
	public NoticeVO(int noticeNo, String noticeSubject, String noticeContent, int noticeHit, String noticeDate,
			String noticeFile) {
		super();
		this.noticeNo = noticeNo;
		this.noticeSubject = noticeSubject;
		this.noticeContent = noticeContent;
		this.noticeHit = noticeHit;
		this.noticeDate = noticeDate;
		this.noticeFile = noticeFile;
	}
	
	public int getNoticeNo() {
		return noticeNo;
	}
	public void setNoticeNo(int noticeNo) {
		this.noticeNo = noticeNo;
	}
	public String getNoticeSubject() {
		return noticeSubject;
	}
	public void setNoticeSubject(String noticeSubject) {
		this.noticeSubject = noticeSubject;
	}
	public String getNoticeContent() {
		return noticeContent;
	}
	public void setNoticeContent(String noticeContent) {
		this.noticeContent = noticeContent;
	}
	public int getNoticeHit() {
		return noticeHit;
	}
	public void setNoticeHit(int noticeHit) {
		this.noticeHit = noticeHit;
	}
	public String getNoticeDate() {
		return noticeDate;
	}
	public void setNoticeDate(String noticeDate) {
		this.noticeDate = noticeDate;
	}
	public String getNoticeFile() {
		return noticeFile;
	}
	public void setNoticeFile(String noticeFile) {
		this.noticeFile = noticeFile;
	}
	
}
