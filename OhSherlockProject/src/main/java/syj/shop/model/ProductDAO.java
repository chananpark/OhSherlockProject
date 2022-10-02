package syj.shop.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import common.model.MemberVO;
import common.model.ProductVO;
import util.security.AES256;
import util.security.SecretMyKey;

public class ProductDAO implements InterProductDAO {

	private DataSource ds;	// tomcat에서 제공하는 DBCP(DB connection pool) 이다.
	// import javax.sql.DataSource; 로 import 
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	private AES256 aes;
	
	// 생성자
	public ProductDAO() {	
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
	
	// 상품 전체 리스트 불러오기
	@Override
	public List<ProductVO> selectProduct() throws SQLException {

		ProductVO product = null;
		
		try {
			conn = ds.getConnection();
					
			String sql = "select userid, name, mobile, email, postcode, (address || ' ' || detail_address || ' ' || extra_address) as address, birthday, gender, coin, point, registerday\n"+
					     "from tbl_member\n"+
						 "where userid = ? ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, paraMap.get("userid"));
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				
				// select 해서 가져올 게 있냐
				member = new MemberVO();
				
				member.setUserid(rs.getString(1));
				member.setName(rs.getString(2));
				member.setMobile(aes.decrypt(rs.getString(3)) ); // 복호화
				member.setEmail(aes.decrypt(rs.getString(4)) ); // 복호화
	            member.setPostcode(rs.getString(5));
	            member.setAddress(rs.getString(6));
	            member.setBirthday(rs.getString(7));
	            member.setGender(rs.getString(8));
	            member.setCoin(rs.getInt(9));
	            member.setPoint(rs.getInt(10));
	            member.setRegisterday(rs.getString(11));
				
			} // end of if(rs.next())
			
			
		} catch(GeneralSecurityException | UnsupportedEncodingException e) { // 
			e.printStackTrace();
		} finally {
			close();
		}
	
		return member;
		
		
		return null;
	} // end of public List<ProductVO> selectProduct() throws SQLException

}
