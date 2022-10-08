package common.model;
import java.util.Date;

public class NoticeVO {
	private int noticeNo;         
	private String noticeSubject; 
	private String noticeContent;          
	private int noticeHit;        
	private Date noticeDate;           
	private String noticeImage;
	private String systemFileName;
	private String originFileName;
	
	//////////////////////////////
	
	private boolean isFresh = false; // 최신 게시글 여부
	
	//////////////////////////////
	
	public NoticeVO() {}

	public NoticeVO(int noticeNo, String noticeSubject, String noticeContent, int noticeHit, Date noticeDate,
			String noticeImage, String systemFileName, String originFileName, boolean isFresh) {
		super();
		this.noticeNo = noticeNo;
		this.noticeSubject = noticeSubject;
		this.noticeContent = noticeContent;
		this.noticeHit = noticeHit;
		this.noticeDate = noticeDate;
		this.noticeImage = noticeImage;
		this.systemFileName = systemFileName;
		this.originFileName = originFileName;
		this.isFresh = isFresh;
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

	public Date getNoticeDate() {
		return noticeDate;
	}

	public void setNoticeDate(Date noticeDate) {
		this.noticeDate = noticeDate;
	}

	public String getNoticeImage() {
		return noticeImage;
	}

	public void setNoticeImage(String noticeImage) {
		this.noticeImage = noticeImage;
	}

	public String getSystemFileName() {
		return systemFileName;
	}

	public void setSystemFileName(String systemFileName) {
		this.systemFileName = systemFileName;
	}

	public String getOriginFileName() {
		return originFileName;
	}

	public void setOriginFileName(String originFileName) {
		this.originFileName = originFileName;
	}

	public boolean isFresh() {
		return isFresh;
	}

	public void setFresh(boolean isFresh) {
		this.isFresh = isFresh;
	}
	
	
}
