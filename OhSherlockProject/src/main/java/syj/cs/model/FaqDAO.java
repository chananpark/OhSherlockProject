package syj.cs.model;

import java.sql.*;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class FaqDAO implements InterFaqDAO {

	private DataSource ds;  // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool) 이다.  
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	 
	// 생성자
	public FaqDAO() {
		
		try {
			Context initContext = new InitialContext();
		    Context envContext  = (Context)initContext.lookup("java:/comp/env");
		    ds = (DataSource)envContext.lookup("jdbc/myprjoracle");
		    
		} catch(NamingException e) {
			e.printStackTrace();
		} 
	}
	
	// 자원 반납 메소드
	private void close() {
		try {
			if(rs != null)    {rs.close();    rs=null;}
			if(pstmt != null) {pstmt.close(); pstmt=null;}
			if(conn != null)  {conn.close();  conn=null;}
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}

	//////////////////////////////////////////////////////////////////////////
	
	// 자주묻는질문 공지사항 작성하기
	@Override
	public int registerFaq(Map<String, String> paraMap) throws SQLException {
		
		int n = 0;

		try {
			conn = ds.getConnection();

			String sql = " insert into tbl_faq(faq_num, faq_category, faq_subject, faq_content) "+
						 " values(seq_faq.nextval, ?, ?, ?) ";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("faq_category"));
			pstmt.setString(2, paraMap.get("title"));
			pstmt.setString(3, paraMap.get("content"));
			n = pstmt.executeUpdate();

		} finally {
			close();
		}	
		
		return n;
	} // end of public int registerFaq(Map<String, String> paraMap) throws SQLException

	
	
	
	
	
	
	
	
	
	
}
