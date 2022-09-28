package lye.member.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.sql.*;
import java.util.Map;

import javax.naming.*;
import javax.sql.DataSource;

import common.model.MemberVO;
import util.security.AES256;
import util.security.SecretMyKey;
import util.security.Sha256;

public class MemberDAO implements InterMemberDAO {

   private DataSource ds;             
   private Connection conn;         
   private PreparedStatement pstmt; 
   private ResultSet rs;            
   
   private AES256 aes;   // 양방향 암호화 초기화
   
   // 생성자 (프로젝트용)
   public MemberDAO() {	
		try {
			Context initContext = new InitialContext();
		    Context envContext  = (Context)initContext.lookup("java:/comp/env");
		    ds = (DataSource)envContext.lookup("jdbc/myprjoracle");
	
		    aes = new AES256(SecretMyKey.KEY);
		    // SecretMyKey.KEY: 우리가 만든 비밀키
	
		} catch(NamingException e) {
			e.printStackTrace();
		} catch(UnsupportedEncodingException e) {
			e.printStackTrace();
		}
   }
   
   
   // 사용한 자원을 반납하는 close() 메소드 생성하기
   private void close() {
      
      try {
         
         if( rs != null ) { rs.close(); rs=null; }           
         if( pstmt != null ) { pstmt.close(); pstmt=null; }  
         if( conn != null ) { conn.close(); conn=null; }     
         
      } catch(SQLException e) {
         e.printStackTrace();
      }
      
   }

	
	// 아이디 찾기(성명, 이메일을 입력받아서 해당 사용자의 아이디를 알려준다)
	@Override
	public String idFind(Map<String, String> paraMap) throws SQLException {
		
		String userid = null; 
		
		try {
			conn = ds.getConnection(); 
			
			String sql = " select userid "
					   + " from tbl_member "
					   + " where status = 1 and name = ? and email = ? ";  // status(회원탈퇴유무) 1: 사용가능(가입중)
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("name") );               
			pstmt.setString(2, aes.encrypt(paraMap.get("email")) );  
			
			rs = pstmt.executeQuery();  
			
			if(rs.next()) {
				userid = rs.getString(1);
			}
			
		} catch(GeneralSecurityException | UnsupportedEncodingException e) {  // "|" 는 또는 이라는 의미임.
			e.printStackTrace();
		} finally {
			close();
		}
		
		return userid;
	}// end of public String idFind(Map<String, String> paraMap) throws SQLException------------

	
	// 회원의 개인정보 변경시 현재 그 회원이 사용중인 email 을 제외한 나머지 email 에서
	// email 중복검사 (tbl_member 테이블에서 email 이 존재하면 true를 리턴해주고, email 이 존재하지 않으면 false를 리턴한다)
	@Override
	public boolean emailDuplicateCheck_2(Map<String, String> paraMap) throws SQLException {
		
		boolean isExists = false;  // 초기값
		
		try {
			conn = ds.getConnection();  // 커넥션풀 방식 연결
			
			String sql = " select email "
					   + " from tbl_member "
					   + " where userid != ? and email = ? ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, paraMap.get("userid"));                // 1번째 위치홀더(?), userid
			pstmt.setString(2, aes.encrypt(paraMap.get("email")) );   // 2번째 위치홀더(?), 양방향암호화된 email
			
			rs = pstmt.executeQuery();  // 자원 저장소(결과값)
			
			isExists = rs.next(); // 행이 있으면(중복된 email) true ,
			                      // 행이 없으면(사용가능한 email) false 
			
		} catch(GeneralSecurityException | UnsupportedEncodingException e) {  // "|" 는 또는 이라는 의미임.
			e.printStackTrace();
		} finally {
			close();
		}
		
		return isExists;
	}// end of public boolean emailDuplicateCheck_2(Map<String, String> paraMap) throws SQLException {}-------------------

	
	// 회원의 개인정보 변경하기
	@Override
	public int updateMember(MemberVO member) throws SQLException {

		int result = 0;  // 업데이트 성공하면 n==1, 실패하면 n==0
		
	//	System.out.println("~~확인용" +member.toString());
		
		try {
			conn = ds.getConnection();  
			
			String sql = " update tbl_member set name = ? "
					   + "                     , passwd = ? "
					   + "                     , email = ? "
					   + "                     , mobile = ? "
					   + "                     , postcode = ? "
					   + "                     , address = ? "
					   + "                     , detail_address = ? "
					   + "                     , extra_address = ? "
					   + "                     , birthday = ? "
					   + "                     , last_passwd_date = sysdate "
					   + " where userid = ? ";
			
			pstmt = conn.prepareStatement(sql);  
			
			pstmt.setString(1, member.getName());    // 1번째 ?, MemberVO의 객체 member 을 통해 getName() 불러옴.(파라미터있는 생성자를 통해 파라미터에 다 넣어줌.) 
			pstmt.setString(2, Sha256.encrypt(member.getPasswd()) );    // 암호를 SHA256 알고리즘으로 단방향 암호화 시킨다. 단방향 암호화는 한번 암호화시키면 못 푼다. 
			pstmt.setString(3, aes.encrypt(member.getEmail()) );     // 이메일을 AES256 알고리즘으로 양방향 암호화 시킨다. 양방향 암호화는 암호화시켜도 풀 수 있다.
			pstmt.setString(4, aes.encrypt(member.getMobile()) );    // 휴대폰번호를 AES256 알고리즘으로 양방향 암호화 시킨다. 양방향 암호화는 암호화시켜도 풀 수 있다.
	        pstmt.setString(5, member.getPostcode());
	        pstmt.setString(6, member.getAddress());
	        pstmt.setString(7, member.getDetail_address());
	        pstmt.setString(8, member.getExtra_address());
	        pstmt.setString(9, member.getBirthday());
	        pstmt.setString(10, member.getUserid());  
			
	        result = pstmt.executeUpdate();  // update 한 것을 result에 넣어줌.
			
		} catch(GeneralSecurityException | UnsupportedEncodingException e) { // "|" 는 또는 이라는 의미임.
	         e.printStackTrace();
	    } finally {
			 close();
		}
		
		return result;
	}// end of public int updateMember(MemberVO member) throws SQLException {}-----------

	
	// 회원의 개인정보 변경하기 - 이메일 인증하기
	@Override
	public boolean isUserEmailExist(Map<String, String> paraMap) throws SQLException {
		
		boolean isUserEmailExist = false;  // 초기화값
		
		try {
			conn = ds.getConnection();  // 커넥션풀 방식 연결
			
			String sql = " select userid "
					   + " from tbl_member "
					   + " where status = 1 and userid != ? and email = ? ";  // status(회원탈퇴유무) 1: 사용가능(가입중)
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("userid") );                // 1번째 위치홀더(?),  paraMap 에 있는 key값("name")
			pstmt.setString(2, aes.encrypt(paraMap.get("email")) );  // 2번째 위치홀더(?),  양방향암호화된 paraMap 에 있는 key값("email")
			
			rs = pstmt.executeQuery();  // 자원 저장소(결과값)
			
			isUserEmailExist = rs.next();    // 있으면 true, 없으면 false
			
		} catch(GeneralSecurityException | UnsupportedEncodingException e) {  // "|" 는 또는 이라는 의미임.
			e.printStackTrace();
		} finally {
			close();
		}
		
		return isUserEmailExist;
		
	}// end of public boolean isUserEmailExist(Map<String, String> paraMap) throws SQLException {}------------

	
	// 회원탈퇴하기
	@Override
	public int deleteMember(String userid) throws SQLException {
		
		int result = 0;  // 업데이트 성공하면 n==1, 실패하면 n==0
		
	//	System.out.println("확인용 ==> " +userid);
		
		try {
			conn = ds.getConnection();  
			
			String sql = " update tbl_member set status = 0 "
					   + " where userid = ? ";
			
			pstmt = conn.prepareStatement(sql);  
			
	        pstmt.setString(1, userid);  
			
	        result = pstmt.executeUpdate();
			
		} finally {
			 close();
		}
		
		return result;
	}// end of public int deleteMember(MemberVO member) throws SQLException {}------------



	
}