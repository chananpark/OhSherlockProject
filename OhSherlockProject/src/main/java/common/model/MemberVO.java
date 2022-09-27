package common.model;

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
   private String gender;             // 성별   남자:1  / 여자:2
   private String birthday;           // 생년월일   
   private int point;                 // 포인트 
   private int coin;                  // 예치금
   private String registerday;        // 가입일자 
   private int idle;                  // 휴면유무 (0: 활동중 / 1: 휴면) 마지막으로 로그인 한 날짜시간이 현재시각으로 부터 1년이 지났으면 휴면으로 지정 
   private int status;                // 회원탈퇴유무 (1: 가입중 / 0:탈퇴)
   private String last_passwd_date;   // 마지막 비밀번호 변경 날짜  
    
   /////////////////////////////////////////////////////////////////////////////
   
   private boolean passwdChangeRequired = false;
   // 마지막으로 암호를 변경한지 3개월이 지났으면 true
   // 마지막으로 암호를 변경한지 3개월이 지나지 않았으면 false
   
   private String last_login_date;      // 마지막으로 로그인한 날짜
   
   /////////////////////////////////////////////////////////////////////////////
   
   public MemberVO() {}
   
    /////////////////////////////////////////////////////////////////////////////
   
   public MemberVO(String userid, String passwd, String name, String email, String mobile, String postcode,
         String address, String detail_address, String extra_address, String gender, String birthday, int point,
         int coin, String registerday, int idle, int status, String last_passwd_date, boolean passwdChangeRequired) {
      super();
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
      this.point = point;
      this.coin = coin;
      this.registerday = registerday;
      this.idle = idle;
      this.status = status;
      this.last_passwd_date = last_passwd_date;
      this.passwdChangeRequired = passwdChangeRequired;
   }

   // 나의정보수정 생성자
      public MemberVO(String userid, String passwd, String name, String postcode, String address,
            String detail_address, String extra_address, String birthday, String mobile, String email) {
         
         this.userid = userid;
         this.passwd = passwd;
         this.name = name;
         this.postcode = postcode;
         this.address = address;
         this.detail_address = detail_address;
         this.extra_address = extra_address;
         this.birthday = birthday;
         this.mobile = mobile;
         this.email = email;
         
      }
      
      // 회원가입 생성자(임선우)
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

    /////////////////////////////////////////////////////////////////////////////

   public boolean isPasswdChangeRequired() {
      return passwdChangeRequired;
   }

   public void setPasswdChangeRequired(boolean passwdChangeRequired) {
      this.passwdChangeRequired = passwdChangeRequired;
   }

   public String getLast_login_date() {
      return last_login_date;
   }

   public void setLast_login_date(String last_login_date) {
      this.last_login_date = last_login_date;
   }
   
}