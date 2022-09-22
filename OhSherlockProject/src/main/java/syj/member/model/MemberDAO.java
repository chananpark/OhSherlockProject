package syj.member.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import util.security.AES256;
import util.security.SecretMyKey;
import util.security.Sha256;

public class MemberDAO implements InterMemberDAO {

	private DataSource ds;	// tomcat에서 제공하는 DBCP(DB connection pool) 이다.
	// import javax.sql.DataSource; 로 import 
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private AES256 aes;
	
	// 생성자
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

	
	// 비밀번호 찾기(아이디, 이메일, 이름을 입력받아서 해당 사용자의 비밀번호를 알려준다.)
	@Override
	public boolean isUserExist(Map<String, String> paraMap) throws SQLException {

		boolean isUserExist = false;
		
		try {
			conn = ds.getConnection();
			
			System.out.println(paraMap.get("userid"));
			
			String sql = " select userid " +
						 " from tbl_member " +
						 " where status = 1 and userid = ? and email = ? and name = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("userid") ); // key 값으로 넣어준 name 을 넣어준다.
			pstmt.setString(2, aes.encrypt(paraMap.get("email")) ); // 양방향 암호화 이기 때문에 다시 암호화를 풀어주어야 한다. 
			pstmt.setString(3, paraMap.get("name") );
			
			rs = pstmt.executeQuery();
			
			isUserExist = rs.next();
			System.out.println(isUserExist);
			
		} catch(GeneralSecurityException | UnsupportedEncodingException e) { // 
			e.printStackTrace();
		} finally {
			close();
		}
		
		return isUserExist;
	} // end of public boolean isUserExist(Map<String, String> paraMap) throws SQLException


	//비밀번호 변경하기
	@Override
	public int passwdUpdate(Map<String, String> paraMap) throws SQLException {
		int result = 0;
      
		try {
			conn = ds.getConnection();
         
			String sql = " update tbl_member set passwd = ?, last_passwd_date = sysdate "
					   + " where userid = ? ";
			pstmt = conn.prepareStatement(sql);
         
			pstmt.setString(1, Sha256.encrypt(paraMap.get("passwd")) ); // 암호화해서 데이터베이스에 들어가야한다. 단방향 암호화 
			pstmt.setString(2, paraMap.get("userid"));
         
			result = pstmt.executeUpdate(); // 0 아니면 1이 나와서 result 에 넣어준다.
         
		} finally {
			close();
		}
      
		return result;
	
	}//end of public int passwdUpdate(Map<String, String> paraMap) throws SQLException

	
	
	
	
	
} // end of MemberDAO
