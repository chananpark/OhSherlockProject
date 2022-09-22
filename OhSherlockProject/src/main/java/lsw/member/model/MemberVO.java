package lsw.member.model;

public class MemberVO {
	
	private String userid;             // 회원아이디
	private String passwd;             // 비밀번호 (SHA-256 암호화 대상)
	private String name;               // 회원명
	private String email;              // 이메일 (AES-256 암호화/복호화 대상)
	private String mobile;             // 연락처 (AES-256 암호화/복호화 대상) 
	private String postcode;           // 우편번호
	private String address;            // 주소
	private String detail_address;     // 상세주소
	private String extra_address;      // 참고항목
	private String gender;             // 성별   선택안함: 0 / 남자:1  / 여자:2
	private String birthday;           // 생년월일   
	private int point;                 // 적립금 
	private int coin;                  // 예치금
	private String registerday;        // 가입일자 
	private int idle;                  // 휴면유무      0: 활동중  /  1 : 휴면중 
	private int status;                // 회원탈퇴유무   1: 사용가능(가입중) / 0:사용불능(탈퇴) 
	private String last_passwd_date;  // 마지막으로 암호를 변경한 날짜  
									   // 마지막으로 로그인 한 날짜시간이 현재시각으로 부터 1년이 지났으면 휴면으로 지정 
	
	
	////////////////////////////////////////////////////////////////////////////
	
	public MemberVO() {}

	public MemberVO(String userid, String passwd, String name, String email, String mobile, String postcode,
					String address, String detail_address, String extra_address, String gender, String birthday) {
		this.userid = userid;
		this.passwd = passwd;
		this.name = name;
		this.email = email;
		this.mobile = mobile;
		this.postcode = postcode;
		this.address = address;
		this.detail_address = detail_address;
		this.extra_address = extra_address;
		this.gender = gender;
		this.birthday = birthday;
	}



	public String getUserid() {
		return userid;
	}


	public void setUserid(String userid) {
		this.userid = userid;
	}


	public String getPasswd() {
		return passwd;
	}


	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public String getEmail() {
		return email;
	}


	public void setEmail(String email) {
		this.email = email;
	}


	public String getMobile() {
		return mobile;
	}


	public void setMobile(String mobile) {
		this.mobile = mobile;
	}


	public String getPostcode() {
		return postcode;
	}


	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}


	public String getAddress() {
		return address;
	}


	public void setAddress(String address) {
		this.address = address;
	}


	public String getDetail_address() {
		return detail_address;
	}


	public void setDetail_address(String detail_address) {
		this.detail_address = detail_address;
	}


	public String getExtra_address() {
		return extra_address;
	}


	public void setExtra_address(String extra_address) {
		this.extra_address = extra_address;
	}


	public String getGender() {
		return gender;
	}


	public void setGender(String gender) {
		this.gender = gender;
	}


	public String getBirthday() {
		return birthday;
	}


	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}


	public int getPoint() {
		return point;
	}


	public void setPoint(int point) {
		this.point = point;
	}


	public int getCoin() {
		return coin;
	}


	public void setCoin(int coin) {
		this.coin = coin;
	}


	public String getRegisterday() {
		return registerday;
	}


	public void setRegisterday(String registerday) {
		this.registerday = registerday;
	}


	public int getIdle() {
		return idle;
	}


	public void setIdle(int idle) {
		this.idle = idle;
	}


	public int getStatus() {
		return status;
	}


	public void setStatus(int status) {
		this.status = status;
	}


	public String getLast_passwd_date() {
		return last_passwd_date;
	}


	public void setLast_passwd_date(String last_passwd_date) {
		this.last_passwd_date = last_passwd_date;
	}
	
	
}