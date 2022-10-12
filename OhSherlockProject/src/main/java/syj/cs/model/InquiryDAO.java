package syj.cs.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import common.model.InquiryVO;

public class InquiryDAO implements InterInquiryDAO {
	
	private DataSource ds;  // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool) 이다.  
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	 
	// 생성자
	public InquiryDAO() {
		
		try {
			Context initContext = new InitialContext();
		    Context envContext  = (Context)initContext.lookup("java:/comp/env");
		    ds = (DataSource)envContext.lookup("jdbc/myprjoracle");
		    
		    //aes = new AES256(SecretMyKey.KEY);
		    
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

	
	//////////////////////////////////////
	// 1대1문의 질문 리스트 3개
	@Override
	public List<InquiryVO> mypageInquiryList(String userid) throws SQLException {
		List<InquiryVO> inquiryList = new ArrayList<>();
		try {
			
			conn = ds.getConnection();

			String sql = "select rownum, inquiry_no, fk_userid, inquiry_type, inquiry_subject, inquiry_content, to_char(inquiry_date,'yyyy.MM.dd') as inquiry_date\n"+
			"from\n"+
			"(select  inquiry_no, fk_userid, inquiry_type, inquiry_subject, inquiry_content, inquiry_date\n"+
			"from tbl_inquiry\n"+
			"where fk_userid= ? \n"+
			"order by inquiry_date desc)\n"+
			"where rownum between 1 and 3";
			
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userid);
	        rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            InquiryVO ivo = new InquiryVO();
	            
	            ivo.setInquiry_type(rs.getString("inquiry_type"));
	            ivo.setInquiry_subject(rs.getString("inquiry_subject"));
	            ivo.setInquiry_date(rs.getString("inquiry_date"));
	            ivo.setInquiry_no(rs.getInt("inquiry_no"));
	            ivo.setFk_userid(rs.getString("fk_userid"));
	            
	            inquiryList.add(ivo);
	        }
	        
		} finally {
	        close();
	    }
		
		return inquiryList;
	
	} // end of public List<InquiryVO> mypageInquiryList() throws SQLException 
	
	
	
	
	
	
	
}
