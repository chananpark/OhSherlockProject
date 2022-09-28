package kcy.mypage.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.sql.*;
import java.util.Map;

import javax.naming.*;
import javax.sql.DataSource;

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


	// 회원의 coin 및 포인트 변경하기 및 내역 inser하기
		@Override
		public int coinUpdate(Map<String, String> paraMap) throws SQLException {

	        int result = 0;
	        
	        try {
				 conn = ds.getConnection();
				 
				 String sql = " update tbl_member set coin = coin + ? , point = point + ? "
				 		    + " where userid = ? ";
				 
				 pstmt = conn.prepareStatement(sql);
				 
				 pstmt.setInt(1, Integer.parseInt(paraMap.get("coinmoney")) );
				 pstmt.setInt(2, (int)(Integer.parseInt(paraMap.get("coinmoney")) * 0.01) );  // 300000 * 0.01 ==> 3000.0 ==> (int)3000.0 ==> 3000
				 pstmt.setString(3, paraMap.get("userid"));
				 
				 result = pstmt.executeUpdate();
				 
				 if(result==1) {
					 // insert하는 코드
					 
					sql = " insert into tbl_coin_history(COINNO, FK_USERID, COIN_AMOUNT) "
					    + " values(seq_coin_history.nextval, ?, ? ) ";
					
					pstmt = conn.prepareStatement(sql);
					
					pstmt.setString(1, paraMap.get("userid"));
					pstmt.setInt(2, Integer.parseInt(paraMap.get("coinmoney")));
					
					result = pstmt.executeUpdate();
					 
				 }
				 
			} finally {
				close();
			}
	        
			return result;
		}// end of public int coinUpdate(Map<String, String> paraMap) throws SQLException-------  


	
}